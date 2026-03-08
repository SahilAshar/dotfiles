---
name: test-strategy
description: 'Plan what tests to write for code. Use when the user asks what tests to write, how to test something, wants a test plan, or is unsure about test coverage for new or existing code.'
---

# Test Strategy Planner

Analyze code and produce a concrete test plan with specific test cases, file paths, and the right balance of unit, integration, and e2e tests.

## When to Use

- User asks "what tests should I write?"
- User is building a new feature and needs test coverage
- User wants to improve test coverage for existing code
- User is unsure whether to write unit vs integration vs e2e tests

## Process

### 1. Understand the Code

Before recommending tests:

- Read the code being tested
- Identify public API surface (what callers use)
- Identify dependencies (what it calls)
- Identify side effects (what it changes)
- Check existing tests for patterns and conventions

### 2. Match Existing Conventions

Look at the repo's test setup before proposing anything:

- **Test framework**: Jest, pytest, Go testing, etc.
- **File naming**: `*.test.ts`, `*_test.go`, `test_*.py`
- **Directory structure**: Co-located? Separate `tests/` dir? `__tests__/`?
- **Patterns**: Do they use factories? Fixtures? Mocks? Test helpers?
- **Coverage requirements**: Is there a threshold configured?

Match what exists. Don't introduce new patterns unless asked.

### 3. Plan Test Cases

For each unit of code, identify:

**Happy path**: The normal, expected flow
- Valid inputs produce correct outputs
- Standard use cases work as documented

**Edge cases**: Boundary conditions
- Empty inputs, zero values, max values
- Single item vs many items
- Unicode, special characters, very long strings
- Concurrent access (if applicable)

**Error paths**: Failure modes
- Invalid inputs (wrong type, missing required fields)
- Dependency failures (network errors, timeouts, missing files)
- Permission errors, auth failures
- Graceful degradation

**State transitions**: If the code manages state
- Initial state is correct
- Transitions are valid
- Invalid transitions are rejected
- Final/terminal states are handled

### 4. Decide What to Mock

**Mock these** (external, slow, non-deterministic):
- Network calls (APIs, databases)
- File system (when testing logic, not I/O)
- Time/dates (use fixed timestamps)
- Random values
- Third-party services

**Don't mock these** (internal, fast, deterministic):
- Your own utility functions
- Pure data transformations
- Simple value objects
- Things that are fast and have no side effects

**Rule of thumb**: If mocking it makes the test meaningless, don't mock it.

### 5. Choose Test Types

**Unit tests** (most tests should be here):
- Test a single function/method in isolation
- Fast, deterministic, no I/O
- Best for: business logic, data transformations, algorithms

**Integration tests** (fewer, targeted):
- Test components working together
- May use real database, file system, or in-memory equivalents
- Best for: API endpoints, database queries, middleware chains

**E2E tests** (fewest, critical paths only):
- Test the full system from user perspective
- Slow, potentially flaky, but highest confidence
- Best for: critical user journeys, smoke tests, deployment verification

**The pyramid**: Many unit tests, some integration, few e2e. If your integration tests are testing logic, push them down to unit. If your unit tests require elaborate mocking, push them up to integration.

## Output Format

Produce a concrete test plan:

```markdown
## Test Plan: <feature/module name>

### Unit Tests
File: `<path to test file>`

- [ ] `<test name>` — <what it verifies>
- [ ] `<test name>` — <what it verifies>

### Integration Tests
File: `<path to test file>`

- [ ] `<test name>` — <what it verifies>

### Mocking Strategy
- Mock `<dependency>` because <reason>
- Use real `<dependency>` because <reason>

### Not Testing (and why)
- <thing> — <reason it doesn't need a test>
```

## Guidelines

**DO**:
- Prioritize tests by risk — test the scariest code first
- Include the "why" for each test case
- Specify concrete input/output examples
- Note which tests are most important if time is limited

**DON'T**:
- Suggest 100% coverage as a goal — it's a vanity metric
- Recommend testing trivial getters/setters
- Suggest tests that just verify the mocking framework works
- Ignore the existing test patterns in the repo
