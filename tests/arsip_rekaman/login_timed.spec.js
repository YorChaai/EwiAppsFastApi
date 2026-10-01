import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  console.time('1_goto');
  await page.goto('http://localhost:50613/');
  console.timeEnd('1_goto');

  console.time('2_waitForSelector_placeholder');
  await page.waitForSelector('flt-semantics-placeholder', { timeout: 10000 }).catch(() => {});
  console.timeEnd('2_waitForSelector_placeholder');

  console.time('3_evaluate_click_placeholder');
  await page.evaluate(() => {
    const el = document.querySelector('flt-semantics-placeholder');
    if (el) el.click();
  });
  console.timeEnd('3_evaluate_click_placeholder');

  console.time('4_waitForTimeout_1500');
  await page.waitForTimeout(1500);
  console.timeEnd('4_waitForTimeout_1500');

  console.time('5_find_and_click_user_textbox');
  await page.getByRole('textbox', { name: 'Username atau Email' }).click();
  console.timeEnd('5_find_and_click_user_textbox');

  console.time('6_fill_username');
  await page.getByRole('textbox', { name: 'Username atau Email' }).fill('manager1');
  console.timeEnd('6_fill_username');

  await page.getByRole('textbox', { name: 'Password' }).click();
  await page.getByRole('textbox', { name: 'Password' }).fill('manager12345');
  await page.locator('#flt-semantic-node-14').click({ timeout: 1500 }).catch(() => {});
  await page.getByRole('button', { name: 'Masuk' }).click();
  await expect(page.getByText('Pilih Perusahaan', { exact: true })).toBeVisible({ timeout: 10000 });
});
