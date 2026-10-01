import requests
import json

tokens = json.load(open('tests/.auth_tokens.json'))
headers = {'Authorization': f'Bearer {tokens["managerToken"]}'}

endpoints = [
    ('GET', '/api/bank-management/banks'),
    ('GET', '/api/bank-status/stats'),
    ('GET', '/api/dashboard/summary'),
    ('GET', '/api/dividends'),
    ('GET', '/api/advances'),
    ('GET', '/api/reports/annual?year=2024'),
    ('GET', '/api/reports/summary?year=2024'),
    ('GET', '/api/reports/annual/excel?year=2024'),
    ('GET', '/api/reports/annual/pdf?year=2024'),
    ('GET', '/api/reports/summary/pdf?year=2024'),
]

for method, ep in endpoints:
    url = f'http://127.0.0.1:5000{ep}'
    try:
        res = requests.request(method, url, headers=headers)
        print(f"[{res.status_code}] {method} {ep}")
        if res.status_code >= 400:
            print("   ERROR:", res.text[:200])
        else:
            ct = res.headers.get('Content-Type', '')
            print(f"   OK: Content-Type={ct}, length={len(res.content)}")
    except Exception as e:
        print(f"[EXCEPTION] {method} {ep}: {e}")
