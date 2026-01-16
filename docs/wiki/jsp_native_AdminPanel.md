# jsp_native/AdminPanel.jsp

## Einfache Erklärung
Für Administratoren reserviert: Diese Seite zeigt Statistiken (wie viele Tests durchgeführt wurden, durchschnittliche Scores) und bietet ein Formular zum Hinzufügen neuer Test-Fragen. Nur angemeldete Admins sehen diese Seite.

## Zweck
Admin-Dashboard mit Statistik-Anzeige und Frage-Management.

## Technologie
- **JSP:** Server-Side mit Session-Check (`session.getAttribute("user")`), Request-Attributen
- **CSS3:** Glasmorphism-Layout, Responsive Grid
- **Vanilla JS:** Formular-Handling, AJAX-Calls zum Backend (via `app.js`), dynamische Statistik-Berechnung

## Inhalt & Verantwortung
### Struktur
- **Statistik-Cards:** Zeigt Metriken wie
  - Gesamtzahl Tests
  - Durchschnittlicher Score
  - Benutzer Online
  - Admin-Name
- **Fragen-Management:** 
  - Formular zum Erstellen neuer Fragen
  - Textfeld für Frage, Radio-Buttons für Typ (Multiple Choice / Cloze)
  - Antwort-Optionen hinzufügen
  - Submit-Button für Backend-Call

### Sicherheit
- Prüfung: Nur wenn User in Session vorhanden ist
- Admin-Flag könnte auf Backend-Seite validiert werden

## Verbindungen
- **Router:** In `native.jsp` über `?page=adminPanel` eingebunden
- **Styling:** `css_native/style.css`
- **JavaScript:** Nutzt Funktionen aus `js_native/app.js`
- **Backend:** AJAX-Calls zu `/api/admin/*` Endpoints (AdminServlet)
- **Frontend-Pendant:** `frondend/src/components/AdminPanel.jsx`

## Wichtige Entscheidungen
- ✅ Server-Side Session-Check in JSP (kein Client-Side nur-JS Prüfung)
- ✅ Vanilla JS für Formular-Handling (keine Form-Libraries)
- ✅ Dynamische Statistik-Cards (generiert via JavaScript)
- ✅ Inline Formulare (Accessibility durch `<label>` & `<input>`-Struktur)

## Workflow
1. Admin loggt sich ein (Session gespeichert)
2. Navigiert zu `?page=adminPanel`
3. Seite zeigt Statistiken aus Mock-Daten oder AJAX-Call
4. Admin füllt Frage-Formular aus
5. Klick "Speichern" → JavaScript sendet POST an `/api/admin/question/create`
6. Backend speichert → Seite aktualisiert
