---
name: refactor
description: 'Plan safe, incremental refactors with rollback points. Use when the user wants to refactor code, restructure a module, break up a large file, rename across a codebase, or make a big structural change safely.'
---

# Refactor Planner

Break large refactors into safe, incremental steps where tests stay green at every point.

## When to Use

- User wants to refactor code or restructure a module
- User needs to break up a large file or class
- User wants to rename something used across many files
- User is planning a migration (API version, framework, pattern)
- User says "this code is a mess, where do I start?"

## Core Principles

1. **Tests green at every step**: If tests break, the step is too big. Split it.
2. **Each step is independently shippable**: Every step could be merged on its own.
3. **Small PRs over big bangs**: 5 small PRs are better than 1 large PR.
4. **Mechanical changes separate from behavioral changes**: Never mix rename/move with logic changes.
5. **Rollback is always possible**: At any step, you can stop and the code is in a good state.

## Process

### 1. Assess the Current State

Before planning any changes:

- **Read the code** being refactored
- **Run the tests** — they must pass before you start
- **Map the dependencies** — what calls this code? What does it call?
- **Identify the pain** — what specifically is wrong? (Don't refactor for fun)
- **Define "done"** — what does the code look like after the refactor?

### 2. Identify Risks

For each area being changed:

- **What could break?** List callers, integrations, edge cases
- **What tests exist?** Are they sufficient to catch regressions?
- **What tests are missing?** Write them BEFORE refactoring
- **What's the blast radius?** How many files/modules are affected?
- **Are there hidden consumers?** Reflection, dynamic imports, config files, external services

### 3. Plan the Steps

Break the refactor into ordered steps. Each step should be:

- **Small**: Reviewable in < 15 minutes
- **Safe**: Tests pass before and after
- **Atomic**: Does one logical thing
- **Reversible**: Can be reverted without affecting other steps

Common step patterns:

**Extract**: Pull code into a new function/class/module
```
Step 1: Extract function (copy, don't move — both old and new exist)
Step 2: Update callers to use new function
Step 3: Delete old function
```

**Rename**: Change names across the codebase
```
Step 1: Add new name as alias for old name
Step 2: Update all callers to use new name
Step 3: Remove old name alias
```

**Move**: Relocate code to a new file/module
```
Step 1: Create new file, re-export from old location
Step 2: Update callers to import from new location
Step 3: Remove re-export from old location
```

**Replace**: Swap an implementation
```
Step 1: Write new implementation alongside old
Step 2: Add feature flag or config to switch between them
Step 3: Migrate callers to new implementation
Step 4: Remove old implementation and flag
```

### 4. Write Missing Tests First

Before touching any production code:

- Add tests that verify current behavior
- These tests are your safety net during the refactor
- If you can't test it, you can't safely refactor it
- Commit the tests as a separate step

### 5. Execute and Verify

For each step:

1. Make the change
2. Run the tests
3. Review the diff — is it small and focused?
4. Commit with a clear message explaining the step
5. Move to the next step

If tests fail: the step was too big. Revert and split it.

## Output Format

```markdown
## Refactor Plan: <what's being refactored>

### Goal
<What the code should look like after, and why>

### Risks
- <Risk 1>: <Mitigation>
- <Risk 2>: <Mitigation>

### Pre-work
- [ ] Verify tests pass on current code
- [ ] Add missing test coverage for <area>

### Steps

**Step 1: <Description>** (PR-able: yes)
- <What to change>
- <What to verify>

**Step 2: <Description>** (PR-able: yes)
- <What to change>
- <What to verify>

...

### Post-refactor
- [ ] Run full test suite
- [ ] Verify no dead code left behind
- [ ] Update documentation if public API changed
```

## Common Refactoring Scenarios

### "This file is too big"
1. Identify logical groupings within the file
2. Extract each group to its own file, one at a time
3. Update imports after each extraction
4. Keep an index file if needed for backwards compatibility

### "This function does too much"
1. Identify the distinct responsibilities
2. Extract helper functions one at a time
3. Keep the original function as an orchestrator
4. Test each helper independently

### "We need to change this API"
1. Create the new API alongside the old one
2. Add deprecation warnings to the old API
3. Migrate callers one by one
4. Remove the old API after all callers are migrated

### "This naming is inconsistent"
1. Pick the target naming convention
2. Rename one thing at a time (mechanical change only)
3. Use find-and-replace with manual verification
4. Don't mix renames with logic changes

## Anti-Patterns

- **Big bang refactor**: Changing everything at once in one massive PR
- **Refactor + feature**: Adding new behavior during a refactor
- **No tests before refactoring**: Flying blind
- **Refactoring what isn't painful**: If it works and nobody touches it, leave it alone
- **Premature abstraction**: Don't refactor to a pattern until you see the need 3+ times
