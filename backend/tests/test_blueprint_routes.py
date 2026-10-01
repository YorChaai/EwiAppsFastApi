import pytest
import os
import sys
from fastapi.testclient import TestClient

backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from app import create_app


@pytest.fixture
def app(tmp_path):
    database_url = f"sqlite:///{(tmp_path / 'test.db').as_posix()}"
    return create_app(config_override={"SQLALCHEMY_DATABASE_URI": database_url})


@pytest.fixture
def client(app):
    return TestClient(app)


def test_native_routers_registered(app):
    """Verify each API namespace is registered in the FastAPI application."""
    paths = {route.path for route in app.routes}
    expected_paths = [
        "/api/auth/login",
        "/api/settlements",
        "/api/expenses/categories",
        "/api/reports/annual",
        "/api/categories",
        "/api/advances",
        "/api/companies",
        "/api/settings",
        "/api/revenues",
        "/api/taxes",
        "/api/dividends",
        "/api/dashboard",
        "/api/notifications",
        "/api/bank-management/banks",
        "/api/bank-status/banks",
        "/api/assets",
        "/api/cleanup",
    ]
    for path in expected_paths:
        assert any(
            registered == path or registered.startswith(path.rstrip("/") + "/")
            for registered in paths
        ), f"FastAPI route namespace {path} is not registered"


def test_reports_endpoints_methods(app):
    """Verify reports endpoints exist and support GET method."""
    endpoint_map = {route.path: route.methods for route in app.routes if hasattr(route, "methods")}
    
    assert "/api/reports/annual" in endpoint_map
    assert "GET" in endpoint_map["/api/reports/annual"]

    assert "/api/reports/annual/pdf" in endpoint_map
    assert "GET" in endpoint_map["/api/reports/annual/pdf"]

    assert "/api/reports/annual/excel" in endpoint_map
    assert "GET" in endpoint_map["/api/reports/annual/excel"]

    assert "/api/reports/summary" in endpoint_map
    assert "GET" in endpoint_map["/api/reports/summary"]

    assert "/api/reports/summary/pdf" in endpoint_map
    assert "GET" in endpoint_map["/api/reports/summary/pdf"]


def test_auth_login_endpoint(client):
    """Verify /api/auth/login exists and rejects empty/invalid POST."""
    res = client.post("/api/auth/login", json={})
    # Should return 400 or 401 for empty credentials, NOT 404
    assert res.status_code in (400, 401)


def test_authenticated_advances_list_returns_empty_list(app):
    """Regression: list endpoint's SQLAlchemy filters must work with no records."""
    from fastapi.testclient import TestClient
    from core.security import get_current_user
    from models import User

    app.dependency_overrides[get_current_user] = lambda: User(
        id=1, role="super_manager"
    )
    with TestClient(app) as test_client:
        response = test_client.get("/api/advances")

    assert response.status_code == 200
    assert response.json() == {"advances": []}
