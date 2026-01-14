# model/QuestionType.java

Einfache Erklärung: Hier werden die möglichen Fragetypen gesammelt (MC und CLOZE), damit überall dieselben Werte genutzt werden.

## Zweck
Enum der Fragetypen im System.

## Inhalt & Verantwortung
- `MC` für Multiple‑Choice.
- `CLOZE` für Lückentext.

## Verbindungen
- Referenziert von `Question`, `JdbcQuestionRepository`, `AdminService`, `TestService`.
