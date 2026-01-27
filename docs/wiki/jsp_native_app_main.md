# js_native/app_main.js

## Einfache Erklärung
Dies ist das "Gehirn" der JSP-Native-Version. Diese JavaScript-Datei kümmert sich um alle dynamischen Aufgaben: Login, Tests laden, Fragen anzeigen, Antworten speichern, zur nächsten Frage navigieren und Ergebnisse anzeigen.

## Zweck
**Zentrales Business-Logic & Event-Handling Script** für die JSP-Frontend-Version.

## Technologie
- **Vanilla JavaScript:** Keine Frameworks, reine ES6
- **Fetch API:** Für HTTP-Requests zum Backend (AJAX)
- **DOM-Manipulation:** `document.getElementById`, `innerHTML`, `addEventListener`
- **localStorage / sessionStorage:** Kleine Zustände zwischen Seiten (z. B. Test-Konfig)

## Inhalt & Verantwortung

### 1. **State Management**
```javascript
let currentUser = null;              // Aktuelle Login-Info
let currentQuestions = [];           // Fragen aus Test
let currentQuestionIndex = 0;        // Welche Frage angezeigt
let userAnswers = {};                // Antworten des Users speichern
```

### 2. **API Helper**
- `apiCall(endpoint, method, body)`: Einheitlicher Fetch-Wrapper
  - GET/POST/PUT/DELETE
  - JSON-Handling
  - Error-Handling

### 3. **Auth-Funktionen**
- `handleLogin(event)`: Login-Form verarbeiten
  - Liest Username/Password aus Form
  - POST zu `/api/auth/login`
  - Navigiert nach Success zu `?page=testList`
- `logout()`: Beendet Session & navigiert zu Landing

### 4. **Test-Verwaltung**
- `loadTests()`: Holt Kategorien + Historie vom Backend
  - Zeigt Konfiguration + letzte Ergebnisse
- `initTest()`: Startet einen Test
  - POST zu `/api/test/start`
  - Rendert erste Frage
- `renderQuestion()`: Zeigt aktuelle Frage mit Optionen
  - Animiert Antwort-Buttons
  - Speichert User-Input bei Click

**Hinweis zur Konfiguration:**
- `localStorage.testConfig` speichert u. a. Kategorie(n), Schwierigkeit, Anzahl Fragen, Zeitlimit.
- Im Prüfungsmodus werden zusätzlich **Bestehensgrenzen** gespeichert:
  - `passThresholdType`: `percent` oder `points`
  - `passThresholdValue`: z. B. `60` oder `12`

### 5. **Test-Logik**
- `selectAnswer(id, answer, element)`: Speichert gewählte Antwort
  - Visuelles Feedback (Border-Highlight)
- `nextQuestion()`: Zur nächsten Frage
  - Überprüft, ob Antwort gewählt
  - Rendert neue Frage oder beendet Test
- `finishTest()`: Test abschließen
  - Speichert Ergebnis in sessionStorage
  - Navigiert zu `?page=result`

### 6. **Auto-Init**
```javascript
document.addEventListener('DOMContentLoaded', () => {
  const page = new URLSearchParams(window.location.search).get('page');
  if (page === 'testRunner') initTest();
  else if (page === 'testList') loadTests();
});
```

## Verbindungen
- **HTML:** Alle JSP-Seiten (`TestRunner.jsp`, `TestList.jsp`, etc.) laden diese Datei
- **Backend:** Alle AJAX-Calls zu `/api/auth/*`, `/api/test/*`, `/api/admin/*`
- **localStorage:** Test-Konfiguration (`testConfig`, inkl. Bestehensgrenze im Prüfungsmodus)
- **sessionStorage:** Ergebnis (`lastTestResult`)

## Wichtige Entscheidungen
- ✅ Vanilla JS (kein React, kein jQuery)
- ✅ Fetch API statt XMLHttpRequest (modern)
- ✅ Einfache State-Variablen statt Redux/Zustand
- ✅ localStorage für Test-Konfiguration
- ✅ sessionStorage für Ergebnisdaten
- ✅ Inliners Event-Handler im HTML (onclick=...) für Einfachheit

## Code-Architektur
```
API Helper
  ↓
Auth Logik (Login/Logout)
  ↓
Test Management (Load/Init/Start)
  ↓
Test Rendering (Show Questions/Answers)
  ↓
Test Completion (Finish/Result)
  ↓
Auto-Init on Page Load
```

## Beispiel-Flow: Ein Test durchlaufen
```
1. User klickt "Test Starten" auf TestList.jsp
   → navigate zu ?page=testRunner
2. DOMContentLoaded Event triggert
   → if (page === 'testRunner') initTest()
3. initTest() fetcht Questions vom Backend
4. renderQuestion() zeigt erste Frage
5. User klickt Antwort
   → selectAnswer() speichert + Visual Feedback
6. User klickt "Nächste"
   → nextQuestion() → renderQuestion() neue Frage
7. Letzter Question beantwortet
   → finishTest()
   → Ergebnis in sessionStorage
   → navigate zu ?page=result
8. Result.jsp liest sessionStorage & zeigt Score
```

## Performance-Hinweise
- ✅ Minimales DOM-Manipulation
- ✅ Keine Loop-Animationen (nur CSS Transitions)
- ✅ AJAX-Calls gebündelt (nicht pro Frage)
- ✅ Event-Delegation nur bei Bedarf
