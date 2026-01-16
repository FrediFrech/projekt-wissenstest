# jsp_native/Result.jsp

## Einfache Erklärung
Nachdem der Benutzer einen Test beendet hat, zeigt diese Seite das Ergebnis: Wie viele Fragen richtig beantwortet wurden und eine prozentuale Bewertung. Der Benutzer kann danach entweder zum Dashboard zurück oder den Test nochmal versuchen.

## Zweck
Anzeige der Test-Ergebnisse mit Scoring-Logik und Navigation für Wiederholung.

## Technologie
- **JSP**: Server-Side Template mit Request-Attributen
- **CSS3**: Animate-Effekte (Celebration-Look mit Emoji)
- **Vanilla JS**: Daten aus `sessionStorage` auslesen (vom TestRunner gespeichert)

## Inhalt & Verantwortung
- Zeigt Gesamt-Score (prozentual) in großem Kreis
- Anzeige: "X von Y Fragen richtig"
- Buttons: "Zurück zur Übersicht" und "Nochmal versuchen"
- Daten werden via `sessionStorage` vom TestRunner übertragen
- Animierte Einblendung (Slide-Up-Effekt)

## Verbindungen
- **Router:** In `native.jsp` über `?page=result` eingebunden
- **Datenfluss:** Empfängt JSON von `js_native/app.js` via `sessionStorage.getItem('lastTestResult')`
- **Styling:** `css_native/style.css`
- **Frontend-Pendant:** `frondend/src/components/Result.jsx`

## Wichtige Entscheidungen
- ✅ sessionStorage statt React Props (JSP-konform)
- ✅ Client-Side Berechnung des Prozentsatzes
- ✅ Keine komplexe Backend-Anbindung nötig (Daten kommen vom TestRunner)

## Beispiel-Workflow
1. TestRunner beendet → speichert `{correct: 7, total: 10}` in sessionStorage
2. Navigiert zu `?page=result`
3. Result.jsp liest die Daten aus sessionStorage
4. Zeigt "70%" an
