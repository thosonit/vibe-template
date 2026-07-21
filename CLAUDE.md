# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository status

This repository is a bare starter template for vibe-coding projects. It currently contains only `README.md` — no source code, build tooling, or tests exist yet. The folders described in the README (`.claude/`, `src/`, `docs/`, `tests/`) are proposed structure, not yet created.

Before assuming any command or convention, check whether the relevant files/tooling actually exist in the repo.

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
