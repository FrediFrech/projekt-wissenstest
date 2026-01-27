# jsp_native/TestRunner.jsp

## Einfache Erklärung
Das ist das Herzstück der Anwendung – hier läuft der echte Test ab. Die Seite zeigt eine Frage nach der anderen an, der Benutzer klickt auf eine Antwort, und es geht zur nächsten Frage. Am Ende wird das Ergebnis berechnet und angezeigt. Die Fragen kommen vom Java-Backend, die Anzeige passiert mit Vanilla JavaScript.

## Zweck
**Haupt-Quiz-Interface:** Fragen-Rendering, Antwort-Verarbeitung, Progress-Tracking.

## Technologie
- **JSP:** Server-Side Template für das initiale HTML-Gerüst
- **CSS3:** Animationen (Fade-In der Fragen), Progress-Bar, Answer-Cards
- **Vanilla JS:** Komplette Quiz-Logik (renderQuestion, selectAnswer, nextQuestion, finishTest)

## Inhalt & Verantwortung
### Komponenten
1. **Title & Timer:** Zeigt Test-Name und Countdown (Timer läuft pro Test)
2. **Progress Bar:** Visueller Fortschritt (0%-100%) beim Durchgehen der Fragen
3. **Question Container:**
   - Frage-Text in `<h3>`
   - Antwort-Container mit dynamisch generierten Optionen
   - Buttons: **„Nächste Frage“** und **„Test abgeben“**
4. **Result View (Legacy):** HTML-Block vorhanden, Ergebnis wird in der Praxis über `Result.jsp` angezeigt

### Logik (in `js_native/app_main.js`)
```javascript
initTest()          // Startet Quiz, lädt Fragen
renderQuestion()    // Zeigt aktuelle Frage + Optionen
selectAnswer()      // Speichert gewählte Antwort
nextQuestion()      // Zur nächsten Frage oder beende Test
finishTest()        // Test abschließen & zu Result.jsp navigieren
```

## Verbindungen
- **Router:** In `native.jsp` über `?page=testRunner` eingebunden
- **Styling:** `css_native/style.css`
- **Logik:** `js_native/app_main.js` (siehe `initTest()` und Quiz-Funktionen)
- **Backend:** AJAX zu `/api/test/start` (POST, inkl. difficulty/limit/category)

## Wichtige Entscheidungen
- ✅ Server-Side HTML + Client-Side JS (kein Framework‑Rendering)
- ✅ Fragen via AJAX geladene (effizient)
- ✅ CSS3 Animationen für smooth UX
- ✅ localStorage für Test‑Konfiguration
- ✅ sessionStorage für Ergebnis‑Übergabe zu Result.jsp
- ✅ Abbrechen-Button mit Bestätigungsdialog (`cancelTest()`)

## Workflow
1. User klickt "Starten" auf TestList.jsp
2. `initTest()` holt Fragen via `/api/test/start`
3. `renderQuestion()` zeigt Frage + Antworten
4. User wählt eine Antwort → `selectAnswer()`
5. User klickt "Nächste Frage" → `nextQuestion()`
6. Am Ende oder per "Test abgeben" → `finishTest()`
7. Ergebnis wird in `sessionStorage.lastTestResult` gespeichert
8. Redirect zu `?page=result`
