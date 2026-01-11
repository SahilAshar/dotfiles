---
name: plan
description: Create a repo-specific plan
argument-hint: "goal, context, requirements, constraints"
---

# Plan Prompt Template

## Goal
${input:goal}

## Inputs
- Repo context: ${input:context}
- Requirements: ${input:requirements}
- Constraints: ${input:constraints}

## Steps
1. ${input:inspect_step}
2. ${input:impact_step}
3. ${input:plan_step}
4. ${input:risk_step}

## Output Format
- Summary: ${input:summary}
- Tasks:
  - ${input:task_1}
  - ${input:task_2}
- Risks/Notes: ${input:risks}
- Citations: ${input:citations}
