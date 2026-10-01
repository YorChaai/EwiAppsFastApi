// tests/authenticated_e2e_suite.spec.js
// Pengujian Menyeluruh Playwright dengan Sesi Otentikasi (Manager & Staff)
// Memvalidasi seluruh endpoint utama, kalkulasi, laporan, dan alur transaksi bisnis.

const { test, expect } = require('@playwright/test');
const fs = require('fs');
const path = require('path');

const BASE_API = process.env.BASE_URL || 'http://127.0.0.1:8000';

test.describe('E2E Full Application Diagnostic & Bug Discovery Suite', () => {
  let managerHeaders = {};
  let staffHeaders = {};

  test.beforeAll(async ({ request }) => {
    let mgrToken = '';
    let staffToken = '';

    const tokenFile = path.join(__dirname, '.auth_tokens.json');
    if (process.env.PLAYWRIGHT_USE_TOKEN_FILE === '1' && fs.existsSync(tokenFile)) {
      const data = JSON.parse(fs.readFileSync(tokenFile, 'utf8'));
      mgrToken = data.managerToken;
      staffToken = data.staffToken;
    } else {
      const resMgr = await request.post(`${BASE_API}/api/auth/login`, {
        data: { username: 'manager1', password: 'manager12345' }
      });
      const bodyMgr = await resMgr.json();
      mgrToken = bodyMgr.token;

      const resStaff = await request.post(`${BASE_API}/api/auth/login`, {
        data: { username: 'staff1', password: 'staff12345' }
      });
      const bodyStaff = await resStaff.json();
      staffToken = bodyStaff.token;
    }

    managerHeaders = {
      'Authorization': `Bearer ${mgrToken}`,
      'Content-Type': 'application/json'
    };
    staffHeaders = {
      'Authorization': `Bearer ${staffToken}`,
      'Content-Type': 'application/json'
    };
  });

  // =========================================================================
  // MODUL A: MASTER DATA & SETTINGS ENDPOINTS
  // =========================================================================
  test('[Master Data] GET /api/companies harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/companies`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
    const data = await res.json();
    expect(Array.isArray(data.data || data.companies || data)).toBeTruthy();
  });

  test('[Master Data] GET /api/categories & pending harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/categories`, { headers: managerHeaders });
    expect(res.status()).toBe(200);

    const resPending = await request.get(`${BASE_API}/api/categories/pending`, { headers: managerHeaders });
    expect(resPending.status()).toBe(200);
  });

  test('[Master Data] GET /api/categories/groups harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/categories/groups`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
  });

  test('[Master Data] GET /api/taxes & combine-groups harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/taxes`, { headers: managerHeaders });
    expect(res.status()).toBe(200);

    const resGrp = await request.get(`${BASE_API}/api/taxes/combine-groups?year=2024`, { headers: managerHeaders });
    expect(resGrp.status()).toBe(200);
  });

  test('[Master Data] GET /api/bank-management/banks harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/bank-management/banks`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
    const data = await res.json();
    expect(Array.isArray(data.banks || data)).toBeTruthy();
  });

  test('[Master Data] GET /api/bank-status/banks & transactions harus sukses 200', async ({ request }) => {
    const resBanks = await request.get(`${BASE_API}/api/bank-status/banks`, { headers: managerHeaders });
    expect(resBanks.status()).toBe(200);

    const resTx = await request.get(`${BASE_API}/api/bank-status/transactions`, { headers: managerHeaders });
    expect(resTx.status()).toBe(200);
  });

  test('[Settings] GET /api/settings/report-year & deadline harus sukses 200', async ({ request }) => {
    const resYear = await request.get(`${BASE_API}/api/settings/report-year`, { headers: managerHeaders });
    expect(resYear.status()).toBe(200);

    const resDeadline = await request.get(`${BASE_API}/api/settings/deadline`, { headers: managerHeaders });
    expect(resDeadline.status()).toBe(200);
  });

  // =========================================================================
  // MODUL B: TRANSAKSI KEUANGAN (DASHBOARD, REVENUES, DIVIDENDS, ASSETS)
  // =========================================================================
  test('[Dashboard] GET /api/dashboard/summary harus sukses 200 tanpa error 500', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/dashboard/summary`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
    const data = await res.json();
    expect(data).toHaveProperty('is_manager');
    expect(data).toHaveProperty('total_advances');
  });

  test('[Revenues] GET /api/revenues & combine-groups harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/revenues`, { headers: managerHeaders });
    expect(res.status()).toBe(200);

    const resGrp = await request.get(`${BASE_API}/api/revenues/combine-groups?year=2024`, { headers: managerHeaders });
    expect(resGrp.status()).toBe(200);
  });

  test('[Dividends] GET /api/dividends?year=2024 harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/dividends?year=2024`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
  });

  test('[Assets] GET /api/assets harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/assets`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
  });

  test('[Notifications] GET /api/notifications & unread-count harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/notifications`, { headers: managerHeaders });
    expect(res.status()).toBe(200);

    const resUnread = await request.get(`${BASE_API}/api/notifications/unread-count`, { headers: managerHeaders });
    expect(resUnread.status()).toBe(200);
  });

  // =========================================================================
  // MODUL C: ADVANCES (KASBON) & SETTLEMENTS
  // =========================================================================
  test('[Advances] GET /api/advances harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/advances`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
  });

  test('[Settlements] GET /api/settlements harus sukses 200', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/settlements`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
    const data = await res.json();
    expect(Array.isArray(data.settlements || data)).toBeTruthy();
  });

  // =========================================================================
  // MODUL D: LAPORAN (ANNUAL & SUMMARY REPORT GENERATION)
  // =========================================================================
  [2024, 2025, 2026].forEach((yr) => {
    test(`[Reports] GET /api/reports/annual (Year ${yr}) harus sukses 200`, async ({ request }) => {
      const res = await request.get(`${BASE_API}/api/reports/annual?year=${yr}`, { headers: managerHeaders });
      expect(res.status()).toBe(200);
      const data = await res.json();
      expect(data).toHaveProperty('year', yr);
      expect(data).toHaveProperty('revenue');
      expect(data).toHaveProperty('tax');
    });

    test(`[Reports] GET /api/reports/summary (Year ${yr}) harus sukses 200`, async ({ request }) => {
      const res = await request.get(`${BASE_API}/api/reports/summary?year=${yr}`, { headers: managerHeaders });
      expect(res.status()).toBe(200);
      const data = await res.json();
      expect(data).toHaveProperty('summary');
    });
  });

  test('[Reports Export] GET /api/reports/annual/excel harus menghasilkan file binary Excel (200)', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/reports/annual/excel?year=2024`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
    const headers = res.headers();
    expect(headers['content-type']).toContain('spreadsheet');
    const buffer = await res.body();
    expect(buffer.length).toBeGreaterThan(100);
  });

  test('[Reports Export] GET /api/reports/annual/pdf harus menghasilkan file PDF valid (200)', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/reports/annual/pdf?year=2024`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
    const headers = res.headers();
    expect(headers['content-type']).toContain('pdf');
    const buffer = await res.body();
    expect(buffer.length).toBeGreaterThan(100);
  });

  test('[Reports Export] GET /api/reports/summary/pdf harus sukses (200)', async ({ request }) => {
    const res = await request.get(`${BASE_API}/api/reports/summary/pdf?year=2024`, { headers: managerHeaders });
    expect(res.status()).toBe(200);
    const headers = res.headers();
    expect(headers['content-type']).toContain('pdf');
    const buffer = await res.body();
    expect(buffer.length).toBeGreaterThan(100);
  });

  // =========================================================================
  // MODUL E: ROLE-BASED ACCESS CONTROL (RBAC) & PERMISSIONS
  // =========================================================================
  test('[RBAC Staff Guard] Staff TIDAK BOLEH membuat bank fisik baru (Harus 403 Forbidden)', async ({ request }) => {
    const res = await request.post(`${BASE_API}/api/bank-management/banks`, {
      headers: staffHeaders,
      // Payload sengaja kosong agar tes tetap aman jika guard suatu saat rusak.
      data: {}
    });
    expect([401, 403]).toContain(res.status());
  });

  test('[RBAC Staff Guard] Staff TIDAK BOLEH mengeksekusi selective database cleanup (Harus 403)', async ({ request }) => {
    const res = await request.post(`${BASE_API}/api/cleanup/execute`, {
      headers: staffHeaders,
      // Daftar kosong tetap mencapai pemeriksaan role, tetapi tidak bisa menghapus data.
      data: { years: [], modules: [] }
    });
    expect([401, 403]).toContain(res.status());
  });
});
