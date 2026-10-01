import pytest
import os
import sys
from fastapi.testclient import TestClient

# Ensure backend directory is in sys.path
backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from app import create_app
from services.reports.annual_service import excel_generator


@pytest.fixture
def app():
    return create_app(config_override={"SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:"})


@pytest.fixture
def client(app):
    return TestClient(app)


def test_excel_generator_logger_and_function_exist():
    """Verify logger and get_annual_report_excel exist and are valid in excel_generator."""
    assert hasattr(excel_generator, "logger")
    assert excel_generator.logger is not None
    assert excel_generator.logger.name == "services.reports.annual_service.excel_generator"
    assert hasattr(excel_generator, "get_annual_report_excel")
    assert callable(excel_generator.get_annual_report_excel)


def test_annual_routes_registered(app):
    """Verify that annual report endpoints are registered on the FastAPI app."""
    rules = [route.path for route in app.routes]
    assert "/api/reports/annual" in rules
    assert "/api/reports/annual/pdf" in rules
    assert "/api/reports/annual/excel" in rules


def test_annual_excel_requires_auth(client):
    """Verify that /api/reports/annual/excel requires JWT authentication (returns 401)."""
    res = client.get("/api/reports/annual/excel")
    assert res.status_code == 401


def test_annual_pdf_requires_auth(client):
    """Verify that /api/reports/annual/pdf requires JWT authentication (returns 401)."""
    res = client.get("/api/reports/annual/pdf")
    assert res.status_code == 401


def test_annual_json_requires_auth(client):
    """Verify that /api/reports/annual requires JWT authentication (returns 401)."""
    res = client.get("/api/reports/annual")
    assert res.status_code == 401
