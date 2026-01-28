
## Was ist das?
Das Frontend nutzt nur:
- **JSP** (JavaServer Pages) für die Struktur
- **CSS3** (modernes Flexbox/Grid, Animations) für das "High-End" Design
- **Vanilla JavaScript** (keine Frameworks) für die Logik

##  Komponenten-Struktur (JSP)
Die JSP‑Variante besteht aus einem Router (`index.jsp`/`native.jsp`) und klar getrennten Komponenten unter `jsp_native/`.

### Datei-Mapping
| JSP Datei | Rolle | Beschreibung |
|-----------|------|--------------|
| `index.jsp` | Einstieg | Startseite (Welcome File) |
| `native.jsp` | Router | Routing über `?page=` |
| `jsp_native/LandingPage.jsp` | Page | Startseite |
| `jsp_native/Login.jsp` | Form | Login |
| `jsp_native/Register.jsp` | Form | Registrierung |
| `jsp_native/TestList.jsp` | Page | Test‑Dashboard |
| `jsp_native/TestRunner.jsp` | Page | Test‑Ablauf |
| `jsp_native/Result.jsp` | Page | Ergebnis |
| `jsp_native/AdminPanel.jsp` | Page | Admin‑Bereich |
| `jsp_native/LearnMode.jsp` | Page | Lernmodus |
| `jsp_native/FlipCard.jsp` | Fragment | Karteikarte |
| `jsp_native/ExamMode.jsp` | Page | Prüfungsmodus |

##  Dateistruktur
Die Dateien liegen in `mainlogik, backend/src/main/webapp/`:
- `native.jsp` – Einstiegspunkt
- `jsp_native/` – Die oben genannten Komponenten
- `css_native/style.css` – High-End Design (Glassmorphism, Gradients)
- `js_native/app.js` – Logik (AJAX Calls zum Java Backend, Routing)

##  Wie nutze ich es?
Du musst nichts bauen oder installieren (kein npm nötig!).
1. Starte den Tomcat Server (Java Backend).
2. Öffne im Browser:
   `http://localhost:8080/wissentest/`
3. Optional: `native.jsp` als direkter Router.

##  Features
Obwohl es "nur" JSP ist, haben wir moderne Features eingebaut:
- **Animationen:** Fade-Ins, Slide-Downs beim Laden (CSS Keyframes)
- **Glassmorphism:** Durchscheinende Karten-Optik
- **Interaktivität:** Tests werden ohne Page-Reload durchgeführt (AJAX)
- **Flip-Cards:** Auch in CSS nachgebaut (siehe Landing Page Demo)
- **Lernmodus-Modal:** „Vergrößern“ zeigt die **Flip-Card groß** im Dialog; Klick dreht die Karte wie im Grid
- **Responsive:** Funktioniert auf Mobile & Desktop

### Lernmodus-Modal (kurz erklärt)
- Klick auf „Vergrößern“ öffnet ein Dialogfenster.
- Das Dialogfenster ist zentriert und zeigt eine **große Flip-Card** (Front/Back).
- Optionales Bild erscheint auf der Vorderseite der Karte.
- Lange Inhalte werden **im Modal** gescrollt – die Seite bleibt im Hintergrund fixiert.

##  Architektur‑Hinweis
Die Seiten werden serverseitig mit JSP gerendert. Dynamik (Tests laden, Antworten senden) läuft über AJAX‑Calls aus `js_native/app.js`.

##  Anpassung
Wenn du Änderungen machen willst:
- GUI: `css_native/style.css`
- Logik: `js_native/app.js`
- Struktur: `jsp_native/*.jsp`

**Tipp:** Der Lernmodus verwendet eigenes CSS im `jsp_native/LearnMode.jsp` für das Modal (Overlay, Scroll-Handling, Karten-Layout).

Damit hast du eine **komplett konforme Lösung** ohne zusätzliche Frontend‑Build‑Schritte.
