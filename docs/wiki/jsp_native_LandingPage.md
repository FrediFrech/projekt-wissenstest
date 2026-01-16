# jsp_native/LandingPage.jsp

## Einfache Erklärung
Das ist die Startseite der JSP-Variante. Sie zeigt dem Benutzer, worum es bei der Anwendung geht, und bietet Buttons zum Anmelden oder Registrieren. Mit CSS-Animationen sieht sie dabei hochmodern aus – ganz ohne React-Framework.

## Zweck
Einstiegspunkt der **Native JSP Frontend-Version**: Willkommen-Seite mit Übersicht und Navigation.

## Technologie
- **JSP**: Server-Side Template für die Struktur
- **CSS3**: Animationen (Fade-Ins, Slide-Ups)
- **HTML5**: Semantische Struktur

## Inhalt & Verantwortung
- Zeigt UML-Wissenstest-Logo und kurze Beschreibung
- Animation beim Laden (CSS `animate-fade-in`, `animate-slide-up`)
- Buttons: "Jetzt Starten" (Login) und "Registrieren"
- Optionale Demo-Flip-Cards mit CSS-basiertem Effekt

## Verbindungen
- **Router:** In `native.jsp` über `?page=landingPage` eingebunden
- **Styling:** Nutzt `css_native/style.css` (Glassmorphism, Gradients)
- **Frontend-Pendant:** `frondend/src/components/LandingPage.jsx`

## Wichtige Entscheidungen
- ✅ Vanilla JS statt React (konform mit JSP-Anforderungen)
- ✅ CSS3-Animationen statt Framer Motion (native Browser-Features)
- ✅ Server-Side Template (keine JS-Rendering-Logik für Struktur)
- ✅ Responsive Design (Mobile & Desktop)
