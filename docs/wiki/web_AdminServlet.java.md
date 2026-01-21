
# web/AdminServlet.java

## Beschreibung
Controller für alle administrativen Aufgaben. Geschützt durch Rollen-Check ("admin").

## Endpunkte
*   `GET /questions`: Liefert alle Fragen inkl. Antworten/Tokens als JSON (Nested Objects).
*   `POST /questions`: Erstellt neue Frage (unterscheidet MC/Cloze anhand `type`).
*   `PUT /questions`: Aktualisiert existierende Frage und deren Antworten.
*   `DELETE /questions?id=X`: Löscht Frage X.
*   `GET /users`: Liste aller User.
*   `GET /users/requests`: Liste aller User mit `reset_requested = true`.
*   `POST /users`: Legt neuen User an.
*   `PUT /users`: 
    *   Update von User-Details (Email, Rolle).
    *   Setzen eines neuen Passworts (Salt & Hash neu generiert).
    *   `resetComplete`: Setzt `reset_requested` auf `false`.
*   `GET /stats`: Aggregierte Systemstatistiken.

