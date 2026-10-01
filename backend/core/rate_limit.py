"""Small process-local limits for authentication endpoints."""

import threading
import time
from collections import defaultdict, deque

from fastapi import HTTPException, Request

_login_attempts = defaultdict(deque)
_lock = threading.Lock()


def enforce_login_limit(request: Request, limit: int = 5, window_seconds: int = 60) -> None:
    client = request.client.host if request.client else "unknown"
    now = time.monotonic()
    with _lock:
        attempts = _login_attempts[client]
        while attempts and now - attempts[0] >= window_seconds:
            attempts.popleft()
        if len(attempts) >= limit:
            raise HTTPException(status_code=429, detail="Terlalu banyak percobaan login. Coba lagi nanti.")
        attempts.append(now)
