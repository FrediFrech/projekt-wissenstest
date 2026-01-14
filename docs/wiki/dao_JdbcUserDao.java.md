# dao/JdbcUserDao.java

Einfache Erklärung: Diese Datei enthält den echten SQL‑Code für Benutzer. Sie ist wie der Mechaniker, der die Aufgaben aus UserDao praktisch umsetzt.

## Zweck
JDBC‑Implementierung für Benutzerzugriffe.

## Inhalt & Verantwortung
- Speichert Benutzer inkl. Hash+Salt.
- Lädt Benutzer für Login.
- Listet und löscht Benutzer (Admin‑Funktion).

## Verbindungen
- Nutzt `DbConnectionManager`.
- Liefert Daten für `AuthService`.
