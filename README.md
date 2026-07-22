# Vibe Template

A starter template for **vibe coding** projects — a workflow where you build software through fast, iterative collaboration with an AI coding assistant instead of upfront heavy design docs.

## Folder Structure

```
vibe-template/
├── .claude/          # Assistant config: skills, agents, hooks, settings
├── src/               # Application source code
├── docs/              # Specs, plans, API contracts, screen docs
│   ├── specs/         # Feature requirements / PRDs (CODE-feature-name.spec.md, CODE = uppercase)
│   ├── plans/         # Implementation plans (one per spec)
│   ├── api/           # API contracts (openapi.yaml + per-endpoint notes)
│   ├── db/            # Database schema / ERD / migration notes (one per feature)
│   ├── screens/        # Screen specs (flat, FEATURE-CODE-screen-name-00.screen.md) + per-screen mockup folder
│   ├── design/        # Design tokens and visual system (DESIGN.md + design-system.html)
│   └── adr/           # Architecture Decision Records (optional)
├── tests/             # Unit / integration / e2e tests
└── README.md
```

Adapt folder names to your stack (e.g. `src/` → `app/` for web frameworks), but keep the separation of code, docs, and tests.

### Docs Conventions

- Specs always follow `CODE-feature-name.spec.md`, where `CODE` is a short uppercase identifier for the feature area (e.g. `AUTH-user-auth.spec.md`, `PAY-payment-flow.spec.md`). `CODE` cross-references specs ↔ plans ↔ branch ↔ PR.
- Branch/commit naming should reference the spec code, e.g. branch `feature/AUTH-user-auth`, commit `feat(auth): ...`.
- Screen specs live flat directly under `docs/screens/`, named `FEATURE-CODE-screen-name-00.screen.md` (e.g. `AUTH-login-01.screen.md`), where `FEATURE-CODE` matches the related spec's code. Each screen's mockup stays in its own `docs/screens/<screen-name>/mockup.png`, linked from the spec.
- Every `.screen.md` is always paired with an HTML prototype of the same name (e.g. `AUTH-login-01.screen.md` + `AUTH-login-01.html`), sitting next to it in `docs/screens/`.
- `docs/api/openapi.yaml` is the source of truth for REST contracts; `docs/api/endpoints/*.md` holds prose notes per endpoint group.
- `docs/db/CODE-feature-name.db.md` holds the schema/ERD/migration notes for a feature; the API contract should be written against this, not the other way around.
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

### 1. Define Spec

- **Goal** — Brainstorm the idea/feature in plain language with the assistant (intent, scope, edge cases), then turn the agreed scope into a written spec with requirements and acceptance criteria.
- **Skill used** — `superpowers:brainstorming`
- **Output** — `docs/specs/CODE-feature-name.spec.md`
- **Example prompt** — `"I want to add password-reset via email. Let's brainstorm the flow, then write the spec as AUTH-password-reset."`

### 2. Define Database Schema

- **Goal** — If the feature touches persisted data, define/update the tables, columns, relations, and indexes before designing the API around them.
- **Skill used** — `database-reviewer` agent
- **Output** — `docs/db/CODE-feature-name.db.md` (schema/ERD, migration notes)
- **Example prompt** — `"Based on AUTH-password-reset.spec.md, design the schema for storing reset tokens with expiry."`

### 3. Define API Contract

- **Goal** — If the feature touches the backend, define the request/response contract on top of the schema, so frontend and backend can build against the same shape.
- **Skill used** — none dedicated yet (author manually, or `docs-lookup` to confirm OpenAPI conventions)
- **Output** — `docs/api/openapi.yaml` (updated) + `docs/api/endpoints/*.md`
- **Example prompt** — `"Based on AUTH-password-reset.spec.md and its db schema, draft the OpenAPI paths for requesting and confirming a reset token."`

### 4. Define Screen Spec

- **Goal** — For each affected screen, document its states, inputs, and behavior, referencing the feature's `CODE`.
- **Skill used** — none dedicated yet (author manually from the spec)
- **Output** — `docs/screens/FEATURE-CODE-screen-name-00.screen.md`
- **Example prompt** — `"Create the screen spec AUTH-password-reset-01 for the 'request reset link' screen, based on the approved spec."`

### 5. Define Screen UI

- **Goal** — Build or update a static HTML prototype of each screen so the UI can be reviewed visually before wiring real code.
- **Skill used** — `frontend-design` conventions from the `web` rules (design tokens, semantic HTML, no template-looking UI)
- **Output** — `docs/screens/FEATURE-CODE-screen-name-00.html` (paired with its `.screen.md`)
- **Example prompt** — `"Build the HTML prototype for AUTH-password-reset-01.screen.md, matching our design tokens."`

### 6. Define Plan

- **Goal** — Break the spec (and API contract/screen specs) into concrete, ordered implementation steps with risks and dependencies called out.
- **Skill used** — `superpowers:writing-plans` (or the `planner` agent)
- **Output** — `docs/plans/CODE-feature-name-plan.md`
- **Example prompt** — `"Write the implementation plan for AUTH-password-reset based on the spec, API contract, and screen specs."`

### 7. Implement Plan

- **Goal** — Execute the approved plan step by step, writing the actual code (and updating the plan/checkboxes as steps land).
- **Skill used** — `superpowers:executing-plans` (or `superpowers:subagent-driven-development` for independent tasks in the same session)
- **Output** — Working code on `feature/CODE-feature-name`, following GitFlow branch/commit conventions
- **Example prompt** — `"Execute step 1 of the AUTH-password-reset-plan.md."`

### 8. Run Tests

- **Goal** — Verify correctness with unit/integration/E2E tests plus build/lint before committing.
- **Skill used** — `superpowers:test-driven-development`, `tdd-workflow`, `superpowers:verification-before-completion`
- **Output** — Passing test suite for `feature/CODE-feature-name`
- **Example prompt** — `"Run the full test suite for AUTH-password-reset and fix any failures."`

Repeat the loop per feature. Favor short cycles over big up-front specs — let working code and feedback shape the next step.

### Tracking Progress: `docs/plans/plan.md`

Every new idea/feature gets one top-level entry in `docs/plans/plan.md`. Inside each entry, track lifecycle progress with checkboxes — one per step above:

```markdown
## AUTH-password-reset — Password reset via email

- [x] 1. Define Spec
- [ ] 2. Define Database Schema
- [ ] 3. Define API Contract
- [ ] 4. Define Screen Spec
- [ ] 5. Define Screen UI
- [ ] 6. Define Plan
- [ ] 7. Implement Plan
- [ ] 8. Run Tests
```

Check a box only once that step's output has been produced and confirmed.

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
