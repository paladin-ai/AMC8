# AMC8 AI Tutor — API (FastAPI + SQLite)

Run locally:

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate   # Windows
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

- Health check: `GET http://127.0.0.1:8000/health`
- API docs: `http://127.0.0.1:8000/docs`

Set `DATABASE_PATH` to a writable file under `backend/data/` (created on first run).
