## Engineering Discipline

Language-agnostic working principles. Language-specific style lives in the
language section.

### Core Beliefs

- Incremental progress over big bangs: small changes that compile and pass tests.
- Study project conventions and patterns before implementing.
- Pragmatic over dogmatic: adapt to project reality.
- Clear intent over clever code: be boring and obvious.
- Design for failure: assume things will break, make recovery cheap.

### Dependencies

Do not add, remove, or bump a dependency in the manifest or the lock file
of the project without agreement first. Name the dependency, say what it buys, and say what the
standard library alternative costs, then get agreement before you add it.

### When Stuck (After 3 Attempts)

Maximum 3 attempts per issue, then STOP.

1. Document what failed (exact errors, logs, stack traces).
2. Research alternatives (official docs, source, issue trackers).
3. Question fundamentals (are the assumptions correct?).
4. Try a different angle (different abstraction, different boundary).

### Decision Framework

When multiple valid approaches exist, choose based on:

1. Simplicity: is this the simplest solution that works?
2. Fault tolerance: how does this fail and recover?
3. Testability: can this be verified automatically?
4. Performance: will this scale under realistic load?
5. Readability: will someone understand this in 6 months?
6. Consistency: does this match existing project patterns?

### Disagreement

If an instruction is wrong or based on a false premise, say so plainly before
doing anything. Being accommodating about a bad plan is worse than being
blunt. State the problem, state the alternative, then follow the decision.

Do not claim something works when you have not verified it. Do not describe
untested code as tested. Uncertainty stated up front costs a sentence;
uncertainty discovered later costs an afternoon.

### Result Discipline

Every call that can fail returns something the caller inspects. Discarding a
result to quiet the compiler hides today's failure and silences tomorrow's
change of return type.

- Match the result. Never drop it with `_`, `ignore`, or an unused binding.
- When a call returns one uninteresting value, match it exactly. The
  language section shows the form.
- When a call returns several shapes and the caller does not care which, route
  it through a small helper that names every variant, returns unit, and logs
  the ones worth watching. Every branch is then a deliberate decision, and a
  new variant breaks the build instead of vanishing.
- Never add a catch-all branch to a match over a closed set of values. An
  unmatched value must fail loudly. The compiler doing exhaustiveness checking
  is the cheapest reviewer you have.

The per-language forms are in the language section.

### Testing

- Aim for high, meaningful coverage (not coverage theatre).
- Test behavior at boundaries, not implementation details.
- Prefer real components over mocks where practical.
- Tests must be deterministic (handle async and time explicitly).
- Write the failing test first when fixing bugs.

### Test Conduct

Tests are the specification. Do not edit the specification to match broken
code. Not allowed, ever:

- Deleting a failing test.
- Marking a test skipped or pending, or commenting it out.
- Weakening an assertion to whatever the code now returns.
- Replacing a real call with a mock so the assertion stops exercising the code
  under test.
- Widening a pattern in a test to accept the new output.
- Serialising a suite to hide a race instead of fixing the race.

If a test fails, either the code is wrong or the test encodes an expectation
that is no longer correct. Say which one you believe it is and why, then wait
if the answer is the second.

A new test must fail before the fix and pass after it. If you cannot make it
fail against the unfixed code, it is not testing the fix. Prefer one property
that covers the space over five examples that cover five points in it,
wherever the invariant is expressible.

### Verification

Run the checks before claiming work is done. Report the actual result, not
the expected one. At minimum: the formatter, the compiler with warnings as
errors, and the tests covering what you touched. Run the slow whole-program
analysis when you changed a type, a record, or a return shape.

The per-language command lists are in the language section.
When a project has no language rule, take the commands from its `AGENTS.md`
or `CLAUDE.md`, and ask when it has none.

If a check fails and you cannot fix it, say which check failed and what the
error was. Do not report completion with a failing check. Never say "this
should work", "this will now pass", or "tests are passing" unless you ran them
and read the output.

### Definition of Done

Code compiles with no warnings. Static analysis and type checks pass. Tests
written and passing. Code formatted with the project's formatter. No TODOs
without an issue reference. Commit message explains the why. Implementation
matches the agreed plan.

### Process

1. Understand: read the existing code and tests.
2. Spec: write types and signatures first where the language supports it.
3. Test: write the failing test (red).
4. Implement: minimal code to pass (green).
5. Refactor: clean up with tests green.
6. Format and lint: run the project's formatter and linter.
7. Commit message: propose one, linked to plan or issue. The user commits.
