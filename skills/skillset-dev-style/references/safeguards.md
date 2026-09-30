# Safeguards

Runtime discipline from the user's services: fail fast, log cleanly, distrust input.

## 1. Configuration

- Single config file, validated at boot. Missing file falls back to the shipped `*.example.*` template only to show a clear error, never to run silently with placeholder secrets.
- Defaults are filled in one normalization function with nullish coalescing. Environment variables override file values through an explicit allowlist map.
- Secrets are validated eagerly: required, minimum length, and placeholder detection (reject values still containing `replace-with-`, `CHANGE_ME`, or `example`). Throw a descriptive error naming the exact key and how to generate a real value.
- Numeric and boolean settings are parsed once at load. No stringly-typed ports, timeouts, or flags downstream.

## 2. Errors and logging

- Structured logger in production code. Raw console output is for CLI bootstrapping only, never for request paths.
- Normalize errors at boundaries into `{ message, type, code }` shapes the caller already expects.
- Distinguish retryable (quota, rate-limit, timeout) from fatal (bad config, bad auth). Retryable triggers cooldown or failover; fatal stops fast with a clear message.
- Timeouts, budgets, and concurrency caps are named constants, not magic numbers.

## 3. Input and security hygiene

- Validate at the boundary (schema validation for config and external payloads). Reject unknown behavior early with a 4xx-style error, not a crash.
- Security headers and rate limits are on by default for network services. Keyed limits hash caller identity; never log raw tokens.
- Compare secrets with constant-time comparison. Allowlist private-host exemptions explicitly; do not open the network by default.
- Persist audit-relevant events (requests, token use, errors, cache hits) through a buffered queue with periodic flush, not inline on every hot path.

## 4. What to reject

- Hardcoded secrets, tokens, or private URLs.
- Silent fallbacks that hide misconfiguration.
- Unbounded retries, uncapped buffers, or missing timeouts.
- Logging payloads containing credentials.
