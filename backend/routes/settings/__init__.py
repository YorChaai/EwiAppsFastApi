from fastapi import APIRouter

settings_router = APIRouter(prefix="/api/settings", tags=["settings"])

# Import route modules so they register on the settings router.
from . import db_storage
