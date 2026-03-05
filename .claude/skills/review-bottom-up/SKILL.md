---
name: review-bottom-up
description: 'Review a design or codebase from the bottom-up implementation perspective. Traces how changes bubble up from the lowest layer (data stores, SDKs, protocols) through the stack. Use when you want to validate that a design is actually implementable against the real infrastructure.'
allowed-tools: Task, Read, Glob, Grep, Bash, AskUserQuestion
---

# Bottom-Up Design Review

Review a design, architecture, or code change from the **implementation/infrastructure perspective** — starting at the lowest layer (databases, Solr, SDKs, protocols) and tracing how changes bubble up through each layer to the API surface. This review prioritizes implementation feasibility and catches impedance mismatches.

## When to Use

- Validating that a design's assumptions match the actual infrastructure
- Checking if a proposed API change is compatible with underlying systems
- Tracing data flow from storage through transformations to output
- Finding hidden dependencies, side effects, or type mismatches
- Verifying serialization/deserialization paths work end-to-end

## Arguments

The user should provide:
1. **Design doc path(s)** — the plan/design document(s) to review
2. **Codebase context** — the repo or directories containing the actual code

If not provided, ask the user for these.

## Instructions

### Step 1: Gather Context

Read the design doc(s) the user specified. Then explore the codebase to identify:
- What are the lowest-level systems involved (databases, Solr, external APIs, SDKs)?
- What shared libraries are used? What abstractions do they provide?
- What are the leaf/terminal components (the things that actually talk to storage/APIs)?
- What intermediate layers exist between the leaves and the entry points?

### Step 2: Launch the Review Agent

Launch a Plan subagent with the following prompt structure. Adapt the specifics to the design being reviewed, but always cover all 7 review categories.

Use the Task tool with `subagent_type: "Plan"` and a prompt structured as:

```
You are a rigorous bottom-up reviewer evaluating a design from the implementation/infrastructure perspective. Start at the LOWEST layer and work up.

## Context
Read [design doc path(s)] for the proposed changes.
Then read the actual codebase starting from the infrastructure layer up.

## Review Categories (cover ALL of these)

### 1. Infrastructure Validation
- Does the design's core mechanism actually work at the infrastructure level?
- Trace the exact code path from the proposed change through shared libraries to the underlying system (database, Solr, external API)
- Verify parameter names, types, and serialization formats
- Check for conflicts with existing parameters or defaults

### 2. Serialization Path Tracing
- Trace how data flows from the caller through serialization to the infrastructure and back
- Check every type conversion, model_dump(), model_validate_json() call
- What happens when types don't match? When extra fields are present?
- Are there strict validation modes (extra="forbid") that would reject new fields?

### 3. Migration Path (Current → Proposed)
- For each component that changes, list every line of code that touches the old behavior
- For each: what replaces it?
- Are there behaviors the old approach provides that the new one cannot replicate?
- Are there implicit contracts (sort orders, consistency guarantees, etc.) that break?

### 4. Impedance Mismatches
- Where do the design's assumptions not match the actual code?
- Are there types, imports, or patterns the design assumes exist but don't?
- Are there hidden dependencies or side effects not accounted for?
- Do shared libraries support the proposed usage patterns?

### 5. Exhaustion/Termination Conditions
- How does the system know when to stop? (pagination end, empty results, error states)
- Are the heuristics reliable? What edge cases break them?
- Is there a more reliable signal available from the infrastructure?

### 6. Performance & Overhead Analysis
- Quantify any overhead the design introduces (re-fetching, extra queries, larger payloads)
- Calculate worst-case scenarios: how bad can it get at scale?
- Does the overhead scale linearly, quadratically, or worse?
- Are there rate limits, timeouts, or resource constraints to consider?

### 7. Simplest Implementation Path
- Given everything found above, what is the minimal viable implementation?
- What can be deferred without compromising correctness?
- What shortcuts does the bottom-up view reveal that the top-down view misses?

Be specific, surgical, and cite exact file paths and line numbers.
Organize findings by severity: BLOCKER > HIGH > MEDIUM > LOW.
```

### Step 3: Present Results

When the agent completes, present the findings to the user organized as:

1. **Blockers** — infrastructure-level issues that prevent the design from working
2. **High severity** — impedance mismatches, broken serialization paths, missing capabilities
3. **Medium severity** — performance concerns, unreliable heuristics, migration gaps
4. **Low severity** — minor implementation considerations
5. **What's validated** — confirmed assumptions about the infrastructure

For each finding, include:
- The specific assumption being validated or challenged
- The exact code path traced (with file paths and line numbers)
- Whether the assumption holds or fails
- Suggested fix if it fails

### Step 4: Discussion

After presenting, ask the user which findings they want to address and help trace the implementation path for the fixes.
