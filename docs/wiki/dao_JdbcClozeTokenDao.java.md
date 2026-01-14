# dao/JdbcClozeTokenDao.java

Einfache Erklärung: Diese Datei führt SQL‑Befehle für Lückentext‑Tokens aus, damit sie gespeichert und geladen werden können.

## Zweck
JDBC‑Implementierung für Lückentext‑Tokens.

## Inhalt & Verantwortung
- Speichert/Lädt Tokens für CLOZE‑Fragen.

## Verbindungen
- Nutzt `DbConnectionManager`.
- Genutzt von `AdminService`/`TestService`.
