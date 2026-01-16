# frondend/src/components/FlipCard.jsx

Einfache Erklärung: Eine wiederverwendbare Karte, die sich beim Anklicken mit einer schönen 3D-Lernkarten-Animation umdreht.

## Zweck
Bereitstellung einer interaktiven UI-Komponente für Flip-Karten, die auf der Landing Page und im Lernmodus eingesetzt werden.

## Inhalt & Verantwortung
- **Props:**
  - `front`: React-Node für die Vorderseite.
  - `back`: React-Node für die Rückseite.
  - `isFlipped`: (Optional) Steuert den Zustand von außen (Controlled Component).
  - `onFlip`: (Optional) Callback beim Klicken.
- **State:** Verwaltet internen Flip-Zustand, falls nicht von außen gesteuert.
- **Styling:** Nutzt CSS `transform: rotateY(180deg)` und `perspective` für 3D-Effekte.

## Verbindungen
- Wird von `LandingPage.jsx` verwendet, um Features interaktiv zu zeigen.
- Wird von `LearnMode.jsx` verwendet, um Fragen und Antworten anzuzeigen.
- Nutzt `framer-motion` für die Animation.
