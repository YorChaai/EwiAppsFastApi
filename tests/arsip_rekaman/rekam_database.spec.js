import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  // Berikan waktu 60 detik karena import database PostgreSQL membutuhkan proses backup & restore
  test.setTimeout(60000);

  await page.goto('http://localhost:50613/');
  // [AI Tool Auto-Fix] Aktifkan accessibility Flutter Web (Fast check)
  await page.locator('flt-semantics-placeholder').click({ timeout: 500 }).catch(() => {});
  await page.getByRole('textbox', { name: 'Username atau Email' }).click();
  await page.getByRole('textbox', { name: 'Username atau Email' }).fill('manager1');
  await page.getByRole('textbox', { name: 'Password' }).click();
  await page.getByRole('textbox', { name: 'Password' }).fill('manager12345');
  await page.locator('#flt-semantic-node-14').click({ timeout: 1500 }).catch(() => {});
  await page.getByRole('button', { name: 'Masuk' }).click();
  await page.getByRole('button', { name: 'EWI Foundation Masuk Dashboard' }).click();
  await page.getByRole('button', { name: 'Pengaturan Konfigurasi' }).click();
  await page.getByRole('button', { name: 'Manager Panel' }).click();
  // Siapkan file chooser untuk otomatis memilih file backup SQL tanpa dialog Windows
  const sqlBackupPath = 'D:/Aplikasi/EWIApps/data/backupdataapps/2026-09-01_21-34-16/migrasi_data_multiyear_hybrid_20260901_213416.sql';
  const fileChooserPromise = page.waitForEvent('filechooser');
  await page.getByRole('button', { name: 'Import Data' }).click();
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(sqlBackupPath);

  await page.getByRole('button', { name: 'YA, GANTI DATABASE' }).click();
  
  // Verifikasi database selesai dipulihkan & dashboard utama aktif kembali
  await expect(page.getByRole('button', { name: 'Pilih Perusahaan Lain' })).toBeVisible({ timeout: 30000 });
});
