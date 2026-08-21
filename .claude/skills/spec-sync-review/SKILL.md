---
name: spec-sync-review
description: Use when running the Sync Core Docs step (reconciling a task spec draft into docs/specs, docs/database, docs/api, docs/screens) or when reviewing/auditing any spec, screen spec, or overview index file for format compliance, missing sections, missing viewpoints, or cross-doc inconsistencies before a spec is marked Approved.
---

# Spec Sync & Review

## Overview

Two jobs, same checklist underneath:

1. **Sync** — reconcile a task spec draft (`docs/superpowers/specs/YYYY-MM-DD-*.spec.md`) into the project's core docs (step 2, "Sync Core Docs", in CLAUDE.md's Develop Instructions).
2. **Review** — audit one or more existing core specs / screen specs / index files against a fixed structure, and flag inconsistencies between them.

Both jobs fail the same way if done from memory: a section gets skipped, an index entry goes stale, or two specs quietly disagree about the same behavior. Use the templates below as a literal checklist, not a vibe check — tick every row against the actual file, don't eyeball it.

## When to Use

- Right after `superpowers:brainstorming` produces a task spec draft, before `superpowers:writing-plans`.
- When asked to "review this spec", "check the specs are consistent", or before flipping a spec's status to `Approved`.
- NOT for writing the *first* draft of a feature's behavior (that's brainstorming) — this skill reconciles and audits, it doesn't invent requirements.

## Required Structure Per Doc Type

Treat missing rows as findings, not stylistic choices.

**Core spec** (`docs/specs/CODE-feature-name.spec.md`):

| Section | Required | Notes |
|---|---|---|
| `# Spec CODE: Title` | yes | matches the index entry's title |
| Summary | yes | 1-3 sentences |
| Scope — In scope / Out of scope | yes | out-of-scope items that point at another feature MUST link that feature's spec file once it exists |
| Actors | yes | who initiates/receives this behavior, and their preconditions |
| Requirements | yes | one subsection per flow/state machine step; numbered steps for sequential logic |
| Error Handling | if the feature has failure paths | every error a user can see, and its exact user-facing wording if specified elsewhere |
| Security Notes | if the feature touches auth, secrets, or PII | |
| Open Questions / Follow-ups | yes | anything deferred to implementation — never silently drop an unresolved point |

**Screen spec** (`docs/screens/FEATURE-CODE-screen-name-00.screen.md`), numbered sections are fixed order:

1. Related Spec (link to the core spec)
2. Prototype (link to the paired `.html`)
3. Summary
4. Layout
5. Elements (table)
6. States — Default, Loading, Success, and **one entry per error path listed in the core spec's Error Handling** — a screen spec with fewer error states than its core spec is missing a viewpoint
7. Validation Rules (client-side)
8. Accessibility
9. Responsive Behavior
10. Open Questions

**Overview index** (`docs/specs/01_spec.md`, `docs/screens/01_screen.md`): one entry per file in that folder, each with Status + link + one-line overview. An entry with no matching file, or a file with no matching entry, is a finding.

## Sync Procedure

1. Read the task spec draft in full — extract every discrete decision/requirement, not just the headline one.
2. Find every existing core doc the draft touches: the feature's own spec (new or existing), any spec whose Scope this draft narrows/extends (search other specs' Out-of-scope bullets for a forward reference to this feature), `docs/database/db.md`, `docs/api/api.md` + `docs/api/endpoints/*.md`, and any affected `docs/screens/*.screen.md`.
3. Write/update the core spec using the template above. Every requirement in the draft must land in some section — if a requirement doesn't fit a required section, that's a sign a section is missing, not a reason to drop the requirement.
4. Cross-link both directions: the new/updated spec's Out-of-scope references the specs it depends on or defers to; those other specs' Out-of-scope bullets should point back if they mention this feature.
5. Update the relevant overview index file(s) — new entry, or corrected Status/overview line for an edited entry.
6. Resolve conflicts explicitly in the spec text (e.g. two specs defining the same counter/token-revocation mechanism differently) — never leave two specs silently describing the same behavior two different ways.
7. Anything the draft left ambiguous goes in Open Questions, not a guess baked in as fact.

## Review Checklist

Run in this order — later checks assume earlier ones passed:

1. **Format** — every required section from the template above is present, in the template's order, under the exact heading level shown in an existing approved doc of the same type.
2. **Internal completeness** — for a core spec: does every Requirements flow have a matching Error Handling entry for its failure branches? For a screen spec: does every core-spec error path have a matching States entry, and does every Elements row map to something in Layout?
3. **Cross-doc consistency** — pick the terms/mechanisms this doc shares with others (tokens, counters, statuses, actor names) and confirm the *same* wording and behavior is used across all of them, not just no contradiction.
4. **Links** — every relative link (`[...](../specs/X.spec.md)`, `[...](./Y.screen.md)`) resolves to a file that exists.
5. **Index sync** — the overview index's Status and one-line overview still match the file's actual content and its own Status marker (if the doc has no explicit status marker, don't invent one — flag it as missing).
6. **Missing viewpoints** — scan for the categories in the table below; absence of a category isn't automatically wrong, but an unaddressed one must show up as a finding or an explicit Open Question, not silence.

| Viewpoint | Where it usually hides if missing |
|---|---|
| Actors / preconditions | Requirements assume a logged-in or verified user without saying so |
| Error / failure paths | Only the happy path is written out |
| Security (secrets, PII, token handling) | Auth/payment/user-data specs with no Security Notes section |
| Accessibility | Screen specs with States/Elements but no Accessibility section |
| Responsive / breakpoints | Screen specs with no Responsive Behavior section |
| Rate limiting / abuse | Any user-triggered write endpoint (login, reset, signup) |
| Cross-feature interaction | A new spec that touches an existing counter/flag (lockout, verification) without saying what happens to it |

Report findings as: file, section (or "missing section"), the specific gap, and — for cross-doc issues — the other file it conflicts or fails to align with. Don't just say "looks fine"; if a doc has zero findings after all six checks, say which checks were run.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Reviewing a spec in isolation, missing that another spec's Out-of-scope bullet contradicts it | Grep other specs for the feature name/code before finishing review |
| Adding a new spec but leaving the index file un-updated | Step 5 of Sync Procedure is not optional |
| Screen spec has fewer error States than the core spec's Error Handling list | Check §6 against the core spec's Error Handling before approving |
| Treating an ambiguous draft point as settled instead of an Open Question | Only write it as fact if the draft or an existing approved spec actually said so |
| Approving a spec whose Security Notes section is just missing (not empty-on-purpose) | Any spec touching auth/PII/payments gets a Security Notes section or an explicit "N/A because..." |
