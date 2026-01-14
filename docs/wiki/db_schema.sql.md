# db/schema.sql

Einfache Erklärung: Dieses SQL‑Skript erstellt alle Tabellen, die die App braucht. Ohne dieses Schema kann die App keine Daten speichern oder laden.

## Zweck
Definiert das Datenbankschema (DDL) für Nutzer, Fragen, Antworten, Tests und Konfiguration.

## Inhalt & Verantwortung
- `users`: Benutzerdaten inkl. Hash/Salt.
- `questions`: Fragenmetadaten inkl. Typ, Schwierigkeit, Punkte.
- `answers`: MC‑Antwortoptionen mit Teilwertung.
- `cloze_answers`: Tokens für Lückentextfragen.
- `attempts` / `attempt_answers`: Ergebnis‑ und Antwortdaten.
- `config`: Platzhalter‑Schwellen für Progression.

## Verbindungen
- JDBC‑DAOs (`UserDao`, `QuestionRepository`, `AnswerDao`, `ClozeTokenDao`, `AttemptDao`) greifen auf diese Tabellen zu.
- `db/seeds.sql` setzt Startdaten auf Basis dieses Schemas.
