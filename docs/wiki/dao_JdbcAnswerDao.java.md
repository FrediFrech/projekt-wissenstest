# dao/JdbcAnswerDao.java

Einfache Erklärung: Hier steht der SQL‑Code für Antwortoptionen. Die Service‑Klassen rufen nur Methoden auf, statt SQL zu schreiben.

## Zweck
JDBC‑Implementierung für MC‑Antworten.

## Inhalt & Verantwortung
- Speichert und lädt Antwortoptionen für MC.

## Verbindungen
- Nutzt `DbConnectionManager`.
- Genutzt von `AdminService`/`TestService`.
