
# db/schema.sql

## Beschreibung
Definiert das relationale Datenbankschema für PostgreSQL.

## Tabellen
1.  **users**: Speichert Login-Daten (Salted Hash).
    *   `reset_requested` (BOOLEAN): Flag für "Passwort vergessen" Workflow.
    *   `role`: "admin" oder "student".
2.  **questions**: Basisdaten einer Frage (Prompt, Type, Difficulty).
    *   `type`: ENUM ("MC", "CLOZE").
3.  **answers**: Antwortoptionen für Multiple-Choice.
4.  **cloze_answers**: Erwartete Tokens für Lückentexte.
5.  **attempts**: Ein durchgeführter Testversuch eines Nutzers.
    *   `grade` (VARCHAR): Berechnete Note.
    *   `duration_seconds` (INT): Dauer des Tests.
6.  **attempt_answers**: Die gegebenen Antworten innerhalb eines Versuchs.
    *   `ON DELETE SET NULL`: Löschen einer Frage löscht nicht den Versuch, sondern setzt die Referenz auf NULL.

