# frondend/src/components/Login.jsx

Einfache Erklärung: Das Login‑Formular, das die Daten ans Backend sendet.

## Zweck
Login‑Formular und API‑Aufruf.

## Inhalt & Verantwortung
- Erfasst Username/Password.
- Ruft `POST /api/auth/login` auf.

## Verbindungen
- Nutzt `apiClient.js`.
- Backend: `AuthServlet` + `AuthService`.
