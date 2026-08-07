# Superpowers Doc Structure — Task Spec

## Problem

The project used a custom `plans/` directory (`plans/plan.md` tracking file, `plans/working/`, `plans/archive/`) for per-task spec drafts and implementation plans. This duplicates the `superpowers:brainstorming` / `superpowers:writing-plans` skills' own default file locations and adds extra bookkeeping (working/archive moves, a separate tracking checklist) that isn't required.

## Decision

Adopt the superpowers plugin's default locations for per-task artifacts, dropping `plans/` entirely:

- Task spec draft (Brainstorm output): `docs/superpowers/specs/YYYY-MM-DD-task-name.spec.md`
- Implementation plan (Define Plan output): `docs/superpowers/plans/YYYY-MM-DD-task-name.md`
- No `working/`/`archive/` subfolders and no top-level tracking file — files stay in place permanently, dated; git history is the record of when a task was done.

`docs/specs/CODE-feature-name.spec.md` remains the **core spec** (single source of truth for a feature). The Sync Core Docs step (step 2) still reconciles the task spec draft into it, plus `docs/database/`, `docs/api/`, `docs/screens/` as applicable — unchanged in logic, only the draft's location moved.

## Impact on the 8-step lifecycle

1. **Brainstorm** — output path changes to `docs/superpowers/specs/YYYY-MM-DD-task-name.spec.md`
2. **Sync Core Docs** (require) — unchanged logic, reads the draft from its new location
4. **Define Plan** — output path changes to `docs/superpowers/plans/YYYY-MM-DD-task-name.md`
8. **Finish Development** (require) — drops the "archive plan pair to `plans/archive/`" step; nothing to move anymore

## Migration

- Move `plans/working/2026-08-06-user-auth.md` → `docs/superpowers/plans/2026-08-06-user-auth.md`
- Delete `plans/` directory entirely
- Update `README.md` and `CLAUDE.md` to reflect the new structure
