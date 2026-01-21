# model/User.java

Einfache Erklärung: Dieses Objekt beschreibt einen Benutzer (Name, Rolle, Passwort‑Hash). Es ist einfach ein Daten‑Behälter, keine Logik.

## Zweck
Domänenmodell für Benutzer.

## Inhalt & Verantwortung
- Identität, Login‑Daten (Hash+Salt), Rolle (admin/student), Reset‑Flag.

## Verbindungen
- Persistiert via `UserDao`.
- Genutzt in `AuthService` und `AuthServlet` (Session‑Handling).
