# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository status

This repository is a bare starter template for vibe-coding projects. It currently contains only `README.md`, `CLAUDE.md`, `.claude/`, and a scaffolded `docs/` tree — no source code, build tooling, or tests exist yet. `src/` and `tests/` are proposed structure, not yet created.

Before assuming any command or convention, check whether the relevant files/tooling actually exist in the repo.

## Docs structure

`docs/` is organized by document type, numbered for chronological cross-referencing:

- `docs/specs/` — feature requirements / PRDs, always named `CODE-feature-name.spec.md`, where `CODE` is a short uppercase identifier (e.g. `AUTH-user-auth.spec.md`)
- `docs/plans/` — implementation plans, one per spec (`CODE-feature-name-plan.md`)
- `docs/api/` — API contracts (`openapi.yaml` + `endpoints/*.md`)
- `docs/screens/` — screen specs, flat, named `FEATURE-CODE-screen-name-00.screen.md` (e.g. `AUTH-login-01.screen.md`), where `FEATURE-CODE` matches the related spec's code; each screen's `mockup.png` stays in its own `docs/screens/<screen-name>/` folder, linked from the spec. Every `.screen.md` is always paired with a same-named `.html` prototype next to it (e.g. `AUTH-login-01.html`).
- `docs/adr/` — Architecture Decision Records (optional)

Use the same `CODE` prefix across a spec, its plan, and its feature branch/PR (e.g. spec `AUTH-user-auth.spec.md` ↔ plan `AUTH-user-auth-plan.md` ↔ branch `feature/AUTH-user-auth`).

## Purpose

Per `README.md`, this template exists to support a "vibe coding" workflow: fast, iterative development in conversation with an AI assistant rather than heavy upfront design docs. The lifecycle is:

1. Prompt — describe the feature/fix in plain language, small scope
2. Generate — draft code/tests/plan
3. Review — check the diff matches intent
4. Iterate — refine via conversation, not manual rewrites
5. Verify — run tests/build/lint before moving on
6. Commit — small, frequent commits

When a real project is scaffolded from this template, update this file with actual build/lint/test commands and real architecture notes once they exist.

## Git Workflow

This project uses **GitFlow**:

- `main` — production-ready code only
- `develop` — integration branch; all feature work merges here first
- `feature/*` — branch from `develop`, merge back into `develop`
- `release/*` — branch from `develop`, merge into both `main` and `develop`
- `hotfix/*` — branch from `main`, merge into both `main` and `develop`

Use Conventional Commits for messages (`feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `ci`, `revert`), e.g. `feat(auth): add OAuth2 login`.

See the `git-workflow` skill (`.claude/skills/git-workflow/SKILL.md`) for full branching, commit, merge/rebase, conflict-resolution, and release conventions.
