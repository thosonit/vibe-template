---
name: init-project
description: "Confirms the target system/application for a brand-new project cloned from this multi-stack vibe-coding template, adjusts docs/architecture/ and CLAUDE.md to match the confirmed stack, and hands off to the normal Develop Instructions (brainstorm -> spec -> code). Use this automatically the first time real work starts in a freshly cloned copy of this template - e.g. src/ has no real project folders yet and/or CLAUDE.md has no \"## Project\" section - and also whenever the user explicitly asks to start a new project, initialize/bootstrap this template, or set up the app/system. Trigger this before writing any spec, architecture doc, or code for a new project, even if the user jumps straight into describing a feature - confirm the system and stack first."
---

# init-project

This template ships with no project identity baked in: `docs/architecture/`
holds generic reference architectures (`NEXT_ARCHITECTURE.md`,
`FLUTTER_ARCHITECTURE.md`), and `docs/specs/`, `docs/screens/`,
`docs/database/`, `docs/api/` hold a single worked example feature
(`AUTH-user-auth`) that demonstrates the workflow end to end. Before any real
spec/architecture/code work starts on a newly cloned project, this skill
confirms what's actually being built and makes the template's shared docs
reflect that — so later steps (`superpowers:brainstorming` and the rest of
`CLAUDE.md`'s Develop Instructions) build on the right assumptions instead of
inheriting the template's example content by accident.

This skill assumes the user has already cloned or created the new repo from
this template and is running Claude Code inside it. **Never run `git clone`**
as part of this skill.

## Step 0: Guard check — is this actually a fresh project?

Before asking anything, check whether this project has already been
initialized:

- Does `src/` contain any real project folders (anything beyond an empty
  placeholder)?
- Does `CLAUDE.md` already have a `## Project` section?

If either is true, **stop and ask the user** how they want to proceed (e.g.
"this looks already initialized — do you want to re-confirm the project
setup, or were you about to do something else?") instead of silently
re-running the steps below or overwriting what's there.

## Step 1: Confirm the project, one topic at a time

Ask these as separate questions, in order, waiting for an answer before
moving to the next (mirror the tone of `.claude/skills/scaffold-flutter-app/SKILL.md`
— propose sensible defaults from what's already in the repo, but never guess
the project name or stack outright):

1. **Project name + domain/purpose** — a short name and a one-line
   description of what the system does (e.g. "an e-commerce admin panel", "a
   B2B invoicing platform").
2. **Sub-projects and stacks** — which sub-projects are needed under `src/`
   (web, mobile, backend, other) and the stack for each. A project can need
   just one, or several.
3. **Architecture reference per stack** — for each confirmed stack, is there
   already a matching doc in `docs/architecture/`? Today that's
   `NEXT_ARCHITECTURE.md` (Next.js) and `FLUTTER_ARCHITECTURE.md` (Flutter).
   Confirm with the user whether each maps to an existing doc or needs a new
   one (see Step 2).

Keep summarizing your understanding back to the user before moving to Step 2
— getting this wrong is expensive because everything downstream (architecture
docs, CLAUDE.md, every future spec) inherits it.

## Step 2: Reuse or create the architecture docs

The existing `NEXT_ARCHITECTURE.md` and `FLUTTER_ARCHITECTURE.md` are
generic, reusable references with no project-specific content baked in —
they describe *how to structure* a Next.js or Flutter codebase, not anything
about this particular project. So when a confirmed stack matches one of
these:

- **Just confirm reuse as-is.** Do not edit or regenerate the file — there's
  nothing project-specific in it to change.

When a confirmed stack has **no existing doc** (e.g. a backend framework like
NestJS, Go, Django, or anything else not already covered):

- Run a short, one-topic-at-a-time brainstorm with the user covering
  whatever's relevant to that stack — folder structure, layering, dependency
  injection, data access, error handling, configuration, testing strategy,
  and so on. Use `NEXT_ARCHITECTURE.md`/`FLUTTER_ARCHITECTURE.md` as the bar
  for section structure and depth, not their specific content.
- Write the result to `docs/architecture/<STACK>_ARCHITECTURE.md` (e.g.
  `NESTJS_ARCHITECTURE.md`), matching the naming pattern of the existing
  docs.
- Stop and get explicit confirmation on the generated doc before moving on,
  the same way `scaffold-flutter-app` waits for architecture confirmation
  before generating code.

## Step 3: Update CLAUDE.md to name this project

Edit the repo's `CLAUDE.md`:

- Insert a new `## Project` section immediately after the intro paragraph
  and before `## Structure`, containing:
  - The confirmed project name and one-line domain description.
  - A table mapping each sub-project to its path, stack, and architecture
    doc, e.g.:

    | Sub-project | Path | Stack | Architecture doc |
    |---|---|---|---|
    | Web | `src/web/` | Next.js | `docs/architecture/NEXT_ARCHITECTURE.md` |
    | Mobile | `src/mobile/` | Flutter | `docs/architecture/FLUTTER_ARCHITECTURE.md` |

- In the `## Structure` code fence, update the `src/` line's inline comment
  to name the actual confirmed sub-project folders/stacks instead of the
  generic `<project-name>` placeholder text.
- **Do not touch** `## Develop Instructions`, `## Rules`, or
  `### Naming Convention` — those sections are already stack-agnostic and
  apply unchanged regardless of what's being built.

## Step 4: Leave the existing example docs alone

Do not touch `docs/specs/`, `docs/screens/`, `docs/database/`, or
`docs/api/`. The `AUTH-user-auth` spec, screen, schema, and endpoint docs
already there are a worked reference example showing what a finished spec /
screen / db note / API doc looks like under this template's conventions —
they are not a real feature of the new project and must not be deleted,
renamed, or mistaken for one.

## Step 5: Summarize and hand off

Close with a short summary covering:

- The confirmed project name and domain.
- The sub-project / stack / architecture-doc table from Step 3.
- An explicit note that `AUTH-user-auth` across `docs/specs/`,
  `docs/screens/`, `docs/database/`, and `docs/api/` is a reference example
  only, not a real feature of this project.
- Next step: use `superpowers:brainstorming` to start the first real feature,
  per Step 1 (Brainstorm) of `CLAUDE.md`'s Develop Instructions.
