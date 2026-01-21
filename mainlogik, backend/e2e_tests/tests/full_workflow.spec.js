const { test, expect } = require('@playwright/test');

const BASE_URL = 'http://localhost:8080/wissentest'; 

test.describe('System Workflow', () => {

  test('Admin Question Management', async ({ page }) => {
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
    await page.fill('#qPrompt', 'Playwright Question?');
    await page.fill('#qAnswersRaw', '*Yes, No');
    await page.click('#questionForm button[type="submit"]');
    
    // 4. Verify
    await expect(page.locator('#questionTableBody')).toContainText('Playwright Question?');
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
