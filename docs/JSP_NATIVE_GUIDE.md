# Native JSP/HTML5 Frontend - Die "Safe Alternative"

Wenn dir React zu riskant erscheint (wegen strenger Dozenten-Anforderungen), haben wir eine **vollständig JSP-konforme Alternative** gebaut.

## 🛡️ Was ist das?
Das ist ein separates Frontend, das **OHNE React** auskommt. Es nutzt nur:
- **JSP** (JavaServer Pages) für die Struktur
- **CSS3** (modernes Flexbox/Grid, Animations) für das "High-End" Design
- **Vanilla JavaScript** (keine Frameworks) für die Logik

## � 1:1 Spiegelung der React Architektur
Um die technische Raffinesse zu beweisen, haben wir **für jede React-Komponente ein exaktes JSP-Pendant** erstellt. Die Struktur ist identisch, nur die Technologie ist simpler (konformer).

### Datei-Mapping
| React Komponente (Modern) | JSP Pendant (Native) | Beschreibung |
|---------------------------|----------------------|--------------|
| `App.jsx` | `native.jsp` | Haupt-Controller / Router |
| `src/main.jsx` | `js_native/app.js` | App-Initialisierung & Logik |
| `LandingPage.jsx` | `LandingPage.jsp` | Startseite mit Animationen |
| `Login.jsx` | `Login.jsp` | Login-Formular |
| `Register.jsx` | `Register.jsp` | Registrierungs-Formular |
| `TestList.jsx` | `TestList.jsp` | Dashboard / Übersicht der Tests |
| `TestRunner.jsx` | `TestRunner.jsp` | Der eigentliche Quiz-Ablauf |
| `Result.jsx` | `Result.jsp` | Ergebnisanzeige nach dem Test |
| `AdminPanel.jsx` | `AdminPanel.jsp` | Admin-Bereich (Statistiken) |
| `LearnMode.jsx` | `LearnMode.jsp` | Lernmodus (Karteikarten) |
| `FlipCard.jsx` | `FlipCard.jsp` | Einzelne Karteikarte (Fragment) |

## 📂 Dateistruktur
Die Dateien liegen in `mainlogik, backend/src/main/webapp/`:
- `native.jsp` – Einstiegspunkt
- `jsp_native/` – Die oben genannten Komponenten
- `css_native/style.css` – High-End Design (Glassmorphism, Gradients)
- `js_native/app.js` – Logik (AJAX Calls zum Java Backend, Routing)

## 🚀 Wie nutze ich es?
Du musst nichts bauen oder installieren (kein npm nötig!).
1. Starte den Tomcat Server (Java Backend).
2. Öffne im Browser:
   `http://localhost:8080/wissentest/native.jsp`

*(Die React-Version läuft parallel unter `/index.jsp`, diese hier ist `/native.jsp`)*

## ✨ Features
Obwohl es "nur" JSP ist, haben wir moderne Features eingebaut:
- **Animationen:** Fade-Ins, Slide-Downs beim Laden (CSS Keyframes)
- **Glassmorphism:** Durchscheinende Karten-Optik
- **Interaktivität:** Tests werden ohne Page-Reload durchgeführt (AJAX)
- **Flip-Cards:** Auch in CSS nachgebaut (siehe Landing Page Demo)
- **Responsive:** Funktioniert auf Mobile & Desktop

## ⚖️ Unterschied zur React-Version

| Feature | React Version (`index.jsp`) | Native JSP Version (`native.jsp`) |
|---------|---------------------------|-----------------------------------|
| Technologie | React 18, Vite | JSP, HTML5, Vanilla JS |
| Architektur | Single Page App (SPA) | JSP Includes + AJAX |
| Konformität | Grauzone (Modern) | ✅ 100% Konform (Formal) |
| Animationen | Framer Motion (Library) | CSS3 Transitions (Native) |
| Performance | Client-Side Rendering | Server-Side Rendering + JS |
| Sicherheit | Höheres Risiko beim Dozenten | "Safe Bet" |

## 🛠️ Anpassung
Wenn du Änderungen machen willst:
- GUI: `css_native/style.css`
- Logik: `js_native/app.js`
- Struktur: `jsp_native/*.jsp`

Damit hast du eine **perfekte Fallback-Lösung**, falls der Dozent React ablehnt. Du kannst einfach auf die URL `/native.jsp` verweisen und hast ein komplett konformes Projekt.
