
# jsp_native/AdminPanel.jsp

## Zweck
Das **Admin Panel** ist die zentrale Verwaltungsstelle f&uuml;r Administratoren. Es vereint Benutzer-Management, Fragenpflege und System-Statistiken in einer Seite.

## Inhalt & Features
1. **Dashboard-Statistiken**
   - Zeigt Anzahl User, Fragen und durchgef&uuml;hrter Tests in Echtzeit.
2. **Passwort-Reset-Anfragen**
   - Automatisch erscheinende Sektion, wenn User einen Reset angefordert haben.
   - Direkter Einstieg in den Bearbeiten-Dialog (Reset als erledigt markieren).
3. **Fragen-Management (Tabelle + Filter)**
   - Tabellarische Auflistung aller Fragen inkl. **Optionen-Anzahl**.
   - **Sortieren** nach ID, Prompt, Kategorie, Typ, Schwierigkeit oder Optionen.
   - **Filtern** mit Wildcard `*` auf Prompt/Kategorie (z.&nbsp;B. `*uml*`, `uml*`, `*diagramm`).
   - Typ- und Schwierigkeits-Filter f&uuml;r schnelle Eingrenzung.
4. **Fragen erstellen/bearbeiten**
   - Typen: **MC**, **CLOZE**, **FREE**, **IMAGE**.
   - **MC/IMAGE**: richtige Antworten mit `*` markieren.
   - **FREE**: mehrere korrekte L&ouml;sungen per Komma oder neue Zeile.
   - **CLOZE**: JSON-Array mit Alternativen (z.&nbsp;B. `[ ["Sequenz","Sequenzdiagramm"], ["Zeit"] ]`).
   - **Bild-Frage**: Upload per Drag &amp; Drop oder Dateiauswahl, optional URL.
5. **Benutzerverwaltung**
   - Liste aller Benutzer mit Rollen.
   - **Sortieren** nach Username/Rolle/ID.
   - **Filtern** per Wildcard `*` auf Username.
   - User anlegen, bearbeiten (Passwort/Rolle) und l&ouml;schen.

## Technische Details
- **Technologie**: JSP + Vanilla JS (Inline-Scripts f&uuml;r View-Logik).
- **Styling**: CSS-Grid f&uuml;r Dashboard-Cards, Modals f&uuml;r Formulare.
- **API-Endpunkte**:
  - `GET /api/admin/stats`
  - `GET/POST/PUT/DELETE /api/admin/questions`
  - `POST /api/admin/images` (Bild-Upload)
  - `GET/POST/PUT/DELETE /api/admin/users`
  - `GET /api/admin/users/requests`
