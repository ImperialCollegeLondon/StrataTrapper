---
name: matlab-specialist
description: |
  SKILL — Create, update, review, or debug VS Code agent customization
  files (prompts, instructions, agents, SKILLs) specifically for
  MATLAB projects. Project-agnostic guidance applicable to any MATLAB
  repository. USE FOR: encoding MATLAB workflows (build, MEX/CodeGen,
  parallelism, unit handling, CI), prompt templates and safe automation.
  DO NOT USE FOR: running untrusted binaries or extension development.
---

# Agent Customization (MATLAB Specialist)

## Summary

This skill provides a reproducible, project-agnostic workflow for
authoring and maintaining agent customization artifacts (SKILLs,
prompts, instructions, and agents) tailored to MATLAB projects. It
includes decision heuristics, a lightweight template, acceptance
checks, and runnable example prompts focused on common MATLAB concerns:
`arguments` validation, unit handling, MEX/CodeGen builds, parallelism
(`parfor`), and dependency/toolbox notes.

## When to use

- Create or update `SKILL.md`, `*.prompt.md`, `*.instructions.md`, or
  `*.agent.md` for MATLAB repositories.
- Encode multi-step workflows that require context, templates, or
  validation (for example: add a MEX build, a CI job, and a minimal test).
- Capture MATLAB project conventions, commit guidelines, or repeatable
  automation patterns.

## Outcomes

- A SKILL file saved under a recommended location that includes:
  - Purpose and usage examples.
  - A deterministic workflow with decision points.
  - Acceptance checks and at least one example prompt or runnable snippet.
  - Reusable templates for prompts/instructions.

## Decision flow (short)

- Scope: Workspace (team) vs personal. Workspace → `.vscode/skills/` or
  `.github/skills/`. Personal → user prompt folder.
- Primitive selection: Prompt → single-step; Instruction → always-on
  guidance; Skill → multi-step workflow; Agent → needs context
  isolation or tool restrictions.

## Step-by-step process this skill encodes

1. Gather minimal context: `README`, `startup`/build scripts, and any
   existing agent instructions.
2. Clarify scope and approvals (workspace vs personal; required reviewers).
3. Draft the SKILL.md using the template below; keep examples small and reproducible.
4. Add acceptance checks (frontmatter, discovery keywords, runnable example or annotation).
5. Save SKILL.md and optionally open a PR with a Conventional Commit.

## Decision points and branching logic

- Changes that affect builds, CI, or release flows require human review
  and explicit environment annotations (toolbox/license requirements).
- Documentation-only workflows may be published as prompts or
  instructions without automated hooks.
- Workflows requiring proprietary toolboxes or large datasets must
  include clear notes and optional 'dry-run' examples.

## Quality criteria / acceptance checks

- Frontmatter present: `name` and `description`.
- `description` contains discovery keywords and at least one example
  trigger phrase.
- At least one example prompt or runnable snippet, or a clear annotation
  explaining environment constraints.
- No destructive hooks without explicit user confirmation and review.

## MATLAB-specific best practices

- Use `arguments` blocks for public functions to validate inputs.
- Prefer unit helper functions (e.g., `meter()`, `pascal()`) rather than magic numbers; document unit expectations in examples.
- Favor vectorized operations and avoid unnecessary dynamic typing when MATLAB Coder compatibility is desired.
- For performance workflows, document MEX/CodeGen and `parfor` usage and list required toolboxes (e.g., Parallel Computing Toolbox, MATLAB Coder).
- Keep example datasets and tests small and deterministic so they can run in CI.

## Transferrable patterns

- Prefer small, well-tested pure functions where possible.
- Be explicit about side effects: state mutations and I/O should be documented.
- Use an `Options`-style struct for configurable behavior instead of globals.

## SKILL template (recommended)

---

name: agent-customization-matlab.<short-name>
description: |
Short one-line purpose. Discovery keywords: `build`, `mex`, `parfor`, `ci`, `test`.

---

# Title: short descriptive title

## Purpose

One-paragraph description of what the skill does and when to use it.

## When to use

- Short bullets with triggers and scope.

## Workflow

1. Step one: read/gather context.
2. Step two: create/update files or templates.
3. Step three: validate and add acceptance checks.

## Examples / Prompts

- Example: "Add a SKILL.md showing how to build `myfunc.m` as a MEX and add a CI job that runs a small test."

## Acceptance checks

- SKILL file exists in the recommended location.
- Example prompt or runnable snippet present or clearly annotated.

## Notes

- Annotate non-obvious restrictions: licenses, required toolboxes, large datasets.

## Example prompts to try

- "Create a SKILL.md that documents adding a MEX build step and CI job for tests with a small sample dataset."
- "Add a prompt template that scaffolds a `parfor`-safe unit test with a minimal input example."

## Location and naming

- Suggested location: `.vscode/skills/<short-name>/SKILL.md` or `.github/skills/<short-name>/SKILL.md`.
- Use a short hyphenated `name:` (e.g., `agent-customization-matlab.build-ci`).

## Commit & review guidance

- Use Conventional Commits. Example:

  ```
  feat(skills): ✨ add agent-customization-matlab.build-ci SKILL

  Adds a skill describing a CI job for building and testing the repo.
  ```

- Require reviewer for changes affecting builds, CI, or release processes.

## Maintenance

- Keep examples small, runnable, and up to date with repo conventions.

## What I produced and next steps

- Made `SKILL.md` MATLAB-specialist and project-agnostic, removing repository-specific examples and adding reusable templates and checks.
- Next: commit to a branch and open a PR, or copy to `.github/skills/` for wider visibility?

---
