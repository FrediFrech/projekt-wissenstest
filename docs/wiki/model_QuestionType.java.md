# model/QuestionType.java

Einfache Erklärung: Hier werden die möglichen Fragetypen gesammelt (MC und CLOZE), damit überall dieselben Werte genutzt werden.

## Zweck
Enum der Fragetypen im System.

## Inhalt & Verantwortung
- `MC` für Multiple‑Choice.
- `CLOZE` für Lückentext.
- `FREE` für Freitext (optional, Schema derzeit nicht aktiv).
- `IMAGE` für Bild‑Fragen (MC mit `image_url`).

## Verbindungen
- Referenziert von `Question`, `JdbcQuestionRepository`, `AdminService`, `TestService`.
