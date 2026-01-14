# web/AdminServlet.java

Einfache Erklärung: Dieses Servlet ist die Admin‑Zentrale. Es gibt eine Liste der Fragen/Benutzer und kann Fragen ändern oder löschen.

## Zweck
Admin‑API für Fragen‑CRUD.

## Inhalt & Verantwortung
- `GET /api/admin/questions` (Liste inkl. Optionen/Tokens)
- `POST /api/admin/questions` (Create)
- `PUT /api/admin/questions` (Update)
- `DELETE /api/admin/questions?id=...`
- `GET /api/admin/users` (User‑Liste)
- `DELETE /api/admin/users?id=...`
- Rollenprüfung (admin).

## Verbindungen
- Nutzt `AdminService`, `QuestionRepository`, `AnswerDao`, `ClozeTokenDao`.
