# backend/src/main/resources/db.properties

Einfache Erklärung: Das ist die Konfigurationsdatei für die Datenbank. Wenn du Benutzername, Passwort oder Host änderst, machst du das hier – der Code bleibt gleich.

## Zweck
Zentrale Konfiguration der Datenbankverbindung (JDBC). Diese Datei erlaubt Anpassung je Deployment, ohne Code zu ändern.

## Inhalt & Verantwortung
- `db.url` bestimmt die JDBC‑URL (Postgres lokal / optional MS SQL für Uni‑Server).
- `db.user`, `db.password` sind Zugangsdaten.
- `db.pool.maxSize` steuert die Pool‑Größe.

## Verbindungen
- `DbConnectionManager` liest diese Datei beim Start.

**Aktueller Default im Repo:**
`jdbc:postgresql://localhost:5433/wissentest`
(Port 5433, passend zum Start‑Skript)
- Alle JDBC‑DAOs verwenden indirekt die DataSource aus `DbConnectionManager`.
