---
name: review-top-down
description: 'Review a design or codebase from the top-down caller perspective. Evaluates the consumer experience, API contracts, breaking changes, layer complexity, and edge cases. Use when you want to validate that a design makes sense to its callers.'
allowed-tools: Task, Read, Glob, Grep, Bash, AskUserQuestion
---

# Top-Down Design Review

Review a design, architecture, or code change from the **caller/consumer perspective** — walking down through each layer from the external API to the internals. This review prioritizes the experience of the people and systems that CALL this code.

## When to Use

- Reviewing a design doc before implementation
- Validating an API contract change
- Checking if a refactor introduces breaking changes
- Assessing the complexity callers face at each layer
- Finding edge cases in pagination, error handling, or state management

## Arguments

The user should provide:
1. **Design doc path(s)** — the plan/design document(s) to review
2. **Codebase context** — the repo or directories containing the actual code

If not provided, ask the user for these.

## Instructions

### Step 1: Gather Context

Read the design doc(s) the user specified. Then explore the codebase to understand:
- What are the entry points (tool handlers, API endpoints, CLI commands)?
- What do callers send (input schemas)?
- What do callers receive (output schemas)?
- Who are the upstream callers? Search for references to this service/tool in sibling repos or test files.

### Step 2: Launch the Review Agent

Launch a Plan subagent with the following prompt structure. Adapt the specifics to the design being reviewed, but always cover all 5 review categories.

Use the Task tool with `subagent_type: "Plan"` and a prompt structured as:

```
You are a rigorous top-down reviewer evaluating a design from the caller/consumer perspective.

## Context
Read [design doc path(s)] for the proposed changes.
Then read the actual codebase at [relevant paths] to understand current behavior.

## Review Categories (cover ALL of these)

### 1. Caller Experience Analysis
- What do callers send today vs after the change?
- Are API contracts clear and well-documented?
- What happens with stale/invalid/cross-service inputs?
- Are there implicit behavioral changes that callers might not expect?

### 2. Layer Complexity Audit
Walk through each layer from caller to implementation. For each layer:
- Rate complexity 1-5
- What can go wrong?
- What's the error handling story?
- What happens on partial failure?

### 3. Breaking Changes Assessment
- List every change visible to callers
- For each: is it truly necessary? Could we maintain backward compat?
- What's the migration story?

### 4. Edge Cases
Think adversarially:
- Empty inputs, zero results
- Exact boundary conditions
- Concurrent/duplicate requests
- Stale state from previous deployments
- Mid-deployment behavior changes
- Malformed or tampered inputs
- Very large or very small parameter values

### 5. Simplification Suggestions
- Where is the design over-engineered for current needs?
- Where is it under-specified?
- What would you remove or simplify?

Be specific, surgical, and cite exact code locations and field names.
Organize findings by severity: BLOCKER > HIGH > MEDIUM > LOW.
```

### Step 3: Present Results

When the agent completes, present the findings to the user organized as:

1. **Blockers** — things that prevent the design from working
2. **High severity** — significant design gaps or breaking changes
3. **Medium severity** — important but not blocking
4. **Low severity** — minor issues and suggestions
5. **What's solid** — validated claims and good design choices

For each finding, include:
- The specific claim or assumption being challenged
- Evidence from the codebase (file paths, line numbers)
- Suggested resolution

### Step 4: Discussion

After presenting, ask the user which findings they want to address and help refine the design based on the review.
