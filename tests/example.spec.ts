import { test, expect, Page } from '@playwright/test';

test('should allow me to add todo items', async ({ page }) => {
  await page.goto('https://example.com');
  await expect(page).toHaveScreenshot();
});

test('should allow me to add todo items', async ({ page }) => {
  await page.goto('https://playwright.dev');
  await expect(page).toHaveScreenshot();
});

