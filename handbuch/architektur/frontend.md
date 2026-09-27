# Frontend

Die Oberfläche kommt ohne Frontend-Framework und ohne eigenen Build-Schritt aus. Sie besteht aus JSP-Seiten, einer CSS-Datei und einer JavaScript-Datei. Alles liegt unter `mainlogik, backend/src/main/webapp/` und wird mit der WAR-Datei ausgeliefert.

## Routing

Es gibt genau einen Einstiegspunkt: `index.jsp` (Welcome-File, identisch aufgebaut ist `native.jsp`). Welche Seite erscheint, bestimmt der URL-Parameter `page`. Der Router bindet die passende Komponente per `<jsp:include>` ein und liest dabei Anmeldestatus und Rolle aus der Sitzung.

| `?page=` | Komponente | Inhalt |
|---|---|---|
| `landingPage` (Standard) | `LandingPage.jsp` | Startseite mit Einstieg zu Login und Registrierung |
| `login` | `Login.jsp` | Anmeldung, Dialog „Passwort vergessen“ |
| `register` | `Register.jsp` | Registrierung mit Passwort-Bestätigung |
| `testList` | `TestList.jsp` | Dashboard mit Testkonfiguration und Historie |
| `testRunner` | `TestRunner.jsp` | Testdurchführung mit Timer und Fortschritt |
| `result` | `Result.jsp` | Ergebnis, Note, Details je Frage |
| `examMode` | `ExamMode.jsp` | Prüfungskonfigurator |
| `learnMode` | `LearnMode.jsp` | Karteikarten, nutzt die Struktur aus `FlipCard.jsp` |
| `adminPanel` | `AdminPanel.jsp` | Verwaltung; ohne Admin-Rolle stattdessen `AccessDenied.jsp` |

Alle Komponenten liegen im Ordner `jsp_native/`.

## JavaScript

`js_native/app_main.js` enthält den Großteil der Client-Logik. Einige Komponenten bringen eigene Skripte mit, etwa `Register.jsp`, `LearnMode.jsp`, `ExamMode.jsp` und `AdminPanel.jsp`.

- **`apiCall()`** kapselt `fetch` für alle Aufrufe an `/api/…` inklusive Fehlerbehandlung.
- **Anmeldung:** `handleLogin()` und die Reset-Anfrage; die Registrierung (`handleRegister()`) liegt in `Register.jsp`
- **Dashboard:** `loadTests()` lädt Kategorien und Historie, `startConfiguredTest()` und der Dialog für benutzerdefinierte Tests speichern die Konfiguration.
- **Test:** `initTest()`, `renderQuestion()`, `selectAnswer()`, `nextQuestion()`, `finishTest()`, `cancelTest()`
- **Lernmodus:** `loadLearnCards()` in `LearnMode.jsp` erzeugt die Karteikarten.

Zwischen den Seiten werden Daten im Browser übergeben:

| Speicher | Schlüssel | Inhalt |
|---|---|---|
| `localStorage` | `testConfig` | gewählte Testkonfiguration, im Prüfungsmodus inkl. Bestehensgrenze |
| `sessionStorage` | `lastTestResult` | Ergebnis vom Server für die Ergebnisseite |
| `sessionStorage` | `isExamMode` | Markierung, dass ein Prüfungsmodus läuft |

Die Datei `js_native/app.js` und der Ordner `static/react/` stammen aus einer früheren Variante mit React-Oberfläche und werden von den aktuellen Seiten nicht mehr geladen.

## Gestaltung

`css_native/style.css` definiert Farben und Abstände als CSS-Variablen und stellt die wiederkehrenden Bausteine bereit: halbtransparente Karten (`glass-card`), Buttons, Formularfelder, Einblend-Animationen und ein responsives Raster. Einzelne Komponenten wie `LearnMode.jsp` bringen zusätzlich eigene Styles mit, etwa für den 3D-Dreheffekt der Karteikarten und den Vergrößern-Dialog.

Die Schrift „Inter“ wird von Google Fonts geladen. Ohne Internetverbindung fällt der Browser auf eine Systemschrift zurück.
