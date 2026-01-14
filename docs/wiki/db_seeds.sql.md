# db/seeds.sql

Einfache Erklärung: Hier stehen Beispiel‑Daten, damit du die App sofort testen kannst. Dazu gehören ein Admin‑User und Demo‑Fragen.

## Zweck
Liefert Startdaten für Entwicklung/Tests: Admin‑User und Beispiel‑Fragen.

## Inhalt & Verantwortung
- Admin‑User: `admin/student` (Hash/Salt als Platzhalter).
- Beispiel‑MC‑Frage + Antwortoptionen.
- Beispiel‑Cloze‑Frage + Token.

## Verbindungen
- Muss nach `db/schema.sql` ausgeführt werden.
- `AuthService` erwartet Hash/Salt aus `users`.
