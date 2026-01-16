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
1. **Title & Timer:** Zeigt Test-Name und verstrichene Zeit
2. **Progress Bar:** Visueller Fortschritt (0%-100%) beim Durchgehen der Fragen
3. **Question Container:**
   - Frage-Text in `<h3>`
   - Answer-Container mit dynamisch generierten Buttons
   - "Nächste Frage" Button
4. **Result View (versteckt):** Wird am Ende eingeblendet
   - Finale Score-Anzeige
   - Note/Bewertung

### Logik (in `js_native/app.js`)
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
- **Logik:** `js_native/app.js` (siehe `initTest()` und Quiz-Funktionen)
- **Backend:** AJAX zu `/api/test/start` für Fragen
- **Frontend-Pendant:** `frondend/src/components/TestRunner.jsx`

## Wichtige Entscheidungen
- ✅ Server-Side HTML + Client-Side JS (kein React Rendering)
- ✅ Fragen via AJAX geladene (effizient)
- ✅ CSS3 Animationen für smooth UX
- ✅ sessionStorage für Ergebnis-Übergabe zu Result.jsp

## Workflow
1. User klickt "Test Starten" auf TestList.jsp
2. JSP lädt, DOMContentLoaded triggert JavaScript
3. `initTest()` holt Fragen von Backend via `/api/test/start`
4. `renderQuestion()` zeigt erste Frage mit Antwort-Buttons
5. User klickt Antwort → `selectAnswer()` speichert & zeigt Feedback
6. User klickt "Nächste Frage" → `nextQuestion()`
   - Wenn mehr Fragen: `renderQuestion()` neu
   - Wenn keine mehr: `finishTest()`
7. `finishTest()` berechnet Score, speichert in sessionStorage
8. Navigiert zu `?page=result`
