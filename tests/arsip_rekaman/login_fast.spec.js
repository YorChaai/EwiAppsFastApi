import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('http://localhost:50613/');
  
  // Klik placeholder semantics jika ada (hanya cek kilat 500ms)
  await page.locator('flt-semantics-placeholder').click({ timeout: 500 }).catch(() => {});

  await page.getByRole('textbox', { name: 'Username atau Email' }).fill('manager1');
  await page.getByRole('textbox', { name: 'Password' }).fill('manager12345');
  await page.getByRole('button', { name: 'Masuk' }).click();
  await expect(page.getByText('Pilih Perusahaan', { exact: true })).toBeVisible({ timeout: 10000 });
});
