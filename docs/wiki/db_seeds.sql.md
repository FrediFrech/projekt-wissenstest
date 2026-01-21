# db/seeds.sql

Einfache Erklärung: Hier stehen Beispiel‑Daten, damit du die App sofort testen kannst. Dazu gehören ein Admin‑User und Demo‑Fragen.

## Zweck
Liefert Startdaten für Entwicklung/Tests: Admin‑User und Beispiel‑Fragen.

## Inhalt & Verantwortung
- Users: `student`, `lehrer`, `teacher2`, `student2` (Passwort: `student`)
- Beispiel‑MC‑Fragen + Antwortoptionen.
- Beispiel‑Cloze‑Fragen + Token.

## Verbindungen
- Muss nach `db/schema.sql` ausgeführt werden.
- `AuthService` erwartet Hash/Salt aus `users`.
