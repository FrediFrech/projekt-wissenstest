
# db/schema.sql

## Beschreibung
Definiert das relationale Datenbankschema für PostgreSQL.

## Tabellen
1.  **users**: Speichert Login-Daten (Hash+Salt), Rolle und Reset-Flag.
    *   `reset_requested` (BOOLEAN): Flag für "Passwort vergessen" Workflow.
    *   `role`: "admin" oder "student".
2.  **questions**: Basisdaten einer Frage (Prompt, Type, Difficulty, Points, Category, Image).
    *   `type`: Werte im Schema: "MC", "CLOZE".
3.  **answers**: Antwortoptionen für Multiple-Choice.
4.  **cloze_answers**: Erwartete Tokens für Lückentexte.
5.  **attempts**: Ein durchgeführter Testversuch eines Nutzers.
    *   `total_points`, `max_points`, `grade`, `duration_seconds`.
6.  **attempt_answers**: Die gegebenen Antworten innerhalb eines Versuchs.
    *   `ON DELETE SET NULL`: Löschen einer Frage löscht nicht den Versuch, sondern setzt die Referenz auf NULL.
7.  **config**: Schlüssel‑Wert‑Tabelle für Progression‑Schwellen.

