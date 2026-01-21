
# jsp_native/Login.jsp

## Beschreibung
Die Login-Seite für authentifizierten Zugriff.

## Features
- **Authentifizierung**: Benutzername/Passwort Check via `AuthService` (Salted SHA-256).
- **Session**: Bei Erfolg wird eine HTTP-Session erstellt.
- **Passwort vergessen**:
    - Link öffnet ein Modal (`resetModal`).
    - API-Call an `/api/auth/reset-request`.
    - Informiert den Admin über den Reset-Wunsch.

## Technische Details
- **API**: POST `/api/auth/login`
- **Frontend**: Vanilla JS `handleLogin()` sendet Credentials als JSON.
- **Routing**: Nach Login Redirect zur `testList` (oder `adminPanel` wenn Rolle = Admin).

