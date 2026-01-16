# frondend/src/components/LearnMode.jsx

Einfache Erklärung: Der Lernmodus, in dem Nutzer Fragen wie auf Karteikarten lernen können, ohne Zeitdruck und Noten.

## Zweck
Bietet eine entspannte Lernumgebung als Alternative zum prüfungsähnlichen Testmodus.

## Inhalt & Verantwortung
- **Daten:** Lädt alle Fragen vom Backend (`/api/admin/questions`).
- **Filter:** Erlaubt Filterung nach Schwierigkeit (1, 2, 3).
- **Navigation:** Buttons für "Vorherige" und "Nächste" Karte.
- **Interaktion:** Klick auf Karte dreht sie um (Frage <-> Antwort).
- **Anzeige:**
  - Vorderseite: Fragetext.
  - Rückseite:
    - Bei MC: Liste der Optionen, korrekte sind grün markiert.
    - Bei Lückentext: Text mit ausgefüllten Lücken (fett/unterstrichen).

## Verbindungen
- Eingebunden in `App.jsx` unter Route `/learn`.
- Nutzt `FlipCard.jsx` für die Darstellung.
- Nutzt `apiClient.js` für Backend-Calls.
