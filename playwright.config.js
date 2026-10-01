// playwright.config.js
const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './tests',
  testIgnore: '**/arsip_rekaman/**',
  timeout: 60 * 1000,
  workers: process.env.PW_WORKERS ? Number(process.env.PW_WORKERS) : 1,
  expect: {
    timeout: 5000,
  },
  use: {
    baseURL: process.env.BASE_URL || 'http://127.0.0.1:8000',
    headless: process.env.PW_HEADED === '1' ? false : true,
    viewport: { width: 1280, height: 720 },
    ignoreHTTPSErrors: true,
  },
});
