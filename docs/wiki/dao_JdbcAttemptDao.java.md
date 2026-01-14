# dao/JdbcAttemptDao.java

Einfache Erklärung: Hier steht der SQL‑Code, der Testversuche und Antworten in die Datenbank schreibt.

## Zweck
JDBC‑Implementierung für Testversuche und Antworten.

## Inhalt & Verantwortung
- Insert in `attempts` und `attempt_answers`.

## Verbindungen
- Nutzt `DbConnectionManager`.
- Genutzt von `TestService`.
