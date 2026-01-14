# dao/UserDao.java

Einfache Erklärung: Dieses Interface ist die "Liste der Aufgaben" für Benutzer in der Datenbank. Andere Klassen nutzen diese Aufgaben, ohne zu wissen, wie SQL genau funktioniert.

## Zweck
Definiert die Schnittstelle für Benutzer‑Persistenz.

## Inhalt & Verantwortung
- `create`, `findByUsername`, `findById`.
- `findAll`, `delete` für Admin‑User‑Management.

## Verbindungen
- Implementiert durch `JdbcUserDao`.
- Genutzt von `AuthService`.
