# Vibe Template

A starter template for **vibe coding** projects — a workflow where you build software through fast, iterative collaboration with an AI coding assistant instead of upfront heavy design docs.

## Folder Structure

```
vibe-template/
├── .claude/          # Assistant config: skills, agents, hooks, settings
├── src/               # Application source code
├── docs/              # Core reference docs: specs, API contracts, screen docs
│   ├── specs/         # Feature requirements / PRDs (CODE-feature-name.spec.md, CODE = uppercase)
│   ├── api/           # API contracts (openapi.yaml + per-endpoint notes)
│   ├── database/      # Database schema / ERD / migration notes (one per feature)
│   ├── screens/        # Screen specs (flat, FEATURE-CODE-screen-name-00.screen.md) + per-screen mockup folder
│   ├── design/        # Design tokens and visual system (DESIGN.md + design-system.html)
│   └── adr/           # Architecture Decision Records (optional)
├── plans/             # Implementation plans, separate from core docs
│   ├── plan.md        # Overall tracking (5-step lifecycle checklist per task)
│   ├── working/        # YYYY-MM-DD-task-name.spec.md + YYYY-MM-DD-task-name.md pairs, not yet synced to core docs
│   └── archive/        # Same pairs, moved here once synced to core docs (see Docs Sync Rule)
├── tests/             # Unit / integration / e2e tests
└── README.md
```

Adapt folder names to your stack (e.g. `src/` → `app/` for web frameworks), but keep the separation of code, docs, and tests.

### Docs Conventions

- Specs always follow `CODE-feature-name.spec.md` under `docs/specs/` — this is the **core spec**, the single current source of truth for what a feature does. `CODE` is a short uppercase identifier for the feature area (e.g. `AUTH-user-auth.spec.md`, `PAY-payment-flow.spec.md`), cross-referencing specs ↔ db ↔ branch ↔ PR.
- Every task — a brand-new feature or a change to one that already ships — starts with a **task spec draft**: `plans/working/YYYY-MM-DD-task-name.spec.md`. It never touches `docs/specs/` directly; it's folded into the core spec only after implementation and tests pass (see [Docs Sync Rule](#docs-sync-rule-mandatory)).
- The implementation plan for that task lives next to its spec draft, same name, same folder: `plans/working/YYYY-MM-DD-task-name.md`. Each task creates a new dated pair instead of editing an old one, so history stays linear and traceable.
- Branch/commit naming should reference the spec code, e.g. branch `feature/AUTH-user-auth`, commit `feat(auth): ...`.
- Screen specs live flat directly under `docs/screens/`, named `FEATURE-CODE-screen-name-00.screen.md` (e.g. `AUTH-login-01.screen.md`), where `FEATURE-CODE` matches the related spec's code. Each screen's mockup stays in its own `docs/screens/<screen-name>/mockup.png`, linked from the spec.
- Every `.screen.md` is always paired with an HTML prototype of the same name (e.g. `AUTH-login-01.screen.md` + `AUTH-login-01.html`), sitting next to it in `docs/screens/`.
- `docs/api/openapi.yaml` is the source of truth for REST contracts; `docs/api/endpoints/*.md` holds prose notes per endpoint group.
- `docs/database/CODE-feature-name.db.md` holds the schema/ERD/migration notes for a feature; the API contract should be written against this, not the other way around.
- `docs/design/DESIGN.md` captures the shared visual language (tokens, typography, spacing, components), and `docs/design/design-system.html` is a static reference page for that system.
- `docs/adr/CODE-feature-name.adr.md` records source-code structure (which modules/folders under `src/` the feature touches) and key technical decisions (e.g. "login uses JWT, not sessions") — one ADR per feature, not one giant project-wide doc.

## Project Setup (one-time, before the lifecycle)

Do these once when the project starts (or whenever a project-wide technical/process decision changes) — they are not repeated per feature.

1. **Define Architecture** (optional)
   Decide the overall source code structure that every feature will build on.
   Example: Run the skill `.claude/skills/scaffold-flutter-app` and check its output for an example.

2. **Define Git Convention**
   Agree on the branching model, commit message format, and PR flow the whole team/assistant will follow.
   Example: `.claude/skills/git-conventions`

3. **Define Design System**
   Create or update the shared visual language, tokens, and UI reference for the product.
   Output: `docs/design/DESIGN.md` and `docs/design/design-system.html`

## Vibe Coding Development Lifecycle

Per feature/task, in order:

1. **Brainstorm** — `superpowers:brainstorming`; output is the task spec draft `plans/working/YYYY-MM-DD-task-name.spec.md`
2. **Sync Core Docs** — reconcile the task spec draft into `docs/specs/`, `docs/database/`, `docs/api/`, `docs/screens/` right away, before planning starts
3. **Design UI** (only if the task has UI) — `frontend-design` skill; create/update `docs/screens/FEATURE-CODE-screen-name-00.screen.md` + paired `.html` prototype, following `docs/design/DESIGN.md` and `design-system.html`
4. **Define Plan** — `superpowers:writing-plans` (or `planner` agent), based on the core docs already synced in step 2
5. **Implement** — `superpowers:executing-plans` (or `superpowers:subagent-driven-development`)
6. **Code Review** — `superpowers:requesting-code-review`; address feedback before moving on
7. **Self-test** — run build/lint/typecheck via `superpowers:verification-before-completion`, then the user manually tests the feature and confirms before moving on. No unit or e2e tests are written for this project.
8. **Finish Development** — `superpowers:finishing-a-development-branch`; archive the plan pair to `plans/archive/` and wrap up the git branch

## Claude Settings (`.claude/settings.local.json`)

Local permission overrides for this project — grants the assistant unattended access to the core tools it needs for the lifecycle above.

```jsonc
{
  "permissions": {
    "allow": [
      "Bash(*)", // run shell commands (tests, build, lint, git) without per-call prompts
      "Read(*)", // read any file in the repo
      "Write(*)", // create new files (specs, plans, screens, etc.)
      "Edit(*)", // modify existing files
      "Glob(*)", // pattern-match files by path
      "Grep(*)", // search file contents
    ],
    "deny": [], // no explicit denials — tighten this list if the project needs stricter guardrails
  },
}
```
