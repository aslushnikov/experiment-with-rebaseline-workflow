import { test, expect, Page } from '@playwright/test';

test('should allow me to add todo items', async ({ page }) => {
  await page.goto('https://example.com');
  await expect(page).toHaveScreenshot();
});

test('test playwright.dev', async ({ page }) => {
  await page.goto('https://playwright.dev');
  await expect(page).toHaveScreenshot();
});

test('test google.com', async ({ page }) => {
  await page.goto('https://google.com');
  await expect(page).toHaveScreenshot();
});

