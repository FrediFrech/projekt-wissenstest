# Projektübersicht – Projekt Wissenstest

## Kurzbeschreibung
Web‑basierte Lernplattform für UML‑Wissenstests. Server‑Rendering mit JSP, Logik in Java‑Servlets, Daten in PostgreSQL.

## Login‑Daten (Seeds)
- **Student:** `student` / `student`
- **Admin:** `lehrer` / `student`

## Kernfunktionen
### Für Schüler
- Registrierung & Login
- Tests starten (MC & CLOZE)
- Ergebnisse & Historie
- Lernmodus mit Flip‑Cards
- Prüfungsmodus mit Bestehensgrenze (Prozent/Punkte)

### Für Admins
- Fragen anlegen/ändern/löschen
- Benutzer verwalten (inkl. Passwort‑Reset)
- Statistiken (User/Fragen/Attempts)
- Sortieren/Filtern im Admin‑Panel (Wildcard `*`, Schwierigkeit, Typ)

## Architektur (Schichten)
1. **Web/Servlets** – Request/Response, Session
2. **Service** – Business‑Logik
3. **DAO/Repository** – JDBC‑Zugriff
4. **Model** – Datenobjekte

## Projektstruktur (Kurz)
```
mainlogik, backend/
  src/main/java/de/dhsn/wissentest/
    web/       # Servlets
    service/   # Business‑Logik
    dao/       # JDBC
    model/     # Datenobjekte
    util/      # Helper
  src/main/webapp/
    index.jsp
    native.jsp
    jsp_native/     # JSP‑Komponenten
    css_native/     # Styles
    js_native/      # Frontend‑Logik
db/
  schema.sql
  seeds.sql
```

## Datenbank (Kurz)
Tabellen: `users`, `questions`, `answers`, `cloze_answers`, `attempts`, `attempt_answers`, `config`.

## Tech‑Stack
- Java 17
- Servlet API
- PostgreSQL + JDBC + HikariCP
- JSP + Vanilla JS
- Maven
- JUnit 5

## Tests
- JUnit‑Tests im Backend (z.B. `ProgressionServiceTest`)
- E2E‑Tests optional unter `e2e_tests/`
    *   **Login (Admin)**: `lehrer` / `student`
    *   **Test-Suite**: Nutzt Playwright f�r E2E-Tests.

##  Projektbeschreibung
Das **Projekt Wissenstest** ist eine web-basierte Lernplattform, die Sch�lern erm�glicht, ihr Wissen durch automatisierte Tests zu �berpr�fen. Die Plattform bietet verschiedene Fragetypen (Multiple Choice, L�ckentext), adaptive Schwierigkeitsanpassung und detailliertes Feedback. Administratoren k�nnen Tests verwalten, Fragen erstellen und Passwort-Reset-Anfragen bearbeiten.

##  Kernfunktionalit�t

### F�r Sch�ler
- **Benutzerverwaltung:** Registrierung, Login, Profilinformationen, Passwort-Reset (Anfrage).
- **Test-Durchf�hrung:** Zuf�llige Frageauswahl, verschiedene Fragetypen.
- **Echtzeit-Bewertung:** Sofortiges Feedback zu jeder Antwort.
- **Notenberechnung:** Automatische Umrechnung der Punkte in Schulnoten (1-6).
- **Lernmodus:** Interaktive Flip-Cards zum �ben und Wiederholen.
- **Fortschrittsanzeige:** Tracking von Testergebnissen.

### F�r Administratoren
- **Fragenverwaltung:** CRUD-Operationen f�r Test-Fragen (Listen, Erstellen, Bearbeiten, L�schen).
- **Nutzerverwaltung:** Verwaltung von Sch�lern (aktiv/inaktiv) und Rollenzuweisung.
- **Passwort-Reset:** Bearbeitung von Reset-Anfragen mit Neusetzung des Passworts.
- **Statistiken:** Einsicht in Lernergebnisse und System-KPIs.

---

##  Architektur-�bersicht

