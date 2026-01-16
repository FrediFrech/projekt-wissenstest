# LandingPage.jsx

## Beschreibung
Die Landing Page ist die erste Seite, die Besucher sehen, wenn sie die Anwendung aufrufen. Sie dient als Marketing- und Informationsseite, um die Features der Wissenstest-Plattform zu präsentieren und neue Nutzer zur Registrierung zu motivieren.

## Komponente
`LandingPage` (React Functional Component)

## Props
- `onNavigate`: Callback-Funktion für die Navigation (z.B. zur Login/Registrierung)

## Features präsentiert

### Feature-Cards
1. **Adaptives Lernen** 🎯
   - Intelligente Schwierigkeitsanpassung basierend auf Performance
   
2. **Detaillierte Auswertung** 📊
   - Sofortiges Feedback und Lernfortschritts-Tracking
   
3. **Multiple Fragetypen** ⚡
   - Multiple Choice und Lückentext für Abwechslung
   
4. **Schulnoten-System** 🎓
   - Automatische Notenberechnung basierend auf Ergebnissen

## Verwendete Technologien
- **Framer Motion:** Für Animation und Transitions
- **FlipCard:** Wiederverwendbare Komponente für Feature-Darstellung

## Design
- Gradient Hero Section (Lila-Töne: `#667eea` → `#764ba2`)
- Responsives Layout (max-width: 1200px)
- Call-to-Action Buttons für Login/Registrierung
- Animierte Feature-Cards mit Hover-Effekten

## Integration
Die Landing Page wird in `App.jsx` als Startseite eingebunden und zeigt sich, wenn der Nutzer nicht eingeloggt ist.
