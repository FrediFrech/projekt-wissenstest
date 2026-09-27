# Tests

Das Projekt hat zwei Testebenen: Unit-Tests für die Backend-Logik mit JUnit 5 und End-to-End-Tests für komplette Abläufe im Browser mit Playwright.

## Unit-Tests (JUnit 5)

```bash
cd "mainlogik, backend"
mvn test
```

Die Tests laufen ohne Datenbank. Die Services bekommen stattdessen einfache In-Memory-Implementierungen der DAO-Interfaces (z. B. `InMemoryUserDao`), die direkt in den Testklassen stehen. `TestUtils` liefert Zufallswerte wie eindeutige Benutzernamen und E-Mail-Adressen.

| Testklasse | prüft |
|---|---|
| `AuthServiceTest` | Registrierung mit gehashtem Passwort, Ablehnung falscher Passwörter, Reset-Anfrage |
| `ProgressionServiceTest` | Schwellenwerte für Auf- und Abstieg im Auto-Modus |
| `TestServiceTest` | Fragenauswahl nach Kategorie und Schwierigkeit, volle Punkte bei richtiger und 0 Punkte bei falscher MC-Antwort |
| `PasswordUtilsTest` | Salt-Erzeugung, reproduzierbares Hashing |
| `AdminServletImageUtilsTest` | Erkennung von Bilddateien und Content-Types |

## End-to-End-Tests (Playwright)

Die E2E-Tests steuern einen echten Browser gegen die laufende Anwendung. Tomcat muss also auf Port 8080 laufen.

```bash
cd "mainlogik, backend/e2e_tests"
npm install
npx playwright test
```

Abgedeckte Abläufe in `tests/full_workflow.spec.js`:

- Admin legt Fragen an und verwaltet sie.
- Admin blendet eine Frage im Lernmodus aus (`learnEnabled`), die Frage verschwindet dort.
- Passwort-Reset: Anfrage stellen, Admin setzt neues Passwort, Login mit dem neuen Passwort.

## Diese Dokumentation prüfen

Auch das Handbuch wird automatisch geprüft: Der Workflow baut die Seite bei jedem Pull Request mit `mkdocs build --strict`. Defekte interne Links oder fehlende Seiten brechen den Build ab. Mehr dazu unter [Über diese Doku](../ueber-diese-doku.md).
