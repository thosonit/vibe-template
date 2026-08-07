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
│   ├── adr/           # Architecture Decision Records (optional)
│   └── superpowers/   # Per-task artifacts (superpowers plugin defaults), separate from core docs
│       ├── specs/     # YYYY-MM-DD-task-name.spec.md — task spec draft, not yet synced to core docs
│       └── plans/     # YYYY-MM-DD-task-name.md — implementation plan
├── tests/             # Unit / integration / e2e tests
└── README.md
```

Adapt folder names to your stack (e.g. `src/` → `app/` for web frameworks), but keep the separation of code, docs, and tests.

### Rules

- Everything under `docs/` is the **single source of truth** for the project — always consult it before developing a new feature or change, and always update it the moment something changes. Stale docs are treated as bugs.
- See `CLAUDE.md` for the detailed naming convention and file-by-file breakdown of `docs/`.

## Project Setup (one-time, before the lifecycle)

Do these once when the project starts (or whenever a project-wide technical/process decision changes) — they are not repeated per feature.

1. **Define CLAUDE.md** — project overview, structure, and conventions the assistant follows. Output: `CLAUDE.md`
2. **Define Architecture** (optional) — overall source code structure every feature builds on. Example: run `.claude/skills/scaffold-flutter-app`
3. **Define Git Convention** — branching model, commit format, PR flow. Example: `.claude/skills/git-conventions`
4. **Define Design System** — shared visual language, tokens, UI reference. Output: `docs/design/DESIGN.md` and `docs/design/design-system.html`

## Vibe Coding Development Lifecycle

Per feature/task, in order:

1. **Brainstorm** — `superpowers:brainstorming`; output is the task spec draft `docs/superpowers/specs/YYYY-MM-DD-task-name.spec.md`
2. **Sync Core Docs** (require) — reconcile the task spec draft into `docs/specs/`, `docs/database/`, `docs/api/`, `docs/screens/` right away, before planning starts
3. **Design UI** (optional — only if the task has UI) — `frontend-design` skill; create/update `docs/screens/FEATURE-CODE-screen-name-00.screen.md` + paired `.html` prototype, following `docs/design/DESIGN.md` and `design-system.html`
4. **Define Plan** — `superpowers:writing-plans` (or `planner` agent), based on the core docs already synced in step 2
5. **Implement** — `superpowers:executing-plans` (or `superpowers:subagent-driven-development`)
6. **Code Review** (require) — `superpowers:requesting-code-review`; address feedback before moving on
7. **Self-test** (require) — run build/lint/typecheck via `superpowers:verification-before-completion`, then the user manually tests the feature and confirms before moving on. No unit or e2e tests are written for this project.
8. **Finish Development** (require) — `superpowers:finishing-a-development-branch`; wrap up the git branch

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
