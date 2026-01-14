# model/AttemptAnswer.java

Einfache Erklärung: Dieses Objekt speichert die Antwort eines Users auf eine bestimmte Frage.

## Zweck
Speichert die Antwort eines Users auf eine konkrete Frage innerhalb eines Versuchs.

## Inhalt & Verantwortung
- `givenAnswer` als Rohtext/JSON‑String.
- `pointsAwarded` als Berechnungsergebnis.

## Verbindungen
- Persistiert via `AttemptDao`.
- Erstellt in `TestService`.
