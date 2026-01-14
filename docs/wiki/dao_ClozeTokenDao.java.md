# dao/ClozeTokenDao.java

Einfache Erklärung: Dieses Interface beschreibt den Zugriff auf Lückentext‑Tokens. Es ist die abstrakte Schicht über der Datenbank.

## Zweck
Schnittstelle für Lückentext‑Tokens.

## Inhalt & Verantwortung
- `create`, `findByQuestion`, `deleteByQuestion`.

## Verbindungen
- Implementiert durch `JdbcClozeTokenDao`.
- Genutzt von `AdminService`/`TestService`.
