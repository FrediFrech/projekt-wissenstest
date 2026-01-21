# web/TestServlet.java

Einfache Erklärung: Dieses Servlet startet Tests und nimmt Antworten entgegen, damit die Auswertung im Backend passiert.

## Zweck
Test‑API für Start und Submit.

## Inhalt & Verantwortung
- `POST /api/test/start` liefert Fragen inkl. MC‑Optionen oder CLOZE‑Tokens.
- `POST /api/test/submit` bewertet + speichert Attempt.
- `GET /api/test/categories` liefert Kategorien.
- `GET /api/test/history` liefert Ergebnis‑Historie.
- `GET /api/test/questions/all` liefert Lern‑Karten.
- Submit payload: `questionIds`, `answers`, `difficulty`, `durationSeconds`.

## Verbindungen
- Nutzt `TestService`.
- Nutzt Session‑UserId (Login erforderlich).
