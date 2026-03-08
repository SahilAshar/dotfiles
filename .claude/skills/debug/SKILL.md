---
name: debug
description: 'Systematic debugging methodology. Use when the user is stuck on a bug, encountering an error, asking for help debugging, or shotgun-debugging without progress.'
---

# Systematic Debugger

A structured approach to debugging that prevents shotgun fixes and forces systematic narrowing to root cause.

## When to Use

- User is stuck on a bug
- User shares an error message and asks for help
- User has been trying random fixes without progress
- User asks "why isn't this working?"

## The Debugging Loop

### 1. Reproduce

Before anything else, confirm you can reproduce the issue.

- **Get the exact error**: Full stack trace, error message, and context
- **Get the exact steps**: What input, what command, what sequence triggers it?
- **Confirm it's reproducible**: Does it happen every time? Only sometimes? Only in certain environments?

If you can't reproduce it, you can't debug it. Focus here first.

### 2. Isolate

Narrow the problem space systematically.

- **Read the error message carefully**: Most errors tell you exactly what's wrong. Read every word.
- **Check recent changes**: `git diff` and `git log` — what changed since it last worked?
- **Binary search**: If the cause isn't obvious, bisect. Comment out half the code, check if the error persists, narrow the half that matters.
- **Simplify**: Create a minimal reproduction. Strip away everything that isn't necessary to trigger the bug.

Key question: **What's the smallest change that triggers/fixes this?**

### 3. Hypothesize

Form a specific, testable hypothesis before making changes.

- "I think X is happening because Y, and if I'm right, then Z should be true"
- Write down the hypothesis — this prevents drift
- If you can't form a hypothesis, you need more information (go back to step 2)

Bad hypothesis: "Something is wrong with the API"
Good hypothesis: "The API returns 401 because the token expires after 1 hour and we never refresh it"

### 4. Verify

Test your hypothesis with the smallest possible change.

- Make ONE change at a time
- Predict the outcome before running the test
- If your prediction is wrong, your hypothesis is wrong — go back to step 3
- If your prediction is right, you've found the root cause

### 5. Fix

Apply the fix and verify it's complete.

- Fix the root cause, not the symptom
- Check for the same bug pattern elsewhere in the codebase
- Write a regression test that would have caught this
- Verify the original reproduction case now passes

## Common Debugging Patterns

### "It works on my machine"
- Compare environments: versions, config, env vars, OS
- Check: `node --version`, `python --version`, env-specific config files
- Docker/container differences vs local

### "It worked yesterday"
- `git log --oneline -20` — what changed?
- `git bisect` to find the exact commit
- Check external dependencies: did an API change? Did a package update?

### "It works sometimes"
- Race condition: timing-dependent behavior
- State leakage: previous test/request polluting state
- Resource limits: memory, connections, file descriptors
- Flaky external dependency

### "No error, just wrong output"
- Add logging at key decision points
- Trace the data flow: input → transformation → output
- Check assumptions: print intermediate values
- Diff expected vs actual output carefully

## Anti-Patterns to Avoid

- **Shotgun debugging**: Making random changes hoping something sticks
- **Cargo cult fixes**: Copying a fix from Stack Overflow without understanding why it works
- **Fix and forget**: Fixing the symptom without understanding the root cause
- **Changing multiple things at once**: You won't know which change actually fixed it
- **Ignoring the error message**: It almost always contains the answer

## Guiding the User

When helping someone debug:

1. **Start by asking what they've already tried** — don't repeat failed approaches
2. **Ask for the full error** — partial errors waste time
3. **Ask what changed** — the bug was introduced somehow
4. **Slow them down** — if they're frustrated, help them step back and be systematic
5. **Teach the process** — don't just find the fix, help them learn to debug
