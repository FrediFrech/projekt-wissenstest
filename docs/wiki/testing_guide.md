
# Testing Guide

## Backend Tests (JUnit)
Das Backend verwendet JUnit 5 für Unit-Tests.
- **Ausführen**: `mvn test` im `mainlogik, backend` Verzeichnis.

## End-to-End Tests (Playwright)
Für Systemtests (User Flows) wird Playwright verwendet.
- **Voraussetzung**: Backend läuft (Tomcat auf Port 8080).
- **Ort**: `mainlogik, backend/e2e_tests/`
- **Installation**:
  ```bash
  cd "mainlogik, backend/e2e_tests"
  npm install
  ```
- **Ausführen**:
  ```bash
  npx playwright test
  ```
- **Abgedeckte Szenarien**:
  *   Admin Login & Frageerstellung
  *   Passwort-Reset Workflow (Request -> Admin Approve -> New Login)

