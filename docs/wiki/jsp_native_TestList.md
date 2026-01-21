# jsp_native/TestList.jsp

## Einfache Erklärung
Das Dashboard: Nach dem Login sieht der Benutzer hier eine Übersicht aller verfügbaren Tests. Jeder Test wird als schöne Karte angezeigt mit Metadaten wie Anzahl der Fragen und Schwierigkeit. Mit einem Klick kann der Benutzer einen Test starten.

## Zweck
**Dashboard / Test-Übersicht:** Listet verfügbare Tests auf und ermöglicht das Starten eines Tests.

## Technologie
- **JSP:** Server-Side Struktur, Session-Check
- **CSS3:** Glass-Panel, Karten-Layout, Hover-Effekte
- **Vanilla JS:** Test-Liste laden via AJAX, Navigation

## Inhalt & Verantwortung
- Session-Check: Nur angemeldete Benutzer sehen diese Seite
- Test-Karten anzeigen mit:
  - Test-Titel
  - Beschreibung (z.B. "10 Fragen • Gemischt")
  - "Starten" Button
- Dynamisches Laden der Test-Liste via `loadTests()` Funktion
- Buttons verlinken zu `?page=testRunner`

## Verbindungen
- **Router:** In `native.jsp` über `?page=testList` eingebunden
- **Styling:** `css_native/style.css`
- **Logik:** `js_native/app.js` (Funktion: `loadTests()`)
- **Backend:** AJAX zu `/api/test/categories` und `/api/test/history`

## Wichtige Entscheidungen
- ✅ Session-basierte Zugriffskontrolle (Server-Side)
- ✅ AJAX-basiertes Laden (keine Page-Reload)
- ✅ Responsive Grid für Tests
- ✅ Einfache Navigation (Links statt Buttons)

## Beispiel-Workflow
```
1. User ist eingeloggt & navigiert zu ?page=testList
2. JSP prüft session.getAttribute("user") - OK
3. JavaScript triggert loadTests()
4. AJAX-Call zu /api/test/categories
5. AJAX-Call zu /api/test/history
6. JavaScript rendert Konfiguration + Historie
7. User klickt "Starten" → navigate zu ?page=testRunner
```
