
# jsp_native/AdminPanel.jsp

## Zweck
Das **Admin Panel** ist die zentrale Verwaltungsstelle für Administratoren. Es bietet Funktionen zum Verwalten von Benutzern (Rollen, PW-Resets) und Fragen (CRUD).

## Inhalt & Features
1.  **Dashboard-Statistiken**:
    *   Zeigt Anzahl User, Fragen und durchgeführter Tests in Echtzeit an.
2.  **Passwort-Reset-Anfragen**:
    *   Automatisch erscheinende Sektion, wenn User einen Reset angefordert haben.
    *   Ermöglicht das direkte Neusetzen des Passworts durch den Admin.
3.  **Fragen-Management (Table View)**:
    *   Tabellarische Auflistung aller Fragen.
    *   **Erstellen**: Modal-Dialog für MC, Cloze, Free und Image Fragen.
    *   **Bearbeiten**: Laden existierender Fragen in das Modal.
    *   **Löschen**: Entfernen von Fragen (Datenbank-Constraints werden beachtet).
4.  **Benutzerverwaltung**:
    *   Liste alle Benutzer mit Rollen.
    *   User anlegen, bearbeiten (Passwort/Rolle) und löschen.

## Technische Details
*   **Technologie**: JSP + Vanilla JS (`app.js` für API Calls, Inline-Script für View-Logik).
*   **Styling**: CSS-Grid für Dashboard-Cards, Modals für Formulare.
*   **API-Endpunkte**:
    *   `GET /api/admin/stats`
    *   `GET/POST/PUT/DELETE /api/admin/questions`
    *   `GET/POST/PUT/DELETE /api/admin/users`
    *   `GET /api/admin/users/requests`
