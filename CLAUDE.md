# CLAUDE.md

Starter template for "vibe coding" — fast, iterative development in conversation with an AI assistant instead of heavy upfront design docs. Multi-stack: each sub-project lives in its own `src/<project-name>/` folder, with its source architecture defined under `docs/architecture/`:

- `docs/architecture/NEXT_ARCHITECTURE.md` — Next.js (App Router, Server Components by default, Prisma, feature-first).
- `docs/architecture/FLUTTER_ARCHITECTURE.md` — Flutter app.
- When starting a sub-project, read the matching architecture file before writing new code; don't assume a stack that hasn't been confirmed.
- Never place source code directly under `src/` — always nest it under `src/<project-name>/` (e.g. `src/web/`, `src/mobile/`), so multiple stacks can coexist in the same repo.

## Structure

```text
.claude/             # Assistant config: skills, agents, hooks, settings
src/
└── <project-name>/  # One folder per sub-project (e.g. web/, mobile/), per the
                      # architecture in docs/architecture/ — never source directly under src/
docs/                # Core reference documentation — single source of truth, always kept up to date
├── architecture/    # NEXT_ARCHITECTURE.md, FLUTTER_ARCHITECTURE.md — source architecture per stack
├── specs/           # CODE-feature-name.spec.md + spec.md (overview)
├── api/             # api.md (conventions/index) + endpoints/*.md (one file per endpoint group)
├── database/        # db.md — single shared schema/ERD/migration notes doc for the whole project
├── screens/         # FEATURE-CODE-screen-name-00.screen.md + paired .html prototype + screen.md (overview)
├── design/          # DESIGN.md + design-system.html
└── superpowers/     # Per-task artifacts (superpowers plugin defaults), separate from core docs
    ├── specs/       # YYYY-MM-DD-task-name.spec.md — task spec draft (step 1, Brainstorm)
    └── plans/       # YYYY-MM-DD-task-name.md — implementation plan (step 4, Define Plan)
tests/               # Unit / integration / e2e tests (not used by this project — see step 7 notes)
```

### Naming Convention

- `CODE` is a short uppercase identifier for a feature area (e.g. `AUTH`, `PAY`), used consistently across spec ↔ db ↔ branch ↔ commit.
- Core spec (single source of truth for what a feature does): `docs/specs/CODE-feature-name.spec.md` — only ever created/updated during step 2 (Sync Core Docs), never written directly at the start of a task.
- Task spec draft: `docs/superpowers/specs/YYYY-MM-DD-task-name.spec.md` — written in step 1 (Brainstorm) for every task, new feature or change alike.
- Plan: `docs/superpowers/plans/YYYY-MM-DD-task-name.md`, same task name as its spec draft. Files stay in place permanently once written — no working/archive move, git history is the record. Each task creates a new dated file rather than editing an old one — history stays linear.
- DB notes: shared `docs/database/db.md`, extended in place per feature (no per-`CODE` file).
- API notes: shared `docs/api/api.md` (conventions/index) + `docs/api/endpoints/*.md` per endpoint group (not per-`CODE`).
- Screen spec: `docs/screens/FEATURE-CODE-screen-name-00.screen.md`, always paired with a same-named `FEATURE-CODE-screen-name-00.html`.

## Develop Instructions

Per feature/task, in order:

1. **Brainstorm**
   - Skill: `superpowers:brainstorming`
   - Output: task spec draft `docs/superpowers/specs/YYYY-MM-DD-task-name.spec.md`
   - Notes: run for every task, new feature or change to an existing one alike. Never write directly to `docs/specs/` at this stage — the core spec is only touched in step 2.

2. **Sync Core Docs** (require)
   - Output: reconciled core doc(s) under `docs/` — `specs/CODE-feature-name.spec.md`, plus `database/`, `api/`, `screens/` as applicable
   - Notes: mandatory gate, no exceptions — runs immediately after the task spec draft is written, before Define Plan starts. Explicitly re-read the draft against the current core doc(s) and confirm every requirement/acceptance criterion is reflected. Creating `docs/specs/CODE.spec.md` for the first time (new feature) and updating it in place (change) follow the exact same gate. After sync, review other related core specs to resolve conflicts (overlapping scope, contradictory behavior).

3. **Design UI** (optional — only if the task has UI)
   - Skill: `frontend-design`
   - Output: `docs/screens/FEATURE-CODE-screen-name-00.screen.md` + paired `.html` prototype
   - Notes: must follow `docs/design/DESIGN.md` and `docs/design/design-system.html`. The `.html` prototype is the visual source of truth for that screen — strictly follow it (layout, spacing, states) before writing new UI markup/styles. Render the actual screen's full UI as it appears in the real app (full-viewport, no doc-preview chrome — no outer page header or top bar). All states the screen spec defines (default, loading, error variants, empty, etc.) live on that one real layout, switched via a floating, collapsible panel pinned to a screen corner — not side-by-side duplicate cards.

4. **Define Plan**
   - Skill: `superpowers:writing-plans` (or the `planner` agent)
   - Output: `docs/superpowers/plans/YYYY-MM-DD-task-name.md`
   - Notes: follow the architecture file matching the sub-project's stack. Base the plan on the core docs already synced in step 2. Screens/UI in the plan must follow the screen spec (`docs/screens/`) and the design system (`docs/design/`).

5. **Implement**
   - Skill: `superpowers:executing-plans` (or `superpowers:subagent-driven-development` for independent tasks)
   - Output: working code matching the plan
   - Notes: follow the architecture file matching the sub-project's stack. UI implementation must strictly match the screen prototype, `docs/design/design-system.html`, and `docs/design/DESIGN.md` — do not deviate on layout, spacing, tokens, or component states without confirming first. Check off the checkbox in the plan file right after finishing each step. If scope diverges, update the core docs and task spec draft to match before Code Review.

6. **Code Review** (require)
   - Skill: `superpowers:requesting-code-review`
   - Output: reviewed code with CRITICAL/HIGH findings addressed
   - Notes: MEDIUM/LOW findings are optional per `common/code-review.md`. If review feedback changes scope, update the core docs and task spec draft to match before Self-test.

7. **Self-test** (require)
   - Skill: `superpowers:verification-before-completion`
   - Output: passing build/lint/typecheck, plus the user's explicit confirmation that the feature works
   - Notes: this project overrides `~/.claude/rules/common/testing.md` and `~/.claude/rules/web/testing.md` — no unit tests, no e2e tests, no coverage requirement (deliberate project-level decision, not an oversight). Verification-before-completion is the only automated check; after it passes, hand off to the user to manually test. Wait for the user's explicit confirmation before moving to step 8 — never assume self-test passed.

8. **Finish Development** (require)
   - Skill: `superpowers:finishing-a-development-branch`
   - Output: wrapped-up git branch

## Rules

- **Superpowers plugin required (mandatory):** confirm the Superpowers plugin (`superpowers:*` skills) is installed before doing any work.
- Use the `git-conventions` skill for git operations — GitFlow branch model + Conventional Commits.
- Follow the naming convention and folder structure above; don't create new directory structures outside the defined `docs/` layout without confirming first.
- Never read or print production secrets/config files (`.env`, `.env.production`, credentials, API keys, etc.). If a task seems to need one, ask the user instead of reading it directly.
