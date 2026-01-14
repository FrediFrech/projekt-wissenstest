# test/AuthServiceTest.java

Einfache Erklärung: Dieser Test zeigt, dass Login/Registrierung funktionieren – ohne echte Datenbank.

## Zweck
Unit‑Tests für Auth‑Logik (Happy/Fail).

## Inhalt & Verantwortung
- Testet Registrierung und Login.
- Stellt falsche Credentials sicher.

## Verbindungen
- Nutzt `AuthService` und InMemory‑UserDao.
