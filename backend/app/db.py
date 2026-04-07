"""SQLite async engine — path from settings; file under backend/data/."""

from collections.abc import AsyncGenerator

from sqlalchemy import URL
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from app.core.config import settings

_engine_url = URL.create(
    "sqlite+aiosqlite",
    database=str(settings.database_path.resolve()),
)
engine = create_async_engine(_engine_url, echo=False)
AsyncSessionLocal = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with AsyncSessionLocal() as session:
        yield session
