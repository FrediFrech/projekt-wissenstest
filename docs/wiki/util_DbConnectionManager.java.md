# util/DbConnectionManager.java

Einfache Erklärung: Diese Datei baut die Datenbankverbindung auf, damit alle DAOs sie nutzen können.

## Zweck
Stellt eine singleton‑artige `DataSource` bereit (HikariCP), die von allen JDBC‑DAOs genutzt wird.

## Inhalt & Verantwortung
- Lädt `db.properties` aus den Ressourcen.
- Konfiguriert HikariCP (URL, User, Passwort, Poolgröße).
- Liefert eine `DataSource` für alle Datenbankzugriffe.

## Verbindungen
- Wird von `JdbcUserDao`, `JdbcQuestionRepository`, `JdbcAnswerDao`, `JdbcClozeTokenDao`, `JdbcAttemptDao` verwendet.
- Liest Konfiguration aus `backend/src/main/resources/db.properties`.
