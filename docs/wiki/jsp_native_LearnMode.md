# jsp_native/LearnMode.jsp

## Einfache Erklärung
Der "Lernmodus" ist ein Feature, mit dem Studenten sich ohne Druck Fragen ansehen können. Jede Frage wird als Karteikarte (Flip-Card) angezeigt – die Vorderseite zeigt die Frage, beim Klick dreht sie sich und zeigt die Antwort. Perfekt zum Trainieren vor dem echten Test.

## Zweck
Interaktiver Lernbereich mit Karteikarten-Interface.

## Technologie
- **JSP**: Server-Side Struktur & Seiten-Gerüst
- **CSS3**: 3D-Flip-Effekt (transform: rotateY, perspective)
- **Vanilla JS**: Event-Listener für Flip-Aktion, Daten laden via AJAX

## Inhalt & Verantwortung
- Grid-Layout von Karteikarten
- Jede Karte: Frage auf der Vorderseite, Antwort auf der Rückseite
- Click-Event toggled CSS-Klasse `.flipped` für den 3D-Dreheffekt
- Lade-Logik via `loadLearnCards()` Funktion (JSP-Template)
- Animierte Einfädelung der Karten (staggered animation)
- Vergrößern-Modal: zeigt dieselbe Flip-Card groß (Front/Back, Klick zum Drehen)
- Modal ist mittig; bei langen Inhalten scrollt der Inhalt innerhalb des Modals

## Modal (Vergrößern) – einfache Erklärung
Wenn die Karte zu klein ist, öffnet „Vergrößern“ ein Modal. 
**Neu:** Dieses Modal füllt jetzt nicht mehr den ganzen Bildschirm, sondern ist ein zentriertes Popup (max. 550x700px), damit es übersichtlich bleibt und nicht "erschlagend" wirkt.
- Oben: Titel + Badges (Kategorie, Typ, Schwierigkeit)
- In der Mitte: **große Flip-Card** (Vorderseite = Frage, Rückseite = Antwort)
- Klick auf die Karte dreht sie wie im Grid
- Optionales Bild wird auf der Vorderseite eingeblendet

### Scroll-Verhalten
- Das Modal bleibt in der Mitte der aktuellen Ansicht.
- Bei langen Inhalten kann der **Modal-Inhalt** gescrollt werden.
- Der Seitenhintergrund bleibt gesperrt (fokussiert den Nutzer auf das Modal).

## Verbindungen
- **Router:** In `native.jsp` über `?page=learnMode` eingebunden
- **CSS:** `css_native/style.css` + interne `<style>` für Flip-Card-Effekt
- **Datenquellen:** AJAX zu `/api/test/questions/all` (via `js_native/app_main.js`)
- **Sub-Component:** Verwendet die Struktur von `FlipCard.jsp`

## Wichtige Entscheidungen
- ✅ Pure CSS 3D-Effekt statt JavaScript-Animationen (Performance)
- ✅ Vanilla JS mit `classList.toggle('flipped')` (minimal & verständlich)
- ✅ Responsive Grid (`grid-template-columns: repeat(auto-fill, minmax(300px, 1fr))`)
- ✅ Modal mit Overlay-Scroll: verhindert „Starre Mitte“ und erlaubt langes Bild/Text-Scrolling

## Beispiel-Workflow
1. User navigiert zu `?page=learnMode`
2. JSP lädt & ruft `loadLearnCards()` auf
3. JavaScript erzeugt dynamisch eine Karte pro Frage
4. User klickt auf eine Karte → CSS 3D-Flip zeigt Antwort
5. Klick auf „Vergrößern“ → Modal zeigt eine **große Flip-Card**
6. Klick auf die große Karte → Flip (Antwort sichtbar)
7. Bei langen Inhalten: Modal kann innerhalb der Ansicht gescrollt werden
8. Klick außerhalb oder auf „×“ → Modal schließt
