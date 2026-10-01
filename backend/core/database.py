import os
import contextvars
import threading
from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, sessionmaker, scoped_session, Session
from config import Config

def _make_engine(database_url):
    if database_url.startswith("sqlite"):
        return create_engine(database_url, connect_args={"check_same_thread": False}, echo=False)
    return create_engine(
        database_url,
        echo=False,
        pool_size=25,
        max_overflow=35,
        pool_pre_ping=True,
        pool_recycle=1800,
    )


engine = _make_engine(Config.SQLALCHEMY_DATABASE_URI)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
_request_scope = contextvars.ContextVar("ewi_sqlalchemy_scope", default=None)


def _scope_key():
    return _request_scope.get() or threading.get_ident()


db_session = scoped_session(SessionLocal, scopefunc=_scope_key)


def set_session_scope(scope_id):
    return _request_scope.set(scope_id)


def reset_session_scope(token):
    _request_scope.reset(token)


def get_engine():
    return engine


def configure_database(database_url: str):
    """Rebind the session factory and engine for an isolated application instance."""
    global engine
    db_session.remove()
    engine.dispose()
    engine = _make_engine(database_url)
    SessionLocal.configure(bind=engine)
    return engine

from sqlalchemy.orm import Query as BaseQuery
from fastapi import HTTPException

class AppQuery(BaseQuery):
    def get_or_404(self, ident, description=None):
        rv = self.get(ident)
        if rv is None:
            raise HTTPException(status_code=404, detail=description or "Resource not found")
        return rv

class Base(DeclarativeBase):
    pass

# Provide .query backward-compatibility for models
Base.query = db_session.query_property(query_cls=AppQuery)

def get_db():
    """FastAPI Dependency for database sessions."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
