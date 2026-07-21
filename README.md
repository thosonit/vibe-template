# Vibe Template

A starter template for **vibe coding** projects — a workflow where you build software through fast, iterative collaboration with an AI coding assistant instead of upfront heavy design docs.

## Folder Structure

```
vibe-template/
├── .claude/          # Assistant config: skills, agents, hooks, settings
├── src/               # Application source code
├── docs/              # Specs, notes, and generated docs
├── tests/             # Unit / integration / e2e tests
└── README.md
```

Adapt folder names to your stack (e.g. `src/` → `app/` for web frameworks), but keep the separation of code, docs, and tests.

## Vibe Coding Development Lifecycle

1. **Prompt** — Describe the feature or fix in plain language. Keep scope small.
2. **Generate** — Let the assistant draft code, tests, or a plan.
3. **Review** — Read the diff, check it matches intent, ask follow-up questions.
4. **Iterate** — Refine via conversation (not manual rewrites) until it's right.
5. **Verify** — Run tests/build/lint to confirm correctness before moving on.
6. **Commit** — Small, frequent commits with clear messages.

Repeat the loop per feature. Favor short cycles over big up-front specs — let working code and feedback shape the next step.
