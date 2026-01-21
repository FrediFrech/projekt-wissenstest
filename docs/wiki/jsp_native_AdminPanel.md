
# jsp_native/AdminPanel.jsp

## Zweck
Das **Admin Panel** ist die zentrale Verwaltungsstelle f�r Administratoren. Es bietet Funktionen zum Verwalten von Benutzern (Rollen, PW-Resets) und Fragen (CRUD).

## Inhalt & Features
1.  **Dashboard-Statistiken**:
    *   Zeigt Anzahl User, Fragen und durchgef�hrter Tests in Echtzeit an.
2.  **Passwort-Reset-Anfragen**:
    *   Automatisch erscheinende Sektion, wenn User einen Reset angefordert haben.
    *   Erm�glicht das direkte Neusetzen des Passworts durch den Admin.
3.  **Fragen-Management (Table View)**:
    *   Tabellarische Auflistung aller Fragen.
    *   **Erstellen**: Modal-Dialog f�r MC, Cloze, Free und Image Fragen.
        *Hinweis:* DB‑Schema erlaubt aktuell MC/CLOZE. FREE/IMAGE sind UI‑Optionen und brauchen Schema‑Erweiterung.
    *   **Bearbeiten**: Laden existierender Fragen in das Modal.
    *   **L�schen**: Entfernen von Fragen (Datenbank-Constraints werden beachtet).
4.  **Benutzerverwaltung**:
    *   Liste alle Benutzer mit Rollen.
    *   User anlegen, bearbeiten (Passwort/Rolle) und l�schen.

## Technische Details
*   **Technologie**: JSP + Vanilla JS (`app.js` f�r API Calls, Inline-Script f�r View-Logik).
*   **Styling**: CSS-Grid f�r Dashboard-Cards, Modals f�r Formulare.
*   **API-Endpunkte**:
    *   `GET /api/admin/stats`
    *   `GET/POST/PUT/DELETE /api/admin/questions`
    *   `GET/POST/PUT/DELETE /api/admin/users`
    *   `GET /api/admin/users/requests`
