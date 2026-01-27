
# jsp_native/Login.jsp

## Einfache Erklärung
Die Login-Seite ist der "Eingang" zur App. Hier gibst du Benutzername und Passwort ein, damit die App weiß, wer du bist.

## Features
- **Authentifizierung**: Benutzername/Passwort Check via `AuthService` (Salted SHA-256 + Iterationen).
- **Session**: Bei Erfolg wird eine HTTP-Session erstellt (Cookie, serverseitig verwaltet).
- **Passwort vergessen**:
    - Link öffnet das Modal `resetModal`.
    - API-Call an `POST /api/auth/reset-request`.
    - Admin sieht anschließend eine Reset-Anfrage im Admin Panel.

## Technische Details
- **API**: `POST /api/auth/login`
- **Frontend**: Vanilla JS `handleLogin()` sendet Credentials als JSON.
- **Routing**: Nach Login Redirect zu `?page=testList`.

