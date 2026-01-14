# dao/AnswerDao.java

Einfache Erklärung: Diese Schnittstelle beschreibt, wie Antwortoptionen gespeichert und geladen werden. Damit bleibt die Logik sauber getrennt von SQL.

## Zweck
Schnittstelle für Multiple‑Choice‑Antwortoptionen.

## Inhalt & Verantwortung
- `create`, `findByQuestion`, `deleteByQuestion`.

## Verbindungen
- Implementiert durch `JdbcAnswerDao`.
- Genutzt von `AdminService`/`TestService`.
