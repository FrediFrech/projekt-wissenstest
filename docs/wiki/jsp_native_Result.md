# jsp_native/Result.jsp

## Einfache Erklärung
Nach dem Test zeigt diese Seite dein Ergebnis: **Punkte**, **Note** und eine kurze Bewertung. Optional werden Details je Frage angezeigt.

## Zweck
Anzeige der Test-Ergebnisse mit Schulnoten-Logik und Navigation für Wiederholung oder Dashboard.

## Technologie
- **JSP**: Server-Side Template
- **Vanilla JS**: Ergebnisdaten aus `sessionStorage` (`lastTestResult`)
- **CSS3**: Cards, Buttons und Animationen

## Inhalt & Verantwortung
- Gesamtscore in Punkten (`X / Y Punkte`)
- Anzeige der Note (1 - 6)
- Bewertungs-Text (z. B. "Bestanden")
- Optionaler Detailbereich je Frage (Antwort, Lösung, Punkte)

## Prüfungsmodus: Bestehensgrenze
Wenn der Prüfungsmodus gestartet wurde, wird die **Bestehensgrenze** aus der Konfiguration gelesen:
- **Prozent** (z. B. 60 %) oder
- **Punkte** (z. B. 12 Punkte).

Die Seite zeigt dann **Bestanden/Nicht bestanden** anhand dieser Grenze an.

## Verbindungen
- **Router:** In `native.jsp` über `?page=result` eingebunden
- **Datenfluss:** `js_native/app.js` speichert das Ergebnisobjekt in `sessionStorage`
- **Config-Quelle:** `localStorage.testConfig` (enthält ggf. die Prüfungs-Bestehensgrenze)

## Beispiel-Workflow
1. TestRunner beendet den Test und speichert `lastTestResult`
2. Ergebnis-Seite wird geladen
3. Punkte/Note werden angezeigt
4. Im Prüfungsmodus wird die Bestehensgrenze angewandt
