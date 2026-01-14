# frondend/src/components/AdminPanel.jsx

Einfache Erklärung: Der Admin‑Bereich, um Fragen zu erstellen, zu bearbeiten und Nutzer zu verwalten.

## Zweck
Einfache Admin‑UI für Fragenliste und Erstellung.

## Inhalt & Verantwortung
- Ruft `GET /api/admin/questions`, `POST /api/admin/questions` und `PUT /api/admin/questions`.
- Ruft `GET /api/admin/users` und `DELETE /api/admin/users?id=...`.

## Einfache Nutzung
Du kannst eine Frage aus der Liste auswählen, bearbeiten und speichern. Dadurch wird die Frage im Backend aktualisiert.

## Verbindungen
- Backend: `AdminServlet` + `AdminService`.
- Nutzt `apiClient.js`.
