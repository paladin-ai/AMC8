# Agent / contributor map (AMC8)

Monorepo: **Flutter app** in `frontend/`, **FastAPI API** in `backend/`.

## Frontend (`frontend/`)

- **`frontend/pubspec.yaml`** — Flutter package name `amc8`; run all Flutter commands from `frontend/` (`flutter pub get`, `flutter run`, `flutter test`).
- **`frontend/lib/main.dart`** — entry: sqflite FFI (desktop), `MaterialApp`, auth → `HomePage`.
- **`frontend/lib/core/`** — `app_language.dart`, `desktop_sqflite_init*.dart`.
- **`frontend/lib/data/db_helper.dart`** — local SQLite; bump `_bundledDbRevision` when **`frontend/assets/math_problems.db`** changes.
- **`frontend/lib/screens/`** — auth, home, dashboard, papers, problems, practice, profile.
- **`frontend/lib/services/`** — API client, session prefs.
- **`frontend/lib/theme/`** — `app_theme.dart`.
- **`frontend/test/`** — `*_test.dart`.
- **`frontend/tool/`** — Dart one-off scripts (run with cwd = `frontend/`).

## Backend (`backend/`)

- **`backend/app/main.py`** — FastAPI app, CORS, lifespan (ensures `backend/data/` exists).
- **`backend/app/db.py`** — async SQLAlchemy + SQLite (`aiosqlite`); default DB path in `backend/data/app.db`.
- **`backend/app/routers/`** — route modules (e.g. `health.py`).
- **`backend/requirements.txt`** — install in a venv; run `uvicorn app.main:app` from **`backend/`** with `PYTHONPATH` or `pip install -e .` (optional).
- **`backend/tests/`** — pytest.

## Root

- **`.cursor/rules/`** — Cursor agent rules.
- **`documents/`** — optional docs.
- **`ZZZ_zzz.rules-new/`** — archived rule snapshots (superseded by `.cursor/rules/`).

## Native platforms

- **`frontend/android/`**, **`frontend/ios/`**, **`frontend/macos/`**, **`frontend/windows/`**, **`frontend/linux/`**, **`frontend/web/`** — Flutter platform folders.
