# Verbindungen und Zusammenspiel der Dateien

Einfache Erklärung: Diese Übersicht erklärt, wie Frontend, Backend, Services und Datenbank zusammenarbeiten. So siehst du schnell, welche Datei was mit welcher anderen Datei zu tun hat.

Dieser Text erklärt in einfachen Worten, wie die Dateien zusammenarbeiten.

## 1) Frontend → Backend
- Die JSP‑Seiten rufen über `js_native/app.js` HTTP‑Endpunkte unter `/api/...` auf.
- Diese Endpunkte sind in `web.xml` mit Servlets verbunden (`AuthServlet`, `AdminServlet`, `TestServlet`).

## 2) Servlet‑Schicht → Service‑Schicht
- Die Servlets parsen JSON‑Eingaben und rufen die passenden Services auf.
- `AuthServlet` → `AuthService`
- `AdminServlet` → `AdminService`
- `TestServlet` → `TestService`

## 3) Service‑Schicht → Datenbank‑Schicht
- Services arbeiten mit Repositories/DAOs, die SQL ausführen.
- `AdminService` nutzt `QuestionRepository`, `AnswerDao`, `ClozeTokenDao`.
- `TestService` nutzt `QuestionRepository`, `AnswerDao`, `ClozeTokenDao`, `AttemptDao`.
- `AuthService` nutzt `UserDao`.

## 4) Datenbank‑Schicht → Schema
- Alle DAOs greifen auf Tabellen aus `db/schema.sql` zu.
- Startdaten werden über `db/seeds.sql` erzeugt.

## 5) Konfiguration
- `db.properties` liefert Datenbank‑Zugangsdaten, die `DbConnectionManager` liest.
- `pom.xml` steuert Build und Abhängigkeiten.

Damit entsteht eine klare Trennung: UI (Frontend) → HTTP → Services → Datenbank.
