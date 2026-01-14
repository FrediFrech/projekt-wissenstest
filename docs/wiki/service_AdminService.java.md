# service/AdminService.java

Einfache Erklärung: Diese Klasse ist die Logik für Admins. Sie legt Fragen an oder ändert sie.

## Zweck
Zentrale Logik für Admin‑Fragenanlage (MC und CLOZE).

## Inhalt & Verantwortung
- Erstellt Fragen + Antwortoptionen oder Cloze‑Tokens.
- Aktualisiert Fragen inkl. Austausch der Options/Tokens.

## Verbindungen
- Nutzt `QuestionRepository`, `AnswerDao`, `ClozeTokenDao`.
- Aufgerufen von `AdminServlet`.
