# Für Lehrende

Lehrende arbeiten mit einem Konto mit der Rolle `admin`. Nach dem Login erscheint auf dem Dashboard die Karte **Admin Panel** und in der Navigation der Punkt **Admin**. Benutzer ohne Admin-Rolle sehen statt des Admin-Panels die Seite „Zugriff verweigert“; auch die zugehörigen API-Endpunkte antworten dann mit HTTP 403.

## Kennzahlen

Oben im Admin-Panel stehen drei Zahlen: registrierte Benutzer, Fragen im Katalog und abgeschlossene Tests.

## Passwort-Reset-Anfragen

Wenn Lernende auf der Login-Seite „Passwort vergessen“ nutzen, erscheint hier automatisch ein Abschnitt mit den offenen Anfragen. Über **Bearbeiten** wird ein neues Passwort gesetzt und die Anfrage als erledigt markiert. Das neue Passwort wird der Person anschließend auf einem eigenen Weg mitgeteilt; die Anwendung verschickt keine E-Mails.

## Fragenkatalog

Der Fragenkatalog listet alle Fragen in einer Tabelle.

- **Filtern** nach Text oder Kategorie mit Platzhalter `*`, zum Beispiel `*uml*`, `uml*` oder `*diagramm`, dazu nach Typ und Schwierigkeit.
- **Sortieren** nach ID, Fragetext, Kategorie, Typ, Schwierigkeit oder Anzahl der Antwortoptionen, auf- oder absteigend.
- Die Checkbox **Als Karteikarte anzeigen** legt fest, ob eine Frage im Lernmodus erscheint. Neue Fragen sind standardmäßig freigegeben.

### Fragen anlegen und bearbeiten

Im Dialog **Frage erstellen** werden Typ, Kategorie, Fragetext, Schwierigkeit (1 bis 3), Punkte und optional ein Bild festgelegt. Wie die Antworten eingegeben werden, hängt vom Typ ab:

=== "Multiple Choice / Bildfrage"

    Antworten durch Komma trennen, richtige Antworten mit `*` markieren:

    ```text
    *Aggregation, Assoziation, *Komposition, Vererbung
    ```

    Jede richtige Option erhält beim Speichern den Teilwert 1. Schon eine gewählte richtige Option ergibt damit die vollen Punkte. Wählt jemand eine falsche Option, gibt es für die Frage keine Punkte.

=== "Lückentext"

    Ein JSON-Array mit einem Eintrag pro Lücke. Jeder Eintrag enthält die zulässigen Schreibweisen:

    ```json
    [ ["Sequenz", "Sequenzdiagramm"], ["Zeit"] ]
    ```

    Groß- und Kleinschreibung spielt bei der Auswertung keine Rolle.

=== "Freitext"

    Alle akzeptierten Lösungen, getrennt durch Komma oder Zeilenumbruch:

    ```text
    Klassendiagramm, Klassen-Diagramm
    ```

### Bilder

Bilder für Bildfragen lassen sich per Drag & Drop oder Dateiauswahl hochladen, alternativ als externe URL eintragen. Hochgeladene Bilder werden in der Datenbank gespeichert (Tabelle `question_images`) und über `/api/images/{id}` ausgeliefert. Sie wandern deshalb bei einer Datenbankkopie automatisch mit.

Für viele Bilder auf einmal gibt es den **Import aus Ordner**: Er liest alle Bilddateien (PNG, JPG, GIF, WebP, BMP) aus dem Ordner `assets/questions` der Webanwendung und legt sie in der Datenbank ab.

## Benutzerverwaltung

- Liste aller Benutzer, filterbar per Platzhalter `*` und nach Rolle, sortierbar nach Name, Rolle oder ID
- **Neuen User anlegen** mit Benutzername, Passwort und Rolle (`student` oder `admin`)
- **Bearbeiten:** Name, E-Mail, Rolle ändern oder ein neues Passwort setzen; ein leeres Passwortfeld lässt das Passwort unverändert
- **Löschen:** entfernt den Benutzer samt seinen Testversuchen

!!! warning "Rollen mit Bedacht vergeben"
    Die Rolle `admin` erlaubt vollen Zugriff auf alle Fragen und Konten. Für Lernende immer die Rolle `student` verwenden.
