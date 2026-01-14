# frondend/src/components/Register.jsx

Einfache Erklärung: Das Registrierungs‑Formular, das einen neuen Benutzer anlegt.

## Zweck
Registrierungs‑Formular und API‑Aufruf.

## Inhalt & Verantwortung
- Erfasst Username, E‑Mail, Passwort.
- Ruft `POST /api/auth/register` auf.

## Verbindungen
- Nutzt `apiClient.js`.
- Backend: `AuthServlet` + `AuthService`.
