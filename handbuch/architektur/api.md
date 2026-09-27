# REST-API

Die Oberfläche spricht mit dem Backend ausschließlich über JSON-Endpunkte unter `/wissentest/api/…`. Die Anmeldung läuft über die Servlet-Sitzung (Cookie `JSESSIONID`), es gibt keine Tokens. Fehler kommen einheitlich als JSON mit HTTP-Status 400 (ungültige Eingabe), 403 (keine Berechtigung), 404 (unbekannter Pfad) oder 500.

Die Tabellen geben den Stand des Quellcodes wieder. Pfade sind relativ zu `/wissentest/api`.

## Authentifizierung – `/auth`

| Methode | Pfad | Body | Wirkung |
|---|---|---|---|
| POST | `/auth/register` | `username`, `email`, `password` | legt ein Konto mit Rolle `student` an und meldet direkt an |
| POST | `/auth/login` | `username`, `password` | prüft die Zugangsdaten und legt eine Sitzung an |
| POST | `/auth/logout` | – | beendet die Sitzung |
| POST | `/auth/reset-request` | `username` | markiert das Konto für einen Passwort-Reset |

Login und Registrierung antworten mit `id`, `username` und `role`.

## Tests – `/test`

| Methode | Pfad | Anmeldung | Wirkung |
|---|---|---|---|
| GET | `/test/categories` | nein | Liste der vorhandenen Kategorien |
| GET | `/test/history` | ja | eigene bisherige Versuche |
| GET | `/test/recommend` | ja | empfohlene Schwierigkeit für den nächsten Test |
| GET | `/test/questions/all` | nein | alle als Karteikarte freigegebenen Fragen mit Lösung (Lernmodus) |
| POST | `/test/start` | nur im Auto-Modus | stellt einen Test zusammen und liefert die Fragen |
| POST | `/test/submit` | empfohlen | bewertet die Antworten und speichert den Versuch |

Beispiel für einen Teststart:

```json
POST /wissentest/api/test/start
{
  "difficulty": 2,
  "limit": 10,
  "categories": ["Klassendiagramm", "Sequenzdiagramm"],
  "autoMode": false
}
```

Statt `difficulty` kann `autoMode: true` gesetzt werden. Für den Prüfungsmodus wird zusätzlich eine Liste `segments` übergeben, jedes Segment mit `category`, `type`, `difficulty` und `percent`.

Beispiel für die Abgabe:

```json
POST /wissentest/api/test/submit
{
  "difficulty": 2,
  "durationSeconds": 312,
  "questionIds": [4, 17, 23],
  "answers": { "4": [12], "17": ["Lebenslinie", "Nachricht"], "23": "Aggregation" }
}
```

Die Antwort enthält Gesamtpunkte, Maximalpunkte, Note, Details je Frage und `recommendedDifficulty`.

!!! note "Abgabe ohne Sitzung"
    Ist beim Abgeben keine Sitzung vorhanden, speichert der Server den Versuch unter dem Demo-Konto `student`. Das ist für Vorführungen praktisch, sollte im Echtbetrieb aber durch eine Fehlermeldung ersetzt werden.

## Verwaltung – `/admin`

Alle Endpunkte erfordern eine Sitzung mit der Rolle `admin`, sonst antwortet der Server mit 403.

| Methode | Pfad | Wirkung |
|---|---|---|
| GET | `/admin/stats` | Anzahl Benutzer, Fragen und Versuche |
| GET | `/admin/questions` | alle Fragen mit Antworten bzw. Lücken |
| POST | `/admin/questions` | Frage anlegen (MC, Bild, Freitext oder Lückentext) |
| PUT | `/admin/questions` | Frage ändern |
| DELETE | `/admin/questions?id=…` | Frage löschen |
| GET | `/admin/users` | alle Benutzer |
| GET | `/admin/users/requests` | Benutzer mit offener Reset-Anfrage |
| POST | `/admin/users` | Benutzer anlegen |
| PUT | `/admin/users` | Benutzer ändern (Name, E-Mail, Rolle, Passwort, Reset erledigt) oder per `?id=…&role=…` nur die Rolle wechseln |
| DELETE | `/admin/users?id=…` | Benutzer löschen |
| POST | `/admin/images` | Bild hochladen, liefert `id` und `url` |
| POST | `/admin/images/import` | alle Bilder aus `assets/questions` importieren |

!!! warning "Passwort-Hashes in der Benutzerliste"
    `GET /admin/users` gibt die `User`-Objekte vollständig zurück, also auch `passwordHash` und `passwordSalt`. Der Endpunkt ist zwar nur für Admins erreichbar, die Felder werden in der Oberfläche aber nicht gebraucht und sollten nicht mitgeschickt werden.

## Bilder und Status

| Methode | Pfad | Wirkung |
|---|---|---|
| GET | `/api/images/{id}` | liefert ein gespeichertes Bild mit passendem Content-Type |
| GET | `/health` | `{"status":"ok"}`, ohne Anmeldung, liegt außerhalb von `/api` |
