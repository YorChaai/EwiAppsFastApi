import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  // [Auto-Fix] Timeout 60 detik untuk operasi database berat
  test.setTimeout(60000);

  await page.goto('http://localhost:50613/');
  // [Auto-Fix] Aktifkan accessibility Flutter Web (500ms fast check)
  await page.locator('flt-semantics-placeholder').click({ timeout: 500 }).catch(() => {});
  await page.getByRole('textbox', { name: 'Username atau Email' }).click();
  await page.getByRole('textbox', { name: 'Username atau Email' }).fill('manager1');
  await page.getByRole('textbox', { name: 'Password' }).click();
  await page.getByRole('textbox', { name: 'Password' }).fill('manager12345');
  await page.getByRole('button', { name: 'Masuk' }).click();
  await page.getByRole('button', { name: 'EWI Foundation Masuk Dashboard' }).click();
  await page.getByRole('button', { name: 'Pengaturan Konfigurasi' }).click();
  await page.getByRole('button', { name: 'Manager Panel' }).click();
    // [Auto-Fix] Tangani Windows File Chooser untuk Import Data
  const sqlBackup = 'D:/Aplikasi/EWIApps/data/backupdataapps/2026-09-01_21-34-16/migrasi_data_multiyear_hybrid_20260901_213416.sql';
  const fileChooserPromise = page.waitForEvent('filechooser');
  await page.getByRole('button', { name: 'Import Data' }).click();
  const fileChooser = await fileChooserPromise;
  await fileChooser.setFiles(sqlBackup);
  await page.getByRole('button', { name: 'YA, GANTI DATABASE' }).click();
  await page.locator('flutter-view').click({ position: { x: 50, y: 50 } }).catch(() => {});
  await page.getByRole('button', { name: 'Settlements Daftar pengajuan' }).click();
});
