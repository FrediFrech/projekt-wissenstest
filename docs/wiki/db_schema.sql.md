
# db/schema.sql

## Beschreibung
Definiert das relationale Datenbankschema f�r PostgreSQL.

## Tabellen
1.  **users**: Speichert Login-Daten (Hash+Salt), Rolle und Reset-Flag.
    *   `reset_requested` (BOOLEAN): Flag f�r "Passwort vergessen" Workflow.
    *   `role`: "admin" oder "student".
2.  **questions**: Basisdaten einer Frage (Prompt, Type, Difficulty, Points, Category, Image).
    *   `type`: Werte im Schema: "MC", "CLOZE".
3.  **answers**: Antwortoptionen f�r Multiple-Choice.
4.  **cloze_answers**: Erwartete Tokens f�r L�ckentexte.
5.  **attempts**: Ein durchgef�hrter Testversuch eines Nutzers.
    *   `total_points`, `max_points`, `grade`, `duration_seconds`.
6.  **attempt_answers**: Die gegebenen Antworten innerhalb eines Versuchs.
    *   `ON DELETE SET NULL`: L�schen einer Frage l�scht nicht den Versuch, sondern setzt die Referenz auf NULL.
7.  **config**: Schlüssel‑Wert‑Tabelle f�r Progression‑Schwellen.

