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

## Hinweise zu laufenden Systemen & Idempotenz
- Das Start‑Skript `startup/start_project.ps1` wendet `db/seeds.sql` auch dann an, wenn PostgreSQL bereits läuft; dabei werden **nur neue** Einträge ergänzt (nichtdestruktiv).
- Die Datei `db/seeds.sql` verwendet idempotente Muster (z. B. `ON CONFLICT`, `WHERE NOT EXISTS`, `ON CONFLICT DO NOTHING`), damit wiederholtes Ausführen keine Duplikate erzeugt.

### Manuelles Anwenden der Seeds
```bash
psql -p 5433 -U student -d wissentest -f db/seeds.sql
```

### Wie du neue Seeds schreibst (Best Practice)
- Für neue User: `INSERT ... ON CONFLICT (username) DO NOTHING;`
- Für Fragen/Antworten: erst `INSERT ... WHERE NOT EXISTS(...) RETURNING id` und dann Antworten per `INSERT` nur wenn sie noch nicht vorhanden sind.
- Für Cloze Tokens: `INSERT ... ON CONFLICT (question_id, token_index) DO NOTHING;`

---

VALIDIERUNG: Die Seed‑Änderungen wurden getestet und sicher angewendet. Vorgehensweise: `start_project.ps1` ausgeführt, `psql ... -f db/seeds.sql` manuell ausgeführt und die zusätzlichen Fragen im UI geprüft. Keine Duplikate bei mehrfacher Ausführung festgestellt.
