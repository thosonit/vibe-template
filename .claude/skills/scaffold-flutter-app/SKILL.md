---
name: scaffold-flutter-app
description: "Scaffold a brand-new Flutter app codebase into a source directory (default src/), brainstorming and generating a FLUTTER_ARCHITECTURE.md with the user first, then — once the user confirms the architecture — generating the project skeleton plus the first feature the user describes. Use when the user wants to bootstrap a new Flutter project, create a fresh app codebase, or set up the initial architecture/folder structure for a Flutter app."
---

# scaffold-flutter-app

Bootstrap a brand-new Flutter app: brainstorm and confirm an architecture
doc with the user, then generate the codebase (skeleton + one starter
feature) from that confirmed doc.

This skill is for **new** apps / fresh scaffolds, and is **self-contained**:
it bundles its own reference architecture at
`scaffold-flutter-app/templates/FLUTTER_ARCHITECTURE.template.md`, plus a
ready-to-copy Dart codebase at `scaffold-flutter-app/templates/dart/` (see
"Bundled Dart Templates" below) — it does not depend on a
`docs/architectures/FLUTTER_ARCHITECTURE.md` existing anywhere, nor on
writing every file from scratch each run. It is not for adding a feature
to an already-architected app — for that, just follow that project's own
architecture doc directly.

## Bundled Dart Templates

`scaffold-flutter-app/templates/dart/` mirrors the `lib/` tree from the
architecture template, with every file pre-written and working end to end
for a **sign-in** feature (the assumed first feature for these templates).
Layout:

```text
templates/dart/
├── root/                          # files that belong at the Flutter project root
│   ├── .env.example.tpl
│   └── l10n.yaml.tpl
└── lib/
    ├── main.dart.tpl
    ├── app/
    │   ├── app.dart.tpl
    │   └── router.dart.tpl         # go_router wired to /sign-in as initial route
    ├── core/
    │   ├── config/{env,app_config}.dart.tpl
    │   ├── di/providers.dart.tpl   # appConfig/sharedPreferences/secureStore/dio providers
    │   ├── theme/{app_colors,app_text_styles,app_theme}.dart.tpl
    │   ├── widgets/{app_button,app_loading_indicator,app_error_view}.dart.tpl
    │   ├── network/dio_client.dart.tpl + interceptors/{auth,logging,error}_interceptor.dart.tpl
    │   ├── storage/{preferences_store,secure_store}.dart.tpl
    │   ├── l10n/{app_en,app_vi}.arb.tpl  # sign-in strings
    │   ├── extensions/build_context_extensions.dart.tpl
    │   ├── utils/{load_status,validators,logger}.dart.tpl
    │   └── errors/{failure,exceptions}.dart.tpl
    └── features/sign_in/
        ├── data/
        │   ├── datasources/sign_in_remote_datasource.dart.tpl
        │   ├── models/sign_in_session_model.dart.tpl
        │   └── repositories/sign_in_repository_impl.dart.tpl
        ├── domain/repositories/sign_in_repository.dart.tpl
        └── presentation/
            ├── viewmodels/{sign_in_state,sign_in_viewmodel}.dart.tpl  # Pattern 2 (LoadStatus)
            ├── pages/sign_in_page.dart.tpl
            └── widgets/sign_in_form.dart.tpl
```

These are **copy-and-adapt** templates, not blind stamp-outs:

- `.tpl` files use the literal placeholder `{{project_name}}` (currently
  only in `app.dart.tpl`'s `MaterialApp.title`) — replace it with the
  confirmed project name when copying.
- Strip `.tpl` off every filename on copy (e.g. `env.dart.tpl` →
  `env.dart`); `root/*.tpl` go to the Flutter project root, everything
  under `lib/` keeps its relative path under the new project's `lib/`.
- Only copy a template file into the new project if the confirmed
  `FLUTTER_ARCHITECTURE.md` actually calls for that piece (e.g. skip
  `l10n/*.arb` entirely if the user said no localization in Step 2; skip
  `secure_store.dart`/auth interceptor wiring if there's no auth yet).
- If the user's confirmed architecture differs from a template's
  assumption (different state mgmt, different error pattern, different
  feature name instead of sign-in), **edit the copied file** to match —
  the template is a starting point, the confirmed architecture doc is the
  source of truth.
- These templates use hand-written DTOs/exceptions (no `freezed`/
  `retrofit` codegen) so the scaffold builds immediately without running
  `build_runner` first. If the confirmed architecture uses `freezed` +
  `retrofit`, convert the copied `sign_in_session_model.dart` and
  `sign_in_remote_datasource.dart` to the codegen-annotated versions as
  part of Step 5, then run the codegen command.

## Role & Mindset

Act as an experienced Mobile developer with deep, hands-on expertise in the
Flutter framework, setting up a new project for a team. Bring practical,
opinionated judgment from real-world Flutter delivery — state management,
project structure, build/release, performance, and platform pitfalls — and
explain trade-offs in those terms.

- **Always ask to gather the most information possible, and whenever you hit
  any doubt or ambiguity, stop and ask rather than assuming.** Prefer one
  more clarifying question over a wrong guess. Surface uncertainties
  explicitly and confirm your understanding with the user before acting on
  it.
- Do not guess project name, package id, or architecture choices — ask.
- Do not generate any code until the user has explicitly confirmed the
  architecture document.
- Keep questions focused, one topic at a time, and summarize understanding
  back to the user before moving to the next step.
- Read the bundled
  `scaffold-flutter-app/templates/FLUTTER_ARCHITECTURE.template.md` first —
  it is the **default template** for brainstorming (principles, folder
  structure, layering, DI, network, storage, navigation, naming, testing,
  dependencies, commands). Adapt it to the user's answers rather than
  starting from a blank page, unless the user wants something materially
  different. If the current repo also happens to have its own
  `docs/architectures/FLUTTER_ARCHITECTURE.md`, treat the bundled template
  as authoritative for this skill — don't depend on the repo file being
  present.

## Step 1: Ask Where and What

Ask the user (can be combined into one round of questions):

1. **Target source directory** — default `src/` if not specified. The app
   code will live at `<target_dir>/<project_name>/`.
2. **Project name** — used for the Flutter project directory and as a
   human-readable app name.
3. **Package / application ID** — reverse-domain identifier
   (e.g. `com.company.appname`) used for `--org` in `flutter create`.
4. **Platforms** — which platforms to target (ios, android, web, etc.) if
   not the Flutter default.
5. Confirm the directory doesn't already exist before proceeding; if it
   does, stop and ask the user how to proceed (do not overwrite silently).

## Step 2: Brainstorm the Architecture

Read `scaffold-flutter-app/templates/FLUTTER_ARCHITECTURE.template.md`
(bundled with this skill) before asking anything — it is the source of
defaults for every topic below. Work through these with the user to
produce the new project's `FLUTTER_ARCHITECTURE.md`. For each topic,
propose the bundled template's default and ask the user to confirm or
override:

- **State management / DI** — Riverpod (default), Bloc, Provider, etc.
- **Folder organization** — feature-first (default, matching the reference
  doc) vs layer-first.
- **Networking** — Dio + Retrofit (default) vs alternatives; REST vs
  GraphQL.
- **Local storage** — split between non-sensitive (`shared_preferences`)
  and sensitive (`flutter_secure_storage`), or a single solution.
- **Navigation** — `go_router` (default) vs alternatives.
- **Models/codegen** — `freezed` + `json_serializable` (default) vs plain
  classes.
- **Localization** — needed? Which locales?
- **Error handling pattern** — sealed `Failure` types + `AsyncValue`
  (default), or the `LoadStatus` enum pattern, or both (let the user pick
  per-screen as in the reference doc).
- **Environment configuration** — `.env` via `flutter_dotenv` (default) vs
  `--dart-define`.
- **Testing strategy** — **always explicitly confirm with the user**:
  - Which test types to set up now: unit, widget, integration/E2E, golden.
  - Target coverage percentage (repo default is 80% — confirm or override).
  - Mocking library (`mocktail` default).
  - **Do not scaffold `integration_test/` or write any tests by default** —
    only generate test setup/files the user explicitly asks for in this
    step. Note this restriction directly in the generated
    `FLUTTER_ARCHITECTURE.md` Testing section so it's not silently
    reintroduced later.

Generate `<target_dir>/<project_name>/docs/architectures/FLUTTER_ARCHITECTURE.md`
(or the path the user prefers) by copying the structure and level of detail
of the bundled
`scaffold-flutter-app/templates/FLUTTER_ARCHITECTURE.template.md` —
same section set (Principles, Folder Structure, Layering, Dependency
Injection, Network, Local Storage, Configuration, Navigation, Naming,
Testing, Adding a New Feature, Dependencies to Introduce, Common Commands)
— with every choice replaced by what the user actually confirmed in this
step, not left as the template's defaults.

**Stop here and present the generated file to the user for review.**

## Step 3: Wait for Confirmation

Do not proceed to Step 4 until the user explicitly confirms the
architecture document (e.g. "looks good", "confirmed", "go ahead"). If the
user requests changes, edit the doc and ask again.

## Step 4: Ask About the First Feature

Once the architecture is confirmed, ask the user to describe the first
feature to scaffold (name, purpose, screens, data needs). This is the
feature the generated codebase will demonstrate the architecture with —
do not invent one.

- If the user's first feature **is sign-in** (or close to it), the bundled
  `templates/dart/lib/features/sign_in/` is a working starting point —
  confirm the field set (email/password vs other identifiers) and adjust
  the copied `SignInForm`/`SignInSessionModel`/`SignInRepository` to match
  before treating Step 5 as done.
- If the first feature is something **else**, still copy the `core/`,
  `app/`, and `root/` templates in Step 5 (they aren't sign-in-specific
  except for `router.dart.tpl`'s initial route and the l10n sign-in
  strings), but build the feature folder for the user's actual feature
  from scratch following the architecture doc's `Folder Structure` and
  `Layering` sections — don't force-fit the sign-in feature templates onto
  an unrelated feature.

## Step 5: Generate the Codebase

1. Run `flutter create` in the target directory with the confirmed
   project name, org/package id, and platforms:
   ```bash
   flutter create --org <reverse-domain-org> --project-name <project_name> <target_dir>/<project_name>
   ```
2. Copy the relevant files from `scaffold-flutter-app/templates/dart/`
   (see "Bundled Dart Templates" above) into the new project, stripping
   `.tpl` and substituting `{{project_name}}`, instead of writing the
   `core/`/`app/` plumbing from scratch — only skip a template file if the
   confirmed architecture doc doesn't call for that piece. Build out any
   remaining folder/file named in the confirmed `FLUTTER_ARCHITECTURE.md`
   `Folder Structure` section that isn't covered by a template (e.g. a
   non-sign-in first feature) — do not create folders the architecture
   doc doesn't call for (YAGNI), and do not create test files unless the
   user asked for them in Step 2.
3. Review every copied file against the doc's `Layering`,
   `Dependency Injection`, `Network`, `Local Storage`, `Configuration`, and
   `Navigation` sections and adjust where the confirmed architecture
   diverges from the template's defaults (e.g. `core/di/providers.dart`,
   `app/router.dart`, the feature's `domain/repositories/`, `data/`,
   `presentation/`).
4. Add the dependencies listed in the doc's `Dependencies to Introduce`
   table to `pubspec.yaml` — only the ones actually used by the app shell
   and the first feature, not the entire table speculatively. They must go
   under the existing `dependencies:` key (created by `flutter create`),
   not appended to the end of the file (that lands under `flutter:` and
   breaks parsing).
5. If `root/l10n.yaml.tpl` was copied (localization in scope), also copy
   `root/.env.example.tpl` → `.env.example`, create a matching local `.env`
   for development, and set `flutter: generate: true` under the `flutter:`
   key in `pubspec.yaml` plus add `flutter_localizations` (SDK) + `intl` to
   `dependencies:` — `gen-l10n`/the build fail without `generate: true` even
   if no widget references `AppLocalizations` yet.
6. Run `flutter pub get`, and the codegen command from `Common Commands` if
   the architecture uses `freezed`/`json_serializable`/`retrofit`/
   `riverpod_generator`.
7. Run `flutter analyze` and fix any errors before finishing. Verified by
   building this skill's bundled templates end-to-end (`flutter analyze`
   clean, `flutter build ios --simulator` succeeded) — if a copied template
   file is edited, re-run `flutter analyze` to catch regressions.

## Step 6: Generate README

Create `<target_dir>/<project_name>/README.md` summarizing the project per
the confirmed `FLUTTER_ARCHITECTURE.md`:

- Project name and one-line description (from the user's answers).
- Link to / summary of the architecture doc (principles, folder structure
  at a glance, state management, navigation, networking, storage).
- How to run/test/build (mirror `CLAUDE.md`-style commands for the new
  project: `flutter run`, `flutter test`, `flutter analyze`, `flutter build`).
- The first feature that was scaffolded.
- A clear note: **"Generated by AI"** — state plainly that the initial
  codebase and architecture doc were generated by an AI agent (Claude
  Code) from a confirmed architecture document, and should be reviewed
  like any other contribution.

## Step 7: Summary

Print a summary of what was created:

```
| Item                  | Path                                              |
|------------------------|---------------------------------------------------|
| Architecture doc       | <target_dir>/<project_name>/docs/architectures/...|
| Project root           | <target_dir>/<project_name>/                      |
| First feature          | lib/features/<feature_name>/                      |
| README                 | <target_dir>/<project_name>/README.md             |
```

Remind the user that no tests were generated unless explicitly requested,
per the confirmed Testing section.

## Notes

- Never run destructive commands (`rm -rf`, overwriting an existing
  project directory) without explicit confirmation.
- The bundled `templates/FLUTTER_ARCHITECTURE.template.md` is the
  structural reference for every run of this skill, regardless of whether
  the current repo happens to have its own architecture doc. The generated
  doc is for the **new** project and must reflect that project's actual
  confirmed choices, not be a blind copy of the template.
- Follow this repo's `git-conventions` skill if the user asks to commit
  the new codebase.
