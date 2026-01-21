
# web/AuthServlet.java

## Beschreibung
Handhabt Authentifizierung und Session-Management.

## Endpunkte
*   `POST /login`: Prüft Credentials. Bei Erfolg:
    *   Erstellt HttpSession.
    *   Setzt Session-Attribute: `user` (Username), `role`, `id`.
    *   Antwortet mit JSON User-Objekt.
*   `POST /register`: Erstellt neuen User (Role="student"). Prüft auf Duplikate.
*   `POST /logout`: Invalidiert die Session.
*   `POST /reset-request`: 
    *   Nimmt `{username}` entgegen.
    *   Setzt `reset_requested = true` in der DB.
    *   Wird vom AdminPanel angezeigt.

