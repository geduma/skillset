# API Contract Design

Project-agnostic; adapt examples to the detected language/framework.

## 1. Contract first

Define the interface before implementing it.

```typescript
interface TaskAPI {
  createTask(input: CreateTaskInput): Promise<Task>;
  listTasks(params: ListTasksParams): Promise<PaginatedResult<Task>>;
  getTask(id: string): Promise<Task>;
  updateTask(id: string, input: UpdateTaskInput): Promise<Task>;
  deleteTask(id: string): Promise<void>;
}
```

**Input/Output separation:**

```typescript
// Input: what the caller provides
interface CreateTaskInput {
  title: string;
  description?: string;
}

// Output: what the system returns (includes server-generated fields)
interface Task {
  id: string;
  title: string;
  description: string | null;
  createdAt: Date;
  updatedAt: Date;
  createdBy: string;
}
```

**Branded types for IDs:**

```typescript
type TaskId = string & { readonly __brand: 'TaskId' };
type UserId = string & { readonly __brand: 'UserId' };
```

**Discriminated unions for variants:**

```typescript
type TaskStatus =
  | { type: 'pending' }
  | { type: 'in_progress'; assignee: string; startedAt: Date }
  | { type: 'completed'; completedAt: Date; completedBy: string }
  | { type: 'cancelled'; reason: string; cancelledAt: Date };
```

## 2. Hyrum's Law

> With a sufficient number of users of an API, all observable behaviors of your system will be depended on by somebody, regardless of what you promise in the contract.

Implications:
- Be intentional about what you expose. Every observable behavior is a potential commitment.
- Don't leak implementation details. If users can observe it, they will depend on it.
- Plan for deprecation at design time. See `deprecation-and-migration` (reserved P1).
- Tests are not enough. Even with perfect contract tests, Hyrum's Law means "safe" changes can break real users who depend on undocumented behavior.

## 3. One-Version Rule

Avoid forcing consumers to choose between multiple versions of the same dependency or API. Diamond dependency problems arise when different consumers need different versions of the same thing. Design for a world where only one version exists at a time — extend rather than fork.

## 4. Consistent error semantics

Pick one error strategy and use it everywhere:

```typescript
interface APIError {
  error: {
    code: string;        // Machine-readable: "VALIDATION_ERROR"
    message: string;     // Human-readable: "Email is required"
    details?: unknown;   // Additional context when helpful
  };
}
```

**REST status code mapping:**
- 400 → Client sent invalid data
- 401 → Not authenticated
- 403 → Authenticated but not authorized
- 404 → Resource not found
- 409 → Conflict (duplicate, version mismatch)
- 422 → Validation failed (semantically invalid)
- 500 → Server error (never expose internal details)

Don't mix patterns. If some endpoints throw, others return null, and others return `{ error }` — the consumer can't predict behavior.

## 5. Validate at boundaries

Trust internal code. Validate at system edges where external input enters:

- API route handlers (user input)
- Form submission handlers (user input)
- External service response parsing (third-party data — **always treat as untrusted**)
- Environment variable loading (configuration)

Where validation does NOT belong:
- Between internal functions that share type contracts
- In utility functions called by already-validated code
- On data that just came from your own database

**Third-party API responses are untrusted data.** Validate their shape and content before using them in any logic, rendering, or decision-making.

## 6. Prefer addition over modification

Extend interfaces without breaking existing consumers:

```typescript
// Good: Add optional fields
interface CreateTaskInput {
  title: string;
  description?: string;
  priority?: 'low' | 'medium' | 'high';  // Added later, optional
  labels?: string[];                       // Added later, optional
}

// Bad: Change existing field types or remove fields
interface CreateTaskInput {
  title: string;
  priority: number;         // Changed — breaks existing consumers
}
```

## 7. Predictable naming

| Pattern | Convention | Example |
|---------|-----------|---------|
| REST endpoints | Plural nouns, no verbs | `GET /api/tasks`, `POST /api/tasks` |
| Query params | camelCase | `?sortBy=createdAt&pageSize=20` |
| Response fields | camelCase | `{ createdAt, updatedAt, taskId }` |
| Boolean fields | is/has/can prefix | `isComplete`, `hasAttachments` |
| Enum values | UPPER_SNAKE | `"IN_PROGRESS"`, `"COMPLETED"` |

## 8. Idempotency key

**Derive the key from the intent, not the attempt:**

```typescript
crypto.randomUUID()                    // ✗ new key per attempt — every retry is a new charge
`${userId}:${amount}`                  // ✗ two legitimate charges collapse into one
`${orderId}:${Date.now()}`             // ✗ a timestamp is randomUUID() wearing a hat

req.headers['idempotency-key']         // ✓ client generates once, reuses on retry
`charge:v1:${orderId}`                 // ✓ derived from an immutable identifier
```

**Claim atomically. A check followed by an act is a race:**

```typescript
// ✗ TOCTOU: two concurrent retries both read "not seen", both charge
if (!(await db.exists(key))) {
  await chargeCard(amount);
  await db.insert(key);
}

// ✓ let the unique constraint pick the winner
try {
  await db.insert({ key, state: 'in_progress', requestHash });
} catch (e) {
  if (isUniqueViolation(e)) return replayOrReject(key);
  throw e;
}
const result = await chargeCard(amount);
await db.update({ key, state: 'succeeded', response: result });
```

**Guard the payload.** Same key with a different body is a client bug — fail loudly:

```typescript
if (existing.requestHash !== hash(req.body)) {
  return res.status(422).json({ error: 'idempotency key reused with a different payload' });
}
```

**Decide what an in-flight duplicate gets:**

| Strategy | Response | Use when |
|----------|----------|----------|
| Reject | `409 Conflict` | Client can retry later; simplest and safest |
| Wait | Block for the result, bounded | Caller needs it synchronously |
| Return pending | `202` + status URL | Long-running effects |

**Retention:** Set retention from the longest retry chain, not from disk cost. Keys must outlive every path that can re-deliver the same intent, including a dead-letter queue replayed a week later.

## 9. REST API patterns

**Resource design:**

```
GET    /api/tasks              → List tasks (with query params for filtering)
POST   /api/tasks              → Create a task
GET    /api/tasks/:id          → Get a single task
PATCH  /api/tasks/:id          → Update a task (partial)
DELETE /api/tasks/:id          → Delete a task

GET    /api/tasks/:id/comments → List comments for a task (sub-resource)
POST   /api/tasks/:id/comments → Add a comment to a task
```

**Pagination:**

```typescript
// Request
GET /api/tasks?page=1&pageSize=20&sortBy=createdAt&sortOrder=desc

// Response
{
  "data": [...],
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 142,
    "totalPages": 8
  }
}
```

**Filtering:** Use query parameters for filters:

```
GET /api/tasks?status=in_progress&assignee=user123&createdAfter=2025-01-01
```

**Partial updates (PATCH):** Accept partial objects — only update what's provided:

```typescript
PATCH /api/tasks/123
{ "title": "Updated title" }
```

## 10. Common rationalizations

| Rationalization | Reality |
|---|---|
| "We'll document the API later" | The types ARE the documentation. Define them first. |
| "We don't need pagination for now" | You will the moment someone has 100+ items. Add it from the start. |
| "PATCH is complicated, let's just use PUT" | PUT requires the full object every time. PATCH is what clients actually want. |
| "We'll version the API when we need to" | Breaking changes without versioning break consumers. Design for extension from the start. |
| "Nobody uses that undocumented behavior" | Hyrum's Law: if it's observable, somebody depends on it. Treat every public behavior as a commitment. |
| "We can just maintain two versions" | Multiple versions multiply maintenance cost and create diamond dependency problems. Prefer the One-Version Rule. |
| "Internal APIs don't need contracts" | Internal consumers are still consumers. Contracts prevent coupling and enable parallel work. |
| "Accepting the Idempotency-Key header is enough" | The header is the contract; storing the key against the result is the implementation. A key you accept but don't honour tells the client retrying is safe when it isn't. |
| "Our queue guarantees exactly-once delivery" | No queue does across a consumer crash — the broker's ack and your side effect are not in one transaction. Design for at-least-once with idempotent processing. |
| "Duplicate requests are rare" | They're *correlated*. Retries spike exactly when a dependency is degraded — the moment duplicates are most likely and most expensive. |

## 11. Red flags

- Endpoints that return different shapes depending on conditions
- Inconsistent error formats across endpoints
- Validation scattered throughout internal code instead of at boundaries
- Breaking changes to existing fields (type changes, removals)
- List endpoints without pagination
- Verbs in REST URLs (`/api/createTask`, `/api/getUsers`)
- Third-party API responses used without validation or sanitization
- A `SELECT` for an idempotency key followed by an `INSERT` — that's a race, not a guard
- An idempotency key derived from a UUID, timestamp, or anything else regenerated per attempt
- The same key accepted with a different body, silently returning the first response
- A key retention window shorter than the longest path that can re-deliver the request

## 12. Verification

After designing an API:

- [ ] Every endpoint has typed input and output schemas
- [ ] Error responses follow a single consistent format
- [ ] Validation happens at system boundaries only
- [ ] List endpoints support pagination
- [ ] New fields are additive and optional (backward compatible)
- [ ] Naming follows consistent conventions across all endpoints
- [ ] API documentation or types are committed alongside the implementation
- [ ] State-changing endpoints either honour an idempotency key or are documented as unsafe to retry
- [ ] The key is claimed in one atomic operation, guarded by a unique constraint
- [ ] A reused key with a different payload fails loudly rather than replaying the wrong response
- [ ] The in-flight-duplicate response is a deliberate choice (409, wait, or 202) rather than whatever falls out
- [ ] Key retention outlives the longest retry path, including dead-letter replay