---
name: implement
description: Implement a requested change with file-level details
argument-hint: "goal, targets, behavior, criteria, steps, tests"
---

# Implement Prompt Template

## Goal
${input:goal}

## Inputs
- Target files/modules: ${input:targets}
- Existing behavior: ${input:existing_behavior}
- Acceptance criteria: ${input:acceptance_criteria}

## Steps
1. ${input:inspect_step}
2. ${input:modify_step}
3. ${input:update_step}
4. ${input:validate_step}

## Output Format
- Summary: ${input:summary}
- Changes:
  - ${input:change_1}
  - ${input:change_2}
- Tests/Checks:
  - ${input:test_command}
- Citations: ${input:citations}
