# CLAUDE.md

## Project Overview

- Goal: starter template for "vibe coding" — fast, iterative development in conversation with an AI assistant instead of heavy upfront design docs (see `README.md`).
- Multi-stack template: each sub-project lives in its own `src/<project-name>/` folder, with its source architecture defined under `docs/architecture/`:
  - `docs/architecture/NEXT_ARCHITECTURE.md` — Next.js (App Router, Server Components by default, Prisma, feature-first).
  - `docs/architecture/FLUTTER_ARCHITECTURE.md` — Flutter app.
  - When starting a sub-project, read the matching architecture file before writing new code; don't assume a stack that hasn't been confirmed.
  - Never place source code directly under `src/` — always nest it under `src/<project-name>/` (e.g. `src/web/`, `src/mobile/`), so multiple stacks can coexist in the same repo.

## Repository Structure

```text
.claude/             # Assistant config: skills, agents, hooks, settings
src/
└── <project-name>/  # One folder per sub-project (e.g. web/, mobile/), per the
                      # architecture in docs/architecture/ — never source directly under src/
docs/                # Core reference documentation
├── architecture/    # NEXT_ARCHITECTURE.md, FLUTTER_ARCHITECTURE.md — source architecture per stack
├── specs/           # CODE-feature-name.spec.md + spec.md (overview)
├── api/             # api.md (conventions/index) + endpoints/*.md (one file per endpoint group)
├── database/        # db.md — single shared schema/ERD/migration notes doc for the whole project
├── screens/         # FEATURE-CODE-screen-name-00.screen.md + paired .html prototype + screen.md (overview)
├── design/          # DESIGN.md + design-system.html
└── superpowers/     # Per-task artifacts (superpowers plugin defaults), separate from core docs
    ├── specs/       # YYYY-MM-DD-task-name.spec.md — task spec draft (step 1, Brainstorm)
    └── plans/       # YYYY-MM-DD-task-name.md — implementation plan (step 4, Define Plan)
tests/               # Unit / integration / e2e tests (not used by this project — see Test Instructions)
```

## Naming Convention

- `CODE` is a short uppercase identifier for a feature area (e.g. `AUTH`, `PAY`), used consistently across spec ↔ db ↔ branch ↔ commit.
- Core spec (single source of truth for what a feature does): `docs/specs/CODE-feature-name.spec.md` — only ever created/updated during step 2 (Sync Core Docs), never written directly at the start of a task.
- Task spec draft: `docs/superpowers/specs/YYYY-MM-DD-task-name.spec.md` — written in step 1 (Brainstorm) for every task, new feature or change alike.
- Plan: `docs/superpowers/plans/YYYY-MM-DD-task-name.md`, same task name as its spec draft. Files stay in place permanently once written — no working/archive move, git history is the record. Each task creates a new dated file rather than editing an old one — history stays linear.
- DB notes: shared `docs/database/db.md`, extended in place per feature (no per-`CODE` file)
- API notes: shared `docs/api/api.md` (conventions/index) + `docs/api/endpoints/*.md` per endpoint group (not per-`CODE`)
- Screen spec: `docs/screens/FEATURE-CODE-screen-name-00.screen.md`, always paired with a same-named `FEATURE-CODE-screen-name-00.html`.

## Docs Instructions

- Always brainstorm using the `superpowers:brainstorming` skill before writing a task spec — for every task, new feature or change to an existing one alike.
- Write that task spec to `docs/superpowers/specs/YYYY-MM-DD-task-name.spec.md` (step 1, Brainstorm). Never write directly to `docs/specs/` at this stage — the core spec is only touched in step 2.
- **Sync Core Docs gate (mandatory, no exceptions):** immediately after the task spec draft is written (step 2, before Define Plan starts), fully reconcile it into the corresponding core doc(s) under `docs/` (`specs/CODE-feature-name.spec.md`, plus `database/`, `api/`, `screens/` as applicable). Explicitly re-read the draft against the current core doc(s) and confirm every requirement/acceptance criterion is reflected before moving on to Define Plan — never defer this to the end of the task. Creating `docs/specs/CODE.spec.md` for the first time (new feature) and updating it in place (change) follow the exact same gate.
- After a core spec is created/updated, review other related core specs to resolve conflicts (overlapping scope, contradictory behavior).
- Every UI/HTML file (screen prototype) must follow `docs/design/DESIGN.md` and `docs/design/design-system.html`.
- Every screen prototype's matching `FEATURE-CODE-screen-name-00.html` is the visual source of truth for that screen — strictly follow it (layout, spacing, states), together with `docs/design/design-system.html` and `docs/design/DESIGN.md`, before writing new UI markup/styles.
- Step 3 (Design UI) is optional — only runs when the task has UI; use the `frontend-design` skill to create/update the screen prototype.

## Define Plan Instructions

- Follow the architecture file in `docs/architecture/` matching the stack of the sub-project you're working on.
- Use the `superpowers:writing-plans` skill (or the `planner` agent) to create the plan.
- Create `docs/superpowers/plans/YYYY-MM-DD-task-name.md`, based on the core docs already synced in step 2 (`docs/specs/`, `docs/database/`, `docs/api/`, `docs/screens/`).
- Screens/UI in the plan must follow the screen spec (`docs/screens/`) and the design system (`docs/design/`).

## Implement Instructions

- Follow the architecture file in `docs/architecture/` matching the stack of the sub-project you're working on.
- Use the `superpowers:executing-plans` skill (or `superpowers:subagent-driven-development` for independent tasks).
- Any UI implementation must strictly match the corresponding `docs/screens/FEATURE-CODE-screen-name-00.html` prototype, `docs/design/design-system.html`, and `docs/design/DESIGN.md` — do not deviate on layout, spacing, tokens, or component states without confirming first.
- Always check off the checkbox in the plan file (`docs/superpowers/plans/YYYY-MM-DD-task-name.md`) right after finishing each step.
- Implementation must match the core docs already synced in step 2 — if scope diverges during implementation, update the core docs and the task spec draft to match before moving to Code Review.

## Code Review Instructions

- Use the `superpowers:requesting-code-review` skill right after implementation, before Self-test.
- Address CRITICAL and HIGH findings before moving on; MEDIUM/LOW are optional per `common/code-review.md`.
- If review feedback changes scope, update the core docs and task spec draft to match before moving to Self-test.

## Test Instructions

- **Override notice:** this project overrides `~/.claude/rules/common/testing.md` and `~/.claude/rules/web/testing.md` — no unit tests, no e2e tests, no coverage requirement. This is a deliberate project-level decision, not an oversight.
- Before reporting completion, run `superpowers:verification-before-completion` to verify build/lint/typecheck pass (whatever the sub-project has configured) — this is the only automated check.
- After that passes, hand off to the user to manually run and test the feature (self-test). Wait for the user's explicit confirmation that it works before moving to Finish Development (step 8) — do not assume self-test passed.

## Rules

- **Superpowers plugin required (mandatory, no exceptions):** before doing any work in this repo — brainstorming, syncing docs, planning, implementing, code review, or finishing development — confirm the Superpowers plugin is installed and its skills (`superpowers:*`) are available. If it is missing, stop and ask the user to install it first rather than proceeding with equivalent ad-hoc steps; this project's workflow (brainstorm → sync core docs → design UI → plan → implement → code review → self-test → finish development) is built directly on `superpowers:*` skills for every step except Self-test, and is not a substitute for having the plugin.
- Use the `git-conventions` skill for git operations — GitFlow branch model + Conventional Commits.
- Follow the naming convention and folder structure above; don't create new directory structures outside the defined `docs/` layout without confirming first.
- Never read or print production secrets/config files (`.env`, `.env.production`, credentials, API keys, etc.). If a task seems to need one, ask the user instead of reading it directly.
