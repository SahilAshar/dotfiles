# AGENTS Style Guide

Use this guide when making changes in this repository.

## Core Principles

- Be surgical: implement only what the request requires.
- Prefer root-cause fixes over surface patches.
- Keep changes small, local, and easy to review.
- Preserve existing behavior unless the request explicitly changes it.

## Design for Clarity

- Separate concerns with small, composable functions.
- Prefer a general helper plus a thin context-specific wrapper when it improves reuse and clarity.
- Use explicit names that describe purpose, not implementation detail.
- Avoid clever abstractions; optimize for readability and maintenance.

## Refactor Pattern (Preferred)

When existing logic is duplicated or too specific:

1. Extract shared behavior into a generic helper.
2. Keep call sites simple via narrow wrappers.
3. Update only affected paths.
4. Verify idempotency and error handling still hold.

Example pattern:

- Generic helper: link any source path to any destination path safely.
- Thin wrapper: map repo-relative paths into `$HOME`-specific links.

## Safety and Idempotency

- Every install-time action must be safe to rerun.
- Skip work when the desired state already exists.
- Back up before replacing user files.
- Fail fast with actionable stderr messages when unsafe to proceed.

## Testing Expectations

- Update tests with each behavioral change.
- Prefer focused tests that verify the changed contract.
- Keep tests aligned with function names and actual wiring.
- Run the relevant suite before handoff.

## Scope Discipline

- Do not bundle unrelated cleanup into functional changes.
- Avoid repo-wide rewrites for local problems.
- Keep naming and structure consistent with existing project conventions.
