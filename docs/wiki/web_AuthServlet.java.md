# web/AuthServlet.java

Einfache Erklärung: Dieses Servlet ist die Eingangstür für Login und Registrierung. Es nimmt JSON an und gibt JSON zurück.

## Zweck
HTTP‑API für Registrierung, Login, Logout.

## Inhalt & Verantwortung
- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/logout`
- Session‑Handling (userId, role)

## Verbindungen
- Nutzt `AuthService`.
- JSON über `ServletUtils`/`JsonUtil`.
