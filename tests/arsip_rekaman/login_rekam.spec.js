import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('http://localhost:50613/');
  // [AI Tool Auto-Fix] Aktifkan accessibility Flutter Web
  await page.waitForSelector('flt-semantics-placeholder', { timeout: 10000 }).catch(() => {});
  await page.evaluate(() => {
    const el = document.querySelector('flt-semantics-placeholder');
    if (el) el.click();
  });
  await page.waitForTimeout(1500);
  await page.getByRole('textbox', { name: 'Username atau Email' }).click();
  await page.getByRole('textbox', { name: 'Username atau Email' }).fill('manager1');
  await page.getByRole('textbox', { name: 'Password' }).click();
  await page.getByRole('textbox', { name: 'Password' }).fill('manager12345');
  await page.locator('#flt-semantic-node-14').click({ timeout: 1500 }).catch(() => {});
  await page.getByRole('button', { name: 'Masuk' }).click();
  await expect(page.getByText('Pilih Perusahaan', { exact: true })).toBeVisible({ timeout: 10000 });
});
