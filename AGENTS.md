# Agent / contributor map (AMC8)

Short orientation for humans and coding agents working in this repository.

## What this is

Flutter app **AMC8 AI Tutor** — math practice with local SQLite data and auth screens.

## Entry and app shell

- `lib/main.dart` — `main()`, sqflite FFI init for desktop/test, `MaterialApp`, auth gate (`LoginScreen` / `RegisterScreen`) and `HomePage` after sign-in.
- `lib/theme/app_theme.dart` — shared light/dark theme.

## Core & data

- `lib/core/app_language.dart` — active UI language code (`en` / `zh-Hans` / `zh-Hant`).
- `lib/core/desktop_sqflite_init*.dart` — conditional export for desktop sqflite FFI.
- `lib/data/db_helper.dart` — opens `math_problems.db`; copies from `assets/math_problems.db` when revision bumps (`_bundledDbRevision`). **Bump revision** whenever the bundled DB asset changes so existing installs refresh.
- `assets/math_problems.db` — bundled problem database.

## Screens (`lib/screens/`)

- `screens/auth/` — login, registration, auth widgets.
- `screens/home/` — `home_page.dart` (main shell after login).
- `screens/dashboard/` — home dashboard tokens and widgets.
- `screens/papers/` — past papers list, grid, models, `past_papers_grid_screen.dart`.
- `screens/profile/` — `profile_screen.dart`.
- `screens/problems/` — `year2025_problem*_page.dart` and related problem pages.
- `screens/practice/` — custom test setup / session flow (formerly `lib/test/`).

## Services

- `lib/services/` — API client (`api_service.dart`), session prefs, etc.

## Tests

- `test/` — add `*_test.dart` here; run `flutter test`.

## Config

- `pubspec.yaml` / `pubspec.lock` — dependencies; `analysis_options.yaml` — lints (`flutter_lints`).

## Platform

- `android/`, `ios/`, `macos/` — native projects; change when adding permissions, icons, or build settings.
