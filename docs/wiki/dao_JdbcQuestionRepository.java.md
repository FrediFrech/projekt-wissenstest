# dao/JdbcQuestionRepository.java

Einfache Erklärung: Diese Datei enthält die SQL‑Befehle für Fragen. Sie liest und schreibt Fragen in der Tabelle `questions`.

## Zweck
Diese Klasse enthält den konkreten SQL‑Zugriff für Fragen und ist die Haupt‑Implementierung des Repositories.

## Inhalt & Verantwortung
- SQL‑Statements für `questions` (Create, Update, Delete, Find).
- Rückgabe von `Question`‑Objekten.

## Verbindungen
- Nutzt `DbConnectionManager`.
- Wird von `AdminService` und `TestService` verwendet.
