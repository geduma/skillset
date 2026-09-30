# Red Flags

Stop guessing and return to investigation when these appear.

## 1. Stop phrases

- Quick fix for now, investigate later.
- Just try changing this and see what happens.
- Add several changes at once, then run tests.
- Skip the test, manual verification is enough.
- It is probably this, let me fix it.
- One more fix attempt after two failures.
- Proposing solutions before tracing data flow.
- Each fix reveals a new problem in a different place.

## 2. User signals

- Questions whether an assumed behavior was verified.
- Asks what evidence a change would produce.
- Asks to stop guessing or to think through fundamentals.
- Expresses frustration or asks if the approach is stuck.

## 3. Common rationalizations

- Simple issue, no process needed: simple issues have root causes too.
- Emergency, no time: systematic work is faster than thrashing.
- Try first, investigate after: the first fix sets the pattern.
- Test after confirming: untested fixes do not stick.
- Multiple fixes save time: stacked changes hide what worked and add bugs.
- Reference too long to read: partial understanding guarantees bugs.

## 4. Architecture warning

- Three or more fixes failed, each exposing different coupling or new symptoms.
- Fixes require disproportionate refactoring or keep moving the failure.
- Stop, discuss fundamentals with the user, and choose between refactor and continued repair.
