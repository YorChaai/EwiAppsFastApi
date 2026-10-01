"""Native ASGI entry point; the FastAPI application is defined in ``main.py``."""
from config import Config
from core.database import configure_database
from main import app


def create_app(config_override=None):
    """Return the FastAPI ASGI app, applying optional environment-style settings."""
    if config_override:
        for key, value in config_override.items():
            setattr(Config, key, value)
        database_url = config_override.get("SQLALCHEMY_DATABASE_URI")
        if database_url:
            configure_database(database_url)
        app.state.config_override = dict(config_override)
    return app


if __name__ == "__main__":
    import os
    import uvicorn

    uvicorn.run("main:app", host=os.getenv("EWI_HOST", "0.0.0.0"), port=int(os.getenv("EWI_PORT", "8000")))
