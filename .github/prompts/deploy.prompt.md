---
name: deploy
description: Create a deployment checklist and summary
argument-hint: "goal, target, services, credentials, verification"
---

# Deploy Prompt Template

## Goal
${input:goal}

## Inputs
- Deployment target: ${input:target}
- Services/components: ${input:services}
- Required credentials/vars: ${input:credentials}

## Steps
1. ${input:verify_step}
2. ${input:deploy_step}
3. ${input:health_step}
4. ${input:rollback_step}

## Output Format
- Summary: ${input:summary}
- Commands Run:
  - ${input:command_1}
  - ${input:command_2}
- Verification:
  - ${input:verification}
- Citations: ${input:citations}
