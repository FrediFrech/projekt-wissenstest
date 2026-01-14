# service/TestService.java

Einfache Erklärung: Diese Klasse startet Tests, bewertet Antworten und speichert die Ergebnisse.

## Zweck
Teststart, Bewertung und Speicherung der Ergebnisse.

## Inhalt & Verantwortung
- `startTest`: lädt Fragen nach Schwierigkeit.
- `submitAttempt`: bewertet Antworten (über `questionIds`), speichert Attempt.
- Scoring: MC über Teilwerte, CLOZE über Token‑Match.

## Verbindungen
- Nutzt `QuestionRepository`, `AnswerDao`, `ClozeTokenDao`, `AttemptDao`.
- Aufgerufen von `TestServlet`.
