---
name: test
description: Plan and report test execution for a change
argument-hint: "scope, commands, environment, results"
---

# Test Prompt Template

## Goal
${input:goal}

## Inputs
- Test scope: ${input:scope}
- Commands available: ${input:commands}
- Environment notes: ${input:environment}

## Steps
1. ${input:identify_step}
2. ${input:run_step}
3. ${input:summary_step}
4. ${input:failure_step}

## Output Format
- Summary: ${input:summary}
- Commands Run:
  - ${input:command_1}
  - ${input:command_2}
- Results:
  - ${input:results}
- Citations: ${input:citations}
