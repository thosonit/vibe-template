# Flutter Architecture

Generic target architecture for a Flutter app starting from a fresh
scaffold (`lib/main.dart` only) — this document defines the structure to
grow into as features land, not a description of what exists today.

## Principles

- Feature-first organization, not layer-first (no top-level `models/`,
  `screens/`, `widgets/` dumping grounds).
- Each feature owns its UI, state, and data access. Shared code lives in
  `core/`.
- Riverpod for state management and dependency injection.
- Immutable state objects; no in-place mutation (see project `CLAUDE.md`).

## Folder Structure

```text
lib/
├── main.dart                  # Entry point, app bootstrap
├── app/
│   ├── app.dart                # MaterialApp / router root widget
│   └── router.dart             # go_router route definitions
├── core/
│   ├── config/                  # Env config (.env loading, AppConfig)
│   │   ├── app_config.dart       # Typed accessor over env values
│   │   └── env.dart               # `String.fromEnvironment` / flutter_dotenv keys
│   ├── di/                       # App-wide provider wiring (Riverpod DI)
│   │   └── providers.dart         # Top-level singletons (Dio client, AppConfig, etc.)
│   ├── theme/                   # Colors, typography, ThemeData
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart         # Light/dark ThemeData assembly
│   ├── widgets/                  # Shared, app-wide widgets
│   │   ├── app_button.dart
│   │   ├── app_loading_indicator.dart
│   │   └── app_error_view.dart
│   ├── network/                  # Shared Dio client + interceptors
│   │   ├── dio_client.dart         # Dio instance assembly, base options
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart
│   │       ├── logging_interceptor.dart
│   │       └── error_interceptor.dart
│   ├── storage/                  # Shared local storage clients
│   │   ├── preferences_store.dart  # Typed wrapper over SharedPreferences
│   │   └── secure_store.dart       # Typed wrapper over FlutterSecureStorage
│   ├── l10n/                     # Localization source strings
│   │   ├── app_en.arb              # Source strings
│   │   └── app_vi.arb              # Translated strings
│   ├── extensions/                # Extension methods on third-party/core types
│   │   ├── build_context_extensions.dart
│   │   ├── date_time_extensions.dart
│   │   └── string_extensions.dart
│   ├── utils/                    # Pure helper functions
│   │   ├── date_utils.dart
│   │   ├── validators.dart
│   │   ├── load_status.dart       # Shared LoadStatus enum (initial/loading/success/failure)
│   │   └── logger.dart            # App-wide logging wrapper
│   └── errors/                   # Failure/exception types
│       ├── failure.dart           # Base `Failure` sealed class
│       └── exceptions.dart        # Thrown exceptions (data, network, storage layers)
└── features/
    ├── shared/                   # Cross-feature code reused by 2+ features
    │   ├── data/
    │   │   ├── datasources/      # Shared datasources (e.g. device_info_datasource.dart)
    │   │   ├── models/           # Shared DTOs (e.g. user_session_model.dart)
    │   │   └── repositories/     # Shared repo impls (e.g. session_repository_impl.dart)
    │   ├── domain/
    │   │   └── repositories/     # Shared repo interfaces (e.g. session_repository.dart)
    │   └── presentation/
    │       ├── viewmodels/       # Shared viewmodels (e.g. user_session_viewmodel.dart)
    │       └── widgets/          # Shared feature widgets (e.g. avatar_widget.dart)
    └── <feature_name>/
        ├── data/
        │   ├── datasources/      # API/local data sources (raw I/O)
        │   ├── models/           # DTOs — `fromJson`/payload (de)serialization
        │   └── repositories/     # `<Feature>RepositoryImpl` implements domain interface
        ├── domain/
        │   └── repositories/     # Abstract `<Feature>Repository` interface
        └── presentation/
            ├── viewmodels/       # Riverpod `Notifier`/`AsyncNotifier` — the MVVM "VM"
            ├── pages/            # Full-page widgets ("V") — watch viewmodel, render only
            └── widgets/          # Feature-local widgets
```

Mirrors `lib/features/` 1:1, same subfolders per feature as needed:

```text
test/
└── features/
    └── <feature_name>/
        ├── data/
        │   └── repositories/     # Repository impl tests, mocking datasources
        ├── domain/               # (rare — interfaces have no logic to test)
        └── presentation/
            └── viewmodels/       # ViewModel tests, mocking repository interface
```

`core/extensions/` holds extension methods on types that aren't ours to
edit (`BuildContext`, `String`, `DateTime`, third-party classes) — kept
separate from `core/utils/` because extensions read as part of the
type's own API (`context.theme`), while `utils/` holds standalone
functions (`formatDate(date)`). One file per extended type once it grows
past a handful of members.

`core/l10n/` holds the `.arb` source files consumed by `flutter gen-l10n`;
`l10n.yaml` lives at the Flutter project root (Flutter convention — it's
discovered there, not under `lib/`) and points `arb-dir` at `lib/core/l10n`.
Generated `AppLocalizations` code is not committed. Pages access strings
via `AppLocalizations.of(context)`, never hardcoded UI strings.

`domain/repositories/` stays even for simple features, since it's what
keeps `data/` swappable and `presentation/` testable. Domain entities are
skipped — `data/models/` (DTOs) double as the types passed up to
`presentation/`, so there's no separate entity layer to map to/from.

`features/shared/` is for code reused by two or more features but tied to
app/business concepts (e.g. user session, account state) — not
generic enough to belong in `core/`. If something is only used by one
feature, it stays inside that feature; promote it to `shared/` only once a
second feature actually needs it (YAGNI).

## Layering: MVVM + Repository (Riverpod)

- **Page** (`presentation/pages/`): a `ConsumerWidget`/`ConsumerStatefulWidget`
  that watches a viewmodel provider and renders state. No business logic,
  no direct data source/repository access.
- **ViewModel** (`presentation/viewmodels/`): a Riverpod `Notifier`/
  `AsyncNotifier` per screen or cohesive UI unit. Holds and mutates UI
  state, calls the repository interface directly, exposes an immutable
  state class. Never imports anything from `data/`.
- **Domain** (`domain/repositories/`): an abstract `Repository` interface
  only — the contract `presentation/` codes against and `data/` implements.
- **Repository impl** (`data/repositories/`): implements the domain
  interface, composes one or more `datasources/`, returns `models/` (DTOs)
  directly. This is the only place that knows about API/local storage
  details.
- Dependency direction is one-way: `presentation` → `domain` ← `data`.
  `data/` and `presentation/` never depend on each other directly.
- Providers return immutable state classes (sealed classes or `freezed`
  data classes once introduced).
- Server/remote state is owned by the repository and exposed through the
  viewmodel — never duplicated into ad-hoc widget state.
- Derive computed values with `Provider`, don't store redundant computed
  state.

### Error handling in presentation

ViewModels expose failures to Pages via `AsyncValue` or a sealed UI state
class — never expose raw `Failure` types or exceptions directly to widgets.

Two patterns are accepted — pick one per screen based on complexity:

**Pattern 1 (preferred) — `AsyncNotifier` + `AsyncValue`**
Best for screens whose primary job is loading and displaying data:
```dart
// ViewModel
class UserProfileViewModel extends AsyncNotifier<UserProfileState> {
  @override
  Future<UserProfileState> build() => _load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load());
  }
}

// Page
ref.watch(userProfileProvider).when(
  data: (s) => UserProfileView(state: s),
  loading: () => const AppLoadingIndicator(),
  error: (e, _) => AppErrorView(failure: e as Failure),
);
```

**Pattern 2 — `LoadStatus` enum + data class**
Use when a screen has multiple independent async actions (e.g. submit, delete,
refresh) each needing their own status, or when `AsyncValue` makes the state
shape awkward:
```dart
// core/utils/load_status.dart — shared across the app
enum LoadStatus { initial, loading, success, failure }

// Feature state carries status + data + failure together
class UserProfileState {
  const UserProfileState({
    this.status = LoadStatus.initial,
    this.profile,
    this.failure,
  });

  final LoadStatus status;
  final UserProfile? profile;
  final Failure? failure;

  bool get isLoading => status == LoadStatus.loading;
  bool get isSuccess => status == LoadStatus.success;
  bool get isFailure => status == LoadStatus.failure;

  UserProfileState copyWith({
    LoadStatus? status,
    UserProfile? profile,
    Failure? failure,
  }) => UserProfileState(
    status: status ?? this.status,
    profile: profile ?? this.profile,
    failure: failure ?? this.failure,
  );
}
```

`LoadStatus` lives in `core/utils/load_status.dart` and is imported by any
feature that needs per-action status tracking. Do not redefine it per feature.

`AppErrorView` (in `core/widgets/`) receives a `Failure` and renders an
appropriate message — do not `switch` on `Failure` subtypes inside pages.

## Dependency Injection

Riverpod providers are the DI mechanism — no separate service locator.

- App-wide singletons (Dio client, `AppConfig`, storage clients) are declared as
  providers in `core/di/providers.dart`.
- Each feature's repository is exposed via its own `Provider` in
  `data/repositories/` (e.g. `userRepositoryProvider`), constructed from
  the shared clients in `core/di/` plus the feature's `datasources/`.
- ViewModels depend on the repository **provider**, not a concrete class —
  swap implementations in tests with `ProviderScope(overrides: [...])`.
- Never instantiate a repository or data source with `MyClass()` directly
  inside a viewmodel or widget; always go through a provider.

## Network (Dio + Retrofit)

- `core/network/` holds the shared `Dio` instance and its interceptors —
  every feature's Retrofit API client is built from this single instance,
  never a fresh `Dio()`.

  ```text
  core/network/
  ├── dio_client.dart          # Dio instance assembly, base options
  └── interceptors/
      ├── auth_interceptor.dart    # Attaches auth/session headers
      ├── logging_interceptor.dart # Request/response logging (debug only)
      └── error_interceptor.dart   # Maps DioException → core/errors Failure
  ```

- Each feature defines a `retrofit`-generated API client in
  `data/datasources/` (e.g. `user_api_client.dart` with a paired
  `user_api_client.g.dart`), annotated with `@RestApi()` and one method per
  endpoint. The remote `datasources/` class wraps this generated client —
  `repositories/` never call the generated client directly.
- `dioProvider` in `core/di/providers.dart` builds the `Dio` instance once,
  with `baseUrl`/timeouts from `AppConfig` and the interceptor list attached
  in order: `auth` → `logging` → `error`; each feature's
  `<feature>ApiClientProvider` constructs its Retrofit client from
  `dioProvider`, not a new `Dio()`.
- Interceptor responsibilities stay narrow and single-purpose — one concern
  per interceptor, composed via `dio.interceptors.addAll([...])`, not one
  monolithic interceptor handling auth + logging + retry.
- `error_interceptor.dart` converts transport-level failures
  (`DioException.type`, status codes) into the app's `Failure` sealed types
  from `core/errors/failure.dart`, so `data/repositories/` only ever throws
  or returns `Failure`, never raw `DioException`.
- `logging_interceptor.dart` is only attached when `AppConfig.isDebug` is
  true — never log request/response bodies in release builds (may contain
  tokens or PII).
- Retry/backoff (if needed) is a dedicated interceptor
  (`retry_interceptor.dart`), not bolted onto `error_interceptor.dart`.
  Add it only when the feature needs it; a common choice is `dio_smart_retry`.
  When added, include it in the interceptor tree under `core/network/interceptors/`.

## Local Storage

Two distinct clients for two distinct purposes — never use one for the
other's job.

- `core/storage/preferences_store.dart` wraps `shared_preferences` for
  non-sensitive data: feature flags, UI preferences, onboarding flags,
  cached IDs. Exposed as `preferencesStoreProvider` in `core/di/providers.dart`.
- `core/storage/secure_store.dart` wraps `flutter_secure_storage` for
  sensitive data: auth tokens, refresh tokens, credentials, anything that
  must survive only on-device and encrypted. Exposed as
  `secureStoreProvider`.
- Both expose a typed API per key (e.g. `getOnboardingComplete()`,
  `setAuthToken(String)`) — no raw string-key access (`prefs.getString('x')`)
  outside these two files, same rule as `AppConfig` for env vars.
- `auth_interceptor.dart` reads the auth token through `secureStoreProvider`,
  never through `preferences_store`.
- Feature-local persistence (e.g. a single feature caching its own draft
  state) goes through the feature's own `datasources/`, which inject
  `preferencesStoreProvider`/`secureStoreProvider` rather than the raw
  plugin — keeps `data/repositories/` swappable and testable, same as the
  network client.
- Never store tokens, passwords, or PII in `shared_preferences` — it is
  unencrypted plain storage on most platforms.

## Configuration (.env)

- Environment values (API base URLs, feature flags) live
  in `.env` files at the Flutter project root, loaded via
  `flutter_dotenv`: `.env.dev`, `.env.staging`, `.env.prod`.
- `.env*` files are gitignored; commit a `.env.example` with placeholder
  keys so the required variables are documented.
- `core/config/env.dart` defines the env key constants; `core/config/app_config.dart`
  exposes a typed `AppConfig` (no raw `dotenv.env['KEY']` access outside this
  file) — read once at startup in `main.dart` before `runApp`.
- Never hardcode secrets or per-environment URLs in feature code — always go
  through `AppConfig` (see global security rules).

## Navigation

- `go_router`, declared centrally in `app/router.dart`.
- Route paths and names as constants, not magic strings scattered across
  features.
- Use `ShellRoute` for persistent shell UI (bottom nav, side drawer) wrapping
  nested routes. Each shell branch is its own `StatefulShellBranch` so branch
  state is preserved on tab switch.
- Deep links are declared on the same route entries — `go_router` handles
  them automatically when `router.dart` is the single source of truth for
  all paths.

## Naming

- Files: `snake_case.dart`
- Classes/widgets: `PascalCase`
- Providers: `camelCase` ending in `Provider` (e.g. `userSessionProvider`)
- Notifiers/ViewModels: `PascalCase` ending in `ViewModel` (e.g.
  `UserProfileViewModel`)
- Repository interfaces: `PascalCase` ending in `Repository`
  (e.g. `UserRepository`); implementations end in `RepositoryImpl`
- Pages: `PascalCase` ending in `Page` or `Screen` (e.g. `UserProfilePage`)
- `core/` clients: `<name>_client.dart` for outbound I/O (e.g.
  `dio_client.dart`), `<name>_store.dart` for local persistence (e.g.
  `preferences_store.dart`, `secure_store.dart`) — both expose a single
  `camelCase` provider ending in `Provider` (e.g. `dioClientProvider`,
  `secureStoreProvider`).
- Interceptors: `<concern>_interceptor.dart` (e.g. `auth_interceptor.dart`),
  one concern per file.
- Datasources: `<feature>_<source>_datasource.dart` (e.g.
  `user_remote_datasource.dart`, `user_local_datasource.dart`).
- DTOs/models: `<name>_model.dart`, class name ends in `Model` or `Dto`
  consistently within a feature (pick one suffix per project, don't mix).
- Failures/exceptions: failure subclasses end in `Failure`
  (e.g. `NetworkFailure`); exception classes end in `Exception`.
- Extensions: `<type>_extensions.dart`, extension name `<Type>X`
  (e.g. `BuildContextX`, `StringX` in `build_context_extensions.dart`).

## Testing

- Unit tests for `presentation/viewmodels` and `core/utils`.
- Widget tests for `presentation/pages` and `presentation/widgets`.
- Integration/E2E tests live in `integration_test/` at the Flutter project
  root (Flutter-idiomatic location). Mirror critical feature flows — login,
  core user journeys, any flow that crosses multiple layers end-to-end.
  **Do not add `integration_test/` by default** — introduce it only when a
  critical user flow actually needs end-to-end coverage (YAGNI).
- Mock repository interfaces (`domain/repositories`) when testing
  viewmodels; mock data sources when testing repository implementations.
  Use `mocktail` for all mocking — no manual stub classes.
  Never hit real network/hardware in tests.
- Follow the 80% coverage and AAA test structure from the global testing
  rules.

## Adding a New Feature

1. Create `lib/features/<feature_name>/` with the subfolders above (only the
   ones actually needed).
2. Define the repository interface in `domain/repositories/`.
3. Implement the repository in `data/`, backed by a datasource.
4. Define state and behavior in `presentation/viewmodels/` before writing UI.
5. Build the page in `presentation/pages/`, wire it into `app/router.dart`.
6. Add tests alongside the feature in `test/features/<feature_name>/`.

## Dependencies to Introduce

Not yet in `pubspec.yaml` — add when the corresponding feature needs them:

| Package | Purpose |
|---|---|
| `flutter_riverpod` | State management / DI |
| `riverpod_annotation` + `riverpod_generator` | `@riverpod` codegen for `Notifier`/`AsyncNotifier` (Riverpod 2.x) |
| `go_router` | Navigation, `ShellRoute`, deep links |
| `dio` | HTTP client, used by `core/network/dio_client.dart` |
| `retrofit` + `retrofit_generator` | Typed REST API clients (codegen) on top of `dio` |
| `freezed` + `json_serializable` | Immutable models, codegen |
| `build_runner` | Codegen runner for `freezed` / `json_serializable` / `retrofit` / `riverpod_generator` |
| `flutter_dotenv` | `.env` loading for `core/config/` |
| `shared_preferences` | Non-sensitive local key-value storage |
| `flutter_secure_storage` | Encrypted storage for tokens/credentials |
| `flutter_localizations` (SDK) + `intl` | Localization, used by `core/l10n/` |
| `mocktail` | Mocking in unit/widget tests — no generated mocks needed |

## Common Commands

Codegen and structure-specific commands not covered by the general Flutter
commands in `CLAUDE.md`:

```bash
# Generate freezed/json_serializable/retrofit code (run after editing
# any *.dart file with @freezed, @JsonSerializable, or @RestApi)
dart run build_runner build --delete-conflicting-outputs

# Watch mode while actively editing models/datasources
dart run build_runner watch --delete-conflicting-outputs

# Regenerate AppLocalizations from core/l10n/*.arb
flutter gen-l10n

# Sort/format imports + apply lint fixes
dart fix --apply
```
