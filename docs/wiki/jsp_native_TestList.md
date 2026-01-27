# jsp_native/TestList.jsp

## Einfache Erklärung
Das Dashboard ist die "Schaltzentrale" nach dem Login. Hier stellst du deinen Test zusammen, siehst deine letzten Ergebnisse und kannst direkt starten.

## Zweck
**Dashboard / Test-Übersicht:** Listet verfügbare Tests auf und ermöglicht das Starten eines Tests.

## Technologie
- **JSP:** Server-Side Struktur, Session-Check
- **CSS3:** Glass-Panel, Karten-Layout, Hover-Effekte
- **Vanilla JS:** Test-Liste laden via AJAX, Navigation

## Inhalt & Verantwortung
- **Admin-Karte** (nur für Admins): Link zum Admin Panel
- **Test-Konfiguration**: Kategorie, Anzahl, Schwierigkeit → Start-Button
- **Benutzerdefinierter Test**: Modal mit Mehrfachauswahl von Kategorien und Zeitlimit
- **Historie**: Anzeige der letzten Ergebnisse (Punkte/Prozent)
- Dynamisches Laden via `loadTests()`

## Verbindungen
- **Router:** In `native.jsp` über `?page=testList` eingebunden
- **Styling:** `css_native/style.css`
- **Logik:** `js_native/app_main.js` (Funktion: `loadTests()`, `startConfiguredTest()`, `openCustomTestModal()`)
- **Backend:** AJAX zu `/api/test/categories` und `/api/test/history`

## Wichtige Entscheidungen
- ✅ Session-basierte Zugriffskontrolle (Server-Side)
- ✅ AJAX-basiertes Laden (keine Page-Reload)
- ✅ Responsive Grid für Tests
- ✅ Einfache Navigation (Links statt Buttons)

## Beispiel-Workflow
```
1. User navigiert zu ?page=testList
2. JavaScript triggert loadTests()
3. AJAX-Calls zu /api/test/categories + /api/test/history
4. UI rendert Konfiguration, Historie und (falls Admin) Admin-Karte
5. User klickt "Starten" → navigiert zu ?page=testRunner
6. Optional: "Benutzerdefinierter Test" öffnet Modal, speichert config in localStorage
```
