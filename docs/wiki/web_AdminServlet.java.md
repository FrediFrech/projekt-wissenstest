
# web/AdminServlet.java

## Beschreibung
Controller für alle administrativen Aufgaben. Geschützt durch Rollen-Check ("admin").

## Endpunkte
*   `GET /api/admin/questions`: Liefert alle Fragen inkl. Antworten/Tokens als JSON.
*   `POST /api/admin/questions`: Erstellt neue Frage (MC/Cloze anhand `type`).
*   `PUT /api/admin/questions`: Aktualisiert existierende Frage und deren Antworten.
*   `DELETE /api/admin/questions?id=X`: Löscht Frage X.
*   `GET /api/admin/users`: Liste aller User.
*   `GET /api/admin/users/requests`: Liste aller User mit `reset_requested = true`.
*   `POST /api/admin/users`: Legt neuen User an.
*   `PUT /api/admin/users`: 
    *   Update von User-Details (Email, Rolle).
    *   Setzen eines neuen Passworts (Salt & Hash neu generiert).
    *   `resetComplete`: Setzt `reset_requested` auf `false`.
*   `GET /api/admin/stats`: Aggregierte Systemstatistiken.

