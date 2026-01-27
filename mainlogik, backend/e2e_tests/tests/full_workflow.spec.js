const { test, expect } = require('@playwright/test');

const BASE_URL = 'http://localhost:8080/wissentest'; 

test.describe('System Workflow', () => {

  test('Admin Question Management', async ({ page }) => {
    const prompt = `Playwright Question? ${Date.now()}`;

    // 1. Login
    await page.goto(BASE_URL + '/?page=login');
    await page.fill('input[name="username"]', 'lehrer');
    await page.fill('input[name="password"]', 'student');
    await page.click('button[type="submit"]');
    
    // 2. Nav to Admin
    await expect(page).toHaveURL(/page=testList/);
    await page.goto(BASE_URL + '/?page=adminPanel');
    
    // 3. Create Question
    await page.click('button:has-text("Frage erstellen")');
    await page.selectOption('select[name="type"]', 'MC');
    await page.fill('#qCategory', 'E2E Test');
    await page.fill('#qPrompt', prompt);
    await page.fill('#qAnswersRaw', '*Yes, No');
    await page.click('#questionForm button[type="submit"]');
    
    // 4. Verify
    await expect(page.locator('#questionTableBody')).toContainText(prompt);

    // 5. Cleanup: delete the created question so demo data stays clean
    page.once('dialog', async dialog => {
      await dialog.accept();
    });
    const row = page.locator('#questionTableBody tr', { hasText: prompt });
    await expect(row).toBeVisible();
    await row.locator('button').nth(1).click();
    await expect(page.locator('#questionTableBody')).not.toContainText(prompt);
  });

  test('Admin can hide question from LearnMode (learnEnabled)', async ({ page }) => {
    const prompt = `LearnEnabled Toggle? ${Date.now()}`;

    // 1. Login as admin
    await page.goto(BASE_URL + '/?page=login');
    await page.fill('input[name="username"]', 'lehrer');
    await page.fill('input[name="password"]', 'student');
    await page.click('button[type="submit"]');
    await expect(page).toHaveURL(/page=testList/);

    // 2. Create a question that should appear in LearnMode by default
    await page.goto(BASE_URL + '/?page=adminPanel');
    await page.click('button:has-text("Frage erstellen")');
    await page.selectOption('select[name="type"]', 'MC');
    await page.fill('#qCategory', 'E2E Test');
    await page.fill('#qPrompt', prompt);
    await page.fill('#qAnswersRaw', '*Yes, No');
    await expect(page.locator('#qLearnEnabled')).toBeChecked();
    await page.click('#questionForm button[type="submit"]');

    // 3. Verify it appears in LearnMode
    await page.goto(BASE_URL + '/?page=learnMode');
    await expect(page.locator('#learnStats')).toContainText('Zeige');
    await page.fill('#learnSearch', prompt);
    await expect(page.locator('#cardsGrid')).toContainText(prompt);

    // 4. Disable as LearnMode card via table checkbox
    await page.goto(BASE_URL + '/?page=adminPanel');
    const row = page.locator('#questionTableBody tr', { hasText: prompt });
    await expect(row).toBeVisible();
    const toggle = row.locator('input.learnToggle');
    await expect(toggle).toBeChecked();
    await toggle.uncheck();
    await page.waitForTimeout(800);

    // 5. Verify it no longer appears in LearnMode
    await page.goto(BASE_URL + '/?page=learnMode');
    await expect(page.locator('#learnStats')).toContainText('Zeige');
    await page.fill('#learnSearch', prompt);
    await expect(page.locator('#cardsGrid')).not.toContainText(prompt);

    // 6. Cleanup: delete created question
    await page.goto(BASE_URL + '/?page=adminPanel');
    page.once('dialog', async dialog => {
      await dialog.accept();
    });
    const cleanupRow = page.locator('#questionTableBody tr', { hasText: prompt });
    await expect(cleanupRow).toBeVisible();
    await cleanupRow.locator('button').nth(1).click();
    await expect(page.locator('#questionTableBody')).not.toContainText(prompt);
  });

  test('Password Reset Process', async ({ page }) => {
     // 1. User Requests
     await page.goto(BASE_URL + '/?page=login');
     await page.click('text=Passwort vergessen?');
     
     // Handle Alert
     page.on('dialog', async dialog => {
         await dialog.accept();
     });

     await page.fill('#resetUsername', 'student');
     await page.click('#resetModal button.btn-primary');
     // Wait for network/alert
     await page.waitForTimeout(1000); 

     // 2. Admin Approves
     await page.goto(BASE_URL + '/?page=login');
     await page.fill('input[name="username"]', 'lehrer');
     await page.fill('input[name="password"]', 'student');
     await page.click('button[type="submit"]');
    await expect(page).toHaveURL(/page=testList/);
     
     await page.goto(BASE_URL + '/?page=adminPanel');
     
     // Check List
     await expect(page.locator('#pwResetBody')).toContainText('student');
     
     // Click Reset (Edit)
     await page.locator('#pwResetBody tr:has-text("student") button').click();
     
     // Change Password
     await page.fill('#editPassword', 'newSafePass');
     await expect(page.locator('#editResetComplete')).toBeChecked();
     await page.click('#editUserModal button[type="submit"]');

     // Verify Gone
     await expect(page.locator('#pwResetBody')).not.toContainText('student');
  });
});
