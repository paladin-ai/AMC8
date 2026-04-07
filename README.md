# AMC8 AI Tutor

Monorepo layout:

| Folder       | Role |
|-------------|------|
| **`frontend/`** | Flutter app (`amc8`) — AMC8 practice UI, local SQLite (`sqflite`). |
| **`backend/`**  | FastAPI + server SQLite (`aiosqlite`) — sync API (expand as needed). |

### Flutter

```bash
cd frontend
flutter pub get
flutter run -d windows
```

### API

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

See **`AGENTS.md`** for paths and conventions.
