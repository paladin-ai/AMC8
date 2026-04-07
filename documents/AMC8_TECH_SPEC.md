# AMC8 AI Tutor — Technical Specification

*(Derived from `c:\Users\li_lu\Downloads\AMC8_local`)*

## 1. Project Overview

**Purpose:** AMC8 AI Tutor is a Flutter client for practicing MAA AMC8-style mathematics, with a bundled SQLite problem bank and optional HTTP calls to a remote account API.

**Phase 1 target scope:** user management (register/login/profile), past papers by year, two test modes (untimed vs. standard AMC8 time), scoring and detailed results, wrong-answer list, review marks, and re-testing from wrong/review/both.

## 2. Feature Completion Status (CRITICAL)

| Feature | Sub-function | Status (✅ Coded / ❌ Not Coded / 🚧 Partial) | Notes / Missing pieces |
|---------|--------------|-----------------------------------------------|------------------------|
| User management | Registration (email/password) | ✅ Coded | `RegisterScreen` -> `AuthActions.signUpWithEmailPassword` -> `ApiService.createUser`. |
| User management | Login | ✅ Coded | `LoginScreen` -> `AuthActions.signInWithEmailPassword` -> `getUserInfo` + `login`. |
| User management | Password reset | ❌ Not Coded | `AuthActions.requestPasswordReset` throws not-available error; no endpoint call wired. |
| User management | Profile update (name) | 🚧 Partial | `ProfileScreen` updates full name via `/api/user/update`; phone/language not handled. |
| User management | Dynamic UI language switching | 🚧 Partial | `AppLanguage` exists, but UI strings are mostly hard-coded; inconsistent language codes in `PastPapersGridPage` (`en`/`zh`). |
| Past papers | List by year | ✅ Coded | `PapersRepository` mock returns 2025-2020. |
| Past papers | Open paper detail flow | 🚧 Partial | 2025 has full grid with pages; non-2025 routes to placeholder page. |
| Test modes | No time limit mode | 🚧 Partial | Practice/timed buttons exist, but no unified exam engine and no persisted exam result. |
| Test modes | Standard AMC8 timed mode | ❌ Not Coded | `timed` argument is passed but not consumed for timer/countdown/session behavior. |
| Results & scoring | Display total score | ❌ Not Coded | No score computation/result screen implemented. |
| Results & scoring | Detailed per-question results | ❌ Not Coded | Answers are in-memory only in `CustomTestSessionScreen` (`_picked`). |
| Wrong answer list | Dedicated list screen/data | ❌ Not Coded | Nav items are stubs (`coming soon`). |
| Review marking | Mark questions for review | ❌ Not Coded | No mark model/table/toggle UI found. |
| Re-testing | From wrong-answer list | ❌ Not Coded | No flow implemented. |
| Re-testing | From review list | ❌ Not Coded | No flow implemented. |
| Re-testing | Combined wrong + review | ❌ Not Coded | Current setup randomizes by year only. |

### Supporting functions status

| Supporting area | Status | Notes |
|-----------------|--------|-------|
| Local FastAPI domain APIs | ❌ Not Coded | Repo backend exposes only `/` and `/health`. |
| SQLAlchemy ORM models | ❌ Not Coded | `backend/app/models/__init__.py` is empty. |
| Backend Pydantic domain schemas | ❌ Not Coded | `backend/app/schemas/__init__.py` is empty. |
| Alembic migrations | ❌ Not Coded | No Alembic directory/config found. |
| Frontend writable user/session SQLite schema | ❌ Not Coded | `DBHelper` only reads bundled `math_problems`. |
| Offline sync queue/middleware | ❌ Not Coded | No sync queue/service found. |

## 3. Design Specifications for Missing Functions (NEW)

> Note: This repo's implemented backend stack is FastAPI + SQLite (`aiosqlite`). The design below stays aligned with existing code patterns while remaining compatible with a future PostgreSQL migration if desired.

### 3.1 Password reset

#### Backend (FastAPI + PostgreSQL-compatible design)

- **Database table structure**
  - `password_reset_tokens`
    - `id` (UUID, PK)
    - `user_id` (UUID/INT, FK -> `users.id`, indexed)
    - `token_hash` (VARCHAR, unique, indexed)
    - `expires_at` (TIMESTAMP, indexed)
    - `used_at` (TIMESTAMP, nullable)
    - `created_at` (TIMESTAMP, default now)
  - Constraint: token usable once (`used_at IS NULL` + unexpired).

- **API endpoints**
  - `POST /auth/password-reset/request`
    - Request: `{ "email": "user@example.com" }`
    - Response: `{ "message": "If account exists, reset instructions were sent." }`
    - Auth: none
    - Error handling: always generic success message to avoid account enumeration.
  - `POST /auth/password-reset/confirm`
    - Request: `{ "token": "...", "new_password": "..." }`
    - Response: `{ "message": "Password reset successful" }`
    - Auth: none
    - Errors: `400` invalid/expired token, `422` weak password.

- **Business logic**
  - Request endpoint creates short-lived signed token record and sends email.
  - Confirm endpoint validates token, updates password hash, marks token used.

#### Frontend (Flutter + SQLite)

- **UI screen/widget**
  - `ForgotPasswordScreen`: email input + submit button.
  - `ResetPasswordScreen`: token + new password + confirm.

- **State management**
  - `loading`, `errorText`, `successMessage`.
  - Methods: `requestReset()`, `confirmReset()`.

- **Local SQLite operations**
  - None required for baseline.
  - Optional `pending_actions` table for offline request queue (if product requires).

- **Integration**
  - Add `ApiService.requestPasswordReset()` and `ApiService.confirmPasswordReset()`.
  - Wire `LoginScreen` "Forgot password" flow to these methods.

### 3.2 Profile update completion (phone + language)

#### Backend (FastAPI + PostgreSQL-compatible design)

- **Database table structure**
  - Update `users`:
    - `phone` (VARCHAR nullable)
    - `language` (VARCHAR, default `en`, check in allowed set)
    - `updated_at` (TIMESTAMP)
  - Index: `users(email)` unique.

- **API endpoints**
  - `PATCH /users/me`
    - Request: `{ "full_name"?: str, "phone"?: str, "language"?: "en"|"zh-Hans"|"zh-Hant" }`
    - Response: `{ "id": ..., "email": ..., "full_name": ..., "phone": ..., "language": ... }`
    - Auth: Bearer JWT required
    - Errors: `401`, `422`, `404`.

- **Business logic**
  - Validate ownership from token.
  - Validate language enum and phone format.
  - Persist and return normalized profile payload.

#### Frontend (Flutter + SQLite)

- **UI screen/widget**
  - Extend `ProfileScreen` with:
    - editable full name
    - phone field
    - language dropdown (`en`, `zh-Hans`, `zh-Hant`).

- **State management**
  - `profileLoading`, `saving`, `nameController`, `phoneController`, `selectedLanguage`.
  - Methods: `loadProfile()`, `saveProfile()`, `applyLanguage()`.

- **Local SQLite operations**
  - Add writable profile cache table:
    - `user_profile_cache(user_id TEXT PRIMARY KEY, email TEXT, full_name TEXT, phone TEXT, language TEXT, updated_at TEXT)`.

- **Integration**
  - `ApiService.updateProfile()` -> `PATCH /users/me`.
  - On success, update `SessionPrefs` and local SQLite cache; trigger app-wide language rebuild.

### 3.3 Timed mode implementation (standard AMC8 40 minutes)

#### Backend (FastAPI + PostgreSQL-compatible design)

- **Database table structure**
  - `test_sessions`
    - `id` (UUID, PK)
    - `user_id` (FK)
    - `year` (INT)
    - `mode` (VARCHAR: `unlimited`/`timed`)
    - `started_at`, `ends_at`, `finished_at` (TIMESTAMP)
    - `score` (INT nullable)
  - Indexes: `(user_id, started_at)`, `(year)`.

- **API endpoints**
  - `POST /sessions`
    - Request: `{ "year": 2025, "mode": "timed", "problem_ids": [1..25] }`
    - Response: session metadata with countdown end time.
  - `PATCH /sessions/{session_id}/finish`
    - Request: `{ "answers": [{ "problem_id": ..., "choice": "A", "elapsed_sec": ... }] }`
    - Response: computed score + detailed correctness.

- **Business logic**
  - Timed mode enforces 40-minute cutoff.
  - Compute score server-side from answer key.

#### Frontend (Flutter + SQLite)

- **UI screen/widget**
  - Create unified `ExamSessionScreen` for both modes.
  - Show timer bar + countdown when `mode == timed`.

- **State management**
  - `currentQuestionIndex`, `remainingSeconds`, `answersMap`, `isSubmitting`.
  - Timer lifecycle in `initState`/`dispose`.

- **Local SQLite operations**
  - `test_sessions` + `session_answers` tables for offline persistence.

- **Integration**
  - Read selected mode from papers flow and pass strongly typed enum.
  - Submit finished session via API; fallback to local save on network failure.

### 3.4 Results & scoring

#### Backend (FastAPI + PostgreSQL-compatible design)

- **Database table structure**
  - `session_answers`
    - `id` (UUID, PK)
    - `session_id` (FK indexed)
    - `problem_id` (FK/index)
    - `selected_choice` (CHAR(1))
    - `is_correct` (BOOLEAN indexed)
    - `elapsed_sec` (INT)
  - Optional view/table for result summaries.

- **API endpoints**
  - `GET /sessions/{session_id}`
  - `GET /users/me/results?limit=&offset=`
  - Auth required.

- **Business logic**
  - Return score summary and detailed per-question status.

#### Frontend (Flutter + SQLite)

- **UI screen/widget**
  - `ResultsScreen` with score header + per-question list.
  - Home dashboard cards read computed aggregates.

- **State management**
  - `resultLoading`, `resultModel`.
  - Methods: `loadSessionResult()`, `computeLocalStats()`.

- **Local SQLite operations**
  - Aggregate query for tests taken and average score.

- **Integration**
  - After session submit, navigate to `ResultsScreen`.
  - Sync local result entries to backend when online.

### 3.5 Wrong answer list

#### Backend (FastAPI + PostgreSQL-compatible design)

- **Database table structure**
  - Option A: derive from `session_answers` (`is_correct=false`).
  - Option B: materialize cache table `wrong_answers`.
  - Indexes: `(user_id, problem_id)`.

- **API endpoints**
  - `GET /users/me/wrong-answers`
  - `DELETE /users/me/wrong-answers/{problem_id}` (optional clear action).

- **Business logic**
  - Deduplicate by problem, keep latest wrong attempt metadata.

#### Frontend (Flutter + SQLite)

- **UI screen/widget**
  - `WrongAnswersScreen` list with filters by year/topic.

- **State management**
  - `items`, `loading`, `selectedFilters`.

- **Local SQLite operations**
  - `wrong_answers(user_id TEXT, year INT, problem_number TEXT, last_wrong_at TEXT, PRIMARY KEY(user_id, year, problem_number))`.

- **Integration**
  - Home/Papers nav "Wrong Answers" links to new screen.

### 3.6 Review marking

#### Backend (FastAPI + PostgreSQL-compatible design)

- **Database table structure**
  - `review_marks`
    - `id` (UUID PK)
    - `user_id` (FK indexed)
    - `problem_id` (FK indexed)
    - `marked_at` (TIMESTAMP)
    - unique `(user_id, problem_id)`.

- **API endpoints**
  - `PUT /review/{problem_id}` (toggle/set)
  - `GET /users/me/review`.

- **Business logic**
  - Idempotent mark/unmark behavior.

#### Frontend (Flutter + SQLite)

- **UI screen/widget**
  - Add bookmark icon in problem pages and session pages.
  - `ReviewListScreen` to display all marked problems.

- **State management**
  - `isMarked`, `toggleReviewMark(problemRef)`.

- **Local SQLite operations**
  - `review_marks(user_id TEXT, year INT, problem_number TEXT, marked_at TEXT, PRIMARY KEY(user_id, year, problem_number))`.

- **Integration**
  - Optimistic local toggle + API sync retry on failure.

### 3.7 Re-testing from wrong/review/both

#### Backend (FastAPI + PostgreSQL-compatible design)

- **API endpoints**
  - `POST /sessions/retest`
    - Request:
      - `{ "source": "wrong" | "review" | "both", "mode": "unlimited"|"timed", "limit"?: int }`
      - or explicit `{ "problem_ids": [...] }`.
    - Response: session with selected problem set.

- **Business logic**
  - Build source list from wrong/review datasets.
  - Support union and intersection options as product requires.

#### Frontend (Flutter + SQLite)

- **UI screen/widget**
  - `RetestSetupScreen` with source chips: Wrong / Review / Both.
  - Preview selected questions count before start.

- **State management**
  - `selectedSource`, `selectedMode`, `selectedProblemRefs`.

- **Local SQLite operations**
  - Query union/intersection across `wrong_answers` and `review_marks`.

- **Integration**
  - Launch `ExamSessionScreen` with explicit selected `ProblemRef` list.

## 4. User Profile Enhancement Recommendations

| Attribute | Data type | Why useful for AMC8 AI Tutor | Storage location | Priority |
|-----------|-----------|------------------------------|------------------|----------|
| grade_level | INT or ENUM | Better personalization of problem recommendations and progress benchmarks | Both (SQLite + cloud DB) | High (Phase 2) |
| date_of_birth | DATE | Age-based analytics and parental controls for minors | Cloud primary, local optional cache | Medium (Phase 2) |
| avatar_url | TEXT | Improves engagement and profile identity | Both | Low (Phase 2) |
| preferred_difficulty | ENUM/TEXT | Tailors practice generation and review recommendations | Both | Medium (Phase 2) |
| daily_study_goal | INT (minutes/questions) | Supports habit-building and streak reminders | Both | Medium (Phase 2) |
| notification_preferences | JSON or columns | Enables opt-in reminders and exam prep nudges | Cloud + local mirror | Medium (Phase 2) |
| parent_guardian_email | TEXT | Useful for child accounts and progress sharing | Cloud only (sensitive) | Low (Phase 2/3) |
| subscription_tier | ENUM (`free`/`premium`) | Feature gating and monetization readiness | Cloud authoritative, local cache | Medium (Phase 2) |
| last_active_at | TIMESTAMP | Engagement analytics and retention tracking | Cloud primary | High (Phase 2) |
| total_practice_time_sec | INT | Key learning metric and dashboard summary | Both | Medium (Phase 2) |
| strengths_weaknesses_profile | JSON | Enables adaptive practice recommendations by topic | Cloud computed + local cache | Medium (Phase 2/3) |

## 5. Backend Specification (Existing Code)

### Existing API endpoints in repo backend

| Method | Path | Request schema | Response schema | Auth |
|--------|------|----------------|-----------------|------|
| GET | `/` | None | `{ service: string, docs: string }` | None |
| GET | `/health` | None | `{ status: "ok" }` | None |

### Existing database setup in repo backend

- SQLAlchemy async engine configured with `sqlite+aiosqlite`.
- DB path from settings: `database_path` (default `backend/data/app.db`).
- No SQLAlchemy models or Alembic migrations found.
- No PostgreSQL configuration found in current backend code.

### Authentication method in repo backend

- Not implemented in local FastAPI app.
- Frontend expects JWT-style Bearer tokens from remote API responses.

## 6. Frontend Specification (Existing Code)

### Main screens and navigation

- Auth root: `LoginScreen` <-> `RegisterScreen` in `main.dart`.
- Post-login: `HomePage`.
- `HomePage` routes:
  - Past papers -> `PapersScreen`
  - Profile -> `ProfileScreen`
  - Wrong answers/review -> currently stub snackbars.
- Papers flow:
  - `PapersScreen` list/grid by year.
  - 2025 -> `PastPapersGridPage` -> 25 problem pages.
  - Other years -> placeholder screen.
- Practice flow:
  - `CustomTestSetupScreen` -> `CustomTestSessionScreen`.

### State management approach

- StatefulWidget + `setState` local state.
- Shared prefs wrapper `SessionPrefs` for basic session profile fields.
- No Provider/Riverpod/Bloc state framework found.

### Local SQLite table structures actually found

- `math_problems` (read by queries in `DBHelper`):
  - fields used: `language`, `year`, `problem_number`, `question`, `question2`, `options`.
- No writable local tables for user profile cache, sessions, wrong answers, or review marks found in `DBHelper`.

### Offline sync strategy

- Not implemented in current code.
- Current behavior relies on immediate API calls and local transient/in-memory state.

## 7. Data Flow Diagrams (text-based)

### A) Login flow

1. User inputs email/password in `LoginScreen`. **[Implemented]**
2. `AuthActions.signInWithEmailPassword` calls `GET /api/user/info`. **[Implemented]**
3. If user exists, call `POST /api/auth/login`. **[Implemented]**
4. Save token + expiry + session profile in `SharedPreferences`. **[Implemented]**
5. Navigate to `HomePage`. **[Implemented]**

### B) Past papers flow

1. Home -> Past Papers navigation. **[Implemented]**
2. `PapersRepository.fetchPage` returns mock year list. **[Implemented]**
3. User selects paper:
   - year 2025 -> full problem grid and pages. **[Implemented]**
   - other years -> placeholder detail page. **[Implemented/Partial overall feature]**

### C) Practice test flow

1. Home -> custom test setup. **[Implemented]**
2. Setup picks years/count and loads problems from SQLite bank. **[Implemented]**
3. Session screen displays questions/options and records selected letters in memory. **[Implemented]**
4. Compute score and save results. **[Planned]**
5. Sync result to backend and update dashboard stats. **[Planned]**

### D) Wrong/review/retest flow

1. User marks question as review. **[Planned]**
2. Save mark locally and sync to backend. **[Planned]**
3. Wrong answers derived from submitted session correctness. **[Planned]**
4. Wrong/review list screens display selectable problems. **[Planned]**
5. Re-test launches from wrong/review/both set. **[Planned]**

## 8. Environment Variables & Configuration

### Currently used

- Frontend:
  - `API_BASE_URL` via `--dart-define` in Flutter run command.
- Backend:
  - `app_name` (settings)
  - `secret_key` (settings)
  - `database_path` (settings)
  - optional `.env` loading via `pydantic-settings`.

### Missing / recommended

- Backend:
  - explicit production `SECRET_KEY` in deployment env
  - password reset mail settings (SMTP host/user/pass)
  - CORS allowlist by environment
  - JWT expiry settings
  - rate-limit configs.
- Frontend:
  - environment profile docs for dev/staging/prod API base URLs.

## 9. Migration & Testing Strategy

### Migrations

- Alembic is not set up in current repository.
- No migration scripts found.
- Recommendation:
  1. Add Alembic baseline migration for users/sessions/results tables.
  2. Adopt migration policy for schema changes.

### Existing tests

- Backend:
  - `backend/tests/test_health.py` (health endpoint only).
- Frontend:
  - `frontend/test/smoke_test.dart` (basic smoke test only).

### Recommended testing expansion

- Backend (pytest):
  - auth endpoints (register/login/reset)
  - profile update validation
  - session scoring and wrong-answer derivation
  - review mark toggling.
- Frontend (flutter test):
  - auth validation flows
  - papers mode selection behavior
  - timed session countdown logic
  - scoring + results view
  - wrong/review/retest flows
  - SQLite read/write helpers with test DB fixtures.

