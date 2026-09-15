# Copilot Instructions — fold_pokedex

Flutter app targeting phones, tablets, and foldables (Pixel Fold, Galaxy Fold, Surface Duo). Follow these guidelines for all code in this repo.

## 1. Clean Architecture

Structure code in layers and keep them isolated — UI never talks to Data directly.

```text
lib/
├── data/          # Services (API/local clients) + Repository implementations
├── domain/        # Domain models, repository interfaces, use cases (when logic is non-trivial)
└── ui/
    ├── core/      # Shared widgets, theme, typography
    └── features/
        └── <feature>/
            ├── view_models/
            └── views/
```

- Views are lean: only layout/animation logic, no business logic.
- ViewModels hold UI state (`ChangeNotifier`/`Cubit`/`Bloc`) and receive Repositories via constructor injection.
- Repositories are the single source of truth; Services only wrap external APIs.
- See the `flutter-apply-architecture-best-practices` skill under [.github/skills](skills) for the full workflow when adding a feature.

## 2. Best Practices & Clean Code

- Prefer immutable models (`final` fields, `const` constructors, `copyWith`).
- Keep widgets small and single-purpose; extract sub-widgets instead of deeply nesting.
- No business logic in `build()` methods.
- Use `equatable` for value equality on models/states already in this project.
- Write doc comments for public members (enforced by `analysis_options.yaml` / `very_good_analysis`).
- Run `dart format`, `flutter analyze --fatal-infos --fatal-warnings`, and `flutter test --coverage` before pushing (mirrors [.githooks/pre-push](../.githooks/pre-push) and [.github/workflows/ci.yml](workflows/ci.yml)).

## 3. Modern Dart 3 Syntax

Favor current Dart 3.x features over legacy patterns:

- **Class modifiers**: `sealed`/`final`/`base`/`interface` classes for domain models and exhaustive state unions (e.g. `sealed class PokemonState`).
- **Pattern matching**: `switch` expressions, destructuring, and `is`/record patterns instead of chains of `if`/`is` checks (see `dart-use-pattern-matching` skill).
- **Records** for lightweight multi-value returns instead of ad-hoc classes or tuples-via-list.
- **Primary constructors / `super.field`** shorthand instead of verbose constructor bodies (see `dart-use-primary-constructors` skill).
- Prefer `final`/`const` locals, avoid raw/dynamic types (`strict-casts`, `strict-raw-types` are enabled).

## 4. Adaptive UI for Foldables

This is the highest priority for anything touching `lib/ui/`.

- **Never branch on device type or orientation.** Do not use `Theme.of(context).platform`, `Platform.isAndroid`, or `OrientationBuilder` to decide layout.
- **Base all layout decisions on available space**: use `LayoutBuilder` + `constraints.maxWidth`, or `MediaQuery.sizeOf(context)` for window size.
- Use `MediaQuery.of(context).displayFeatures` / the `flutter` foldable APIs to detect hinges and avoid placing critical content under a fold/hinge.
- Define explicit breakpoints (e.g. compact < 600, medium 600–840, expanded > 840) and switch layouts (`Row` vs `Column`, single-pane vs two-pane) accordingly.
- Use `Expanded`/`Flexible` for space distribution; constrain max width of lists/text on large/unfolded screens.
- Never lock screen orientation — foldables and multi-window modes require both portrait and landscape support.
- Reference the `flutter-build-responsive-layout` skill under [.github/skills](skills) for the full adaptive-layout workflow and examples.

## Available Skills

Official Dart/Flutter skills are installed under [.github/skills](skills) (via `dart run skills@ get`). Consult them proactively when the task matches, especially:

- `flutter-apply-architecture-best-practices` — feature structuring/refactoring
- `flutter-build-responsive-layout` — adaptive/foldable layouts
- `dart-use-pattern-matching`, `dart-use-primary-constructors` — modern Dart 3 syntax
- `flutter-implement-json-serialization`, `flutter-use-http-package` — data layer (used with `dio`)
- `dart-run-static-analysis`, `dart-collect-coverage`, `dart-add-unit-test` — quality gates matching the pre-push hook/CI
