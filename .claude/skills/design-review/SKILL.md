---
name: design-review
description: 'Launch a comprehensive design review with two parallel reviewers (top-down caller perspective + bottom-up implementation perspective), then synthesize their findings into actionable recommendations. Use for any significant design doc, architecture change, or multi-component refactor.'
allowed-tools: Task, Read, Glob, Grep, Bash, AskUserQuestion
---

# Design Review Orchestrator

Launch a comprehensive two-perspective design review by deploying parallel "top-down" (caller experience) and "bottom-up" (implementation feasibility) reviewer agents. After both complete, synthesize their findings into a prioritized action plan.

## When to Use

- Before implementing a significant design change
- When a design doc needs rigorous validation before team review
- When refactoring touches multiple components across repos
- When you want to find both API-level and infrastructure-level issues simultaneously

## Arguments

The user should provide:
1. **Design doc path(s)** — the plan or design document(s) to review
2. Optionally: specific areas of concern to focus on

If not provided, ask the user.

## Instructions

### Step 1: Identify Scope

Read the design doc(s) and scan the codebase to identify:
- **Entry points**: What callers/clients interact with (for top-down reviewer)
- **Infrastructure**: What low-level systems are involved — databases, Solr, external APIs, shared libraries (for bottom-up reviewer)
- **Intermediate layers**: Federation logic, transformation layers, serialization boundaries

Use Glob and Grep to quickly map the codebase structure relevant to the design.

### Step 2: Launch Both Reviewers in Parallel

Launch TWO Task agents simultaneously (in a single message with both tool calls) using `subagent_type: "Plan"` and `run_in_background: true`.

**Agent 1: Top-Down Reviewer**

```
You are a rigorous "top-down reviewer." Evaluate the design from the CALLER perspective.

Read the design doc at [path]. Then read the actual codebase to validate.

Cover these categories:

1. CALLER EXPERIENCE: What changes for callers? Is the API contract clear? What happens with stale, invalid, or cross-service inputs?

2. LAYER COMPLEXITY: Walk each layer from caller to implementation. Rate complexity 1-5. What can go wrong at each layer? What's the error handling story?

3. BREAKING CHANGES: List every caller-visible change. Is each necessary? What's the migration path?

4. EDGE CASES: Think adversarially — empty inputs, exact boundaries, concurrent requests, stale state from deployments, tampered inputs, extreme parameter values.

5. SIMPLIFICATION: Where is the design over-engineered? Where is it under-specified? What would you remove?

Read the actual code — don't just review the doc. Cite file paths and line numbers. Organize by severity: BLOCKER > HIGH > MEDIUM > LOW.
```

Customize the prompt with specific file paths for the entry points, input/output schemas, and upstream callers relevant to this design.

**Agent 2: Bottom-Up Reviewer**

```
You are a rigorous "bottom-up reviewer." Evaluate the design from the INFRASTRUCTURE perspective, starting at the lowest layer.

Read the design doc at [path]. Then read the actual codebase starting from infrastructure up.

Cover these categories:

1. INFRASTRUCTURE VALIDATION: Does the core mechanism work? Trace the exact code path from the proposed change through shared libraries to the underlying system.

2. SERIALIZATION PATH: Trace data flow through every serialization/deserialization boundary. Check model_dump(), model_validate_json(), type conversions. What happens with extra fields?

3. MIGRATION PATH: For each changing component, list every line that touches old behavior. What replaces it? Are there implicit contracts that break?

4. IMPEDANCE MISMATCHES: Where do design assumptions not match actual code? Missing types, wrong signatures, unsupported patterns?

5. TERMINATION CONDITIONS: How does the system know when to stop? Are heuristics reliable? What signals are available from the infrastructure?

6. PERFORMANCE OVERHEAD: Quantify overhead — re-fetching, extra queries, larger payloads. Calculate worst cases.

7. SIMPLEST PATH: What is the minimal viable implementation? What shortcuts does the bottom-up view reveal?

Read the actual code — don't just review the doc. Cite file paths and line numbers. Organize by severity: BLOCKER > HIGH > MEDIUM > LOW.
```

Customize with specific file paths for infrastructure code, shared libraries, leaf components, and serialization boundaries.

### Step 3: Synthesize Findings

Once both agents complete, create a consolidated review:

#### 3a. Cross-Reference Findings

Identify where both reviewers found the same issue (convergent findings carry more weight) and where they found different issues (divergent findings reveal perspective-specific blind spots).

#### 3b. Organize by Priority

```
## Consolidated Design Review

### Converging Findings (both reviewers agree)
[Issues found by BOTH top-down and bottom-up — highest confidence]

### Blockers
[Issues that prevent the design from working — must fix before implementation]

### High Severity
[Significant gaps — should fix before implementation]

### Medium Severity
[Important but not blocking — can fix during implementation]

### Low Severity
[Minor issues and suggestions — address opportunistically]

### Validated Claims
[Assumptions confirmed by code review — confidence boosters]

### Simplification Opportunities
[Suggestions from both perspectives on what to remove/simplify]
```

#### 3c. For Each Finding

Include:
- **What**: The specific issue
- **Source**: Which reviewer found it (top-down, bottom-up, or both)
- **Evidence**: File paths, line numbers, code snippets
- **Impact**: What breaks or degrades if not addressed
- **Fix**: Suggested resolution

### Step 4: Present and Discuss

Present the consolidated review to the user. Then ask:
- Which findings do they want to address now vs defer?
- Do any findings change the fundamental approach?
- Should the design doc be updated before implementation?

If the user wants to update the design doc, help them incorporate the fixes.

## Tips for Best Results

- **Be specific in the prompts**: Include actual file paths, class names, and schema locations. The more specific the prompt, the more surgical the review.
- **Scope appropriately**: For large designs, focus each reviewer on the most critical paths rather than trying to cover everything.
- **Let them run fully**: Both agents should explore broadly — don't constrain them to only the files you think are relevant.
- **Trust convergent findings**: When both reviewers independently flag the same issue, it's almost certainly real.
- **Challenge divergent findings**: When only one reviewer flags something, dig into whether it's a genuine issue or a perspective artifact.
