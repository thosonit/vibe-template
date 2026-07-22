# CLAUDE.md

## Project Overview

- Goal: starter template for "vibe coding" — fast, iterative development in conversation with an AI assistant instead of heavy upfront design docs (see `README.md`).
- Multi-stack template: each sub-project lives in its own `src/<project-name>/` folder, with its source architecture defined under `docs/architecture/`:
  - `docs/architecture/NEXT_ARCHITECTURE.md` — Next.js (App Router, Server Components by default, Prisma, feature-first).
  - `docs/architecture/FLUTTER_ARCHITECTURE.md` — Flutter app.
  - When starting a sub-project, read the matching architecture file before writing new code; don't assume a stack that hasn't been confirmed.
  - Never place source code directly under `src/` — always nest it under `src/<project-name>/` (e.g. `src/web/`, `src/mobile/`), so multiple stacks can coexist in the same repo.
- Development lifecycle (spec → db → api → screen spec → screen UI → plan → implement → test) follows the order described in `README.md`.

## Repository Structure

```text
.claude/             # Assistant config: skills, agents, hooks, settings
src/
└── <project-name>/  # One folder per sub-project (e.g. web/, mobile/), per the
                      # architecture in docs/architecture/ — never source directly under src/
docs/
├── architecture/    # NEXT_ARCHITECTURE.md, FLUTTER_ARCHITECTURE.md — source architecture per stack
├── specs/           # CODE-feature-name.spec.md
├── plans/           # CODE-feature-name-plan.md + plan.md (overall tracking)
├── api/             # api.md (conventions/index) + endpoints/*.md (one file per endpoint group)
├── database/        # db.md — single shared schema/ERD/migration notes doc for the whole project
├── screens/         # FEATURE-CODE-screen-name-00.screen.md + paired .html prototype
└── design/          # DESIGN.md + design-system.html
tests/               # Unit / integration / e2e tests
```

## Naming Convention

- `CODE` is a short uppercase identifier for a feature area (e.g. `AUTH`, `PAY`), used consistently across spec ↔ plan ↔ db ↔ branch ↔ commit.
- Spec: `docs/specs/CODE-feature-name.spec.md`
- Plan: `docs/plans/CODE-feature-name-plan.md`
- DB notes: shared `docs/database/db.md`, extended in place per feature (no per-`CODE` file)
- API notes: shared `docs/api/api.md` (conventions/index) + `docs/api/endpoints/*.md` per endpoint group (not per-`CODE`)
- Screen spec: `docs/screens/FEATURE-CODE-screen-name-00.screen.md`, always paired with a same-named `FEATURE-CODE-screen-name-00.html`.

## Docs Instructions

- Always define a spec using the `superpowers:brainstorming` skill before writing `docs/specs/*.spec.md`.
- After a new spec is finalized, review all related specs to resolve conflicts (overlapping scope, contradictory behavior).
- Every UI/HTML file (screen prototype) must follow `docs/design/DESIGN.md` and `docs/design/design-system.html`.
- Every screen prototype's matching `FEATURE-CODE-screen-name-00.html` is the visual source of truth for that screen — strictly follow it (layout, spacing, states), together with `docs/design/design-system.html` and `docs/design/DESIGN.md`, before writing new UI markup/styles.
- Create/update the corresponding entry in `docs/plans/plan.md` (checklist for the 8-step lifecycle in `README.md`) after each step completes.

## Define Plan Instructions

- Follow the architecture file in `docs/architecture/` matching the stack of the sub-project you're working on.
- Use the `superpowers:writing-plans` skill (or the `planner` agent) to create the plan.
- Create `docs/plans/CODE-feature-name-plan.md`.
- Update the checklist in `docs/plans/plan.md`.
- Screens/UI in the plan must follow the screen spec (`docs/screens/`) and the design system (`docs/design/`).

## Implement Instructions

- Follow the architecture file in `docs/architecture/` matching the stack of the sub-project you're working on.
- Use the `superpowers:executing-plans` skill (or `superpowers:subagent-driven-development` for independent tasks).
- Any UI implementation must strictly match the corresponding `docs/screens/FEATURE-CODE-screen-name-00.html` prototype, `docs/design/design-system.html`, and `docs/design/DESIGN.md` — do not deviate on layout, spacing, tokens, or component states without confirming first.
- Always check off the checkbox in the plan file (`docs/plans/CODE-feature-name-plan.md`) right after finishing each step.
- Update `docs/plans/plan.md` after implementation is done.

## Test Instructions

- Use the `superpowers:test-driven-development` / `tdd-workflow` skill: write tests before implementing.
- Before reporting completion, run `superpowers:verification-before-completion` to actually verify build/lint/test pass.
- Tests live in `tests/` (unit/integration/e2e), minimum 80% coverage per `common/testing.md`.

## Rules

- Use the `git-conventions` skill for git operations — GitFlow branch model + Conventional Commits.
- Follow the naming convention and folder structure above; don't create new directory structures outside the defined `docs/` layout without confirming first.
- Never read or print production secrets/config files (`.env`, `.env.production`, credentials, API keys, etc.). If a task seems to need one, ask the user instead of reading it directly.
