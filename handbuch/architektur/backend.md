# Backend

Der Java-Code liegt unter `mainlogik, backend/src/main/java/de/dhsn/wissentest/` und ist in fünf Pakete gegliedert: `web`, `service`, `dao`, `model` und `util`. Die Klassen werden ohne Framework direkt miteinander verdrahtet: Jedes Servlet erzeugt beim Start die Services und DAOs, die es braucht.

## Web-Schicht (`web`)

Die URL-Zuordnung steht in `WEB-INF/web.xml`.

| Klasse | Pfad | Aufgabe |
|---|---|---|
| `AuthServlet` | `/api/auth/*` | Registrierung, Login, Logout, Passwort-Reset-Anfrage |
| `TestServlet` | `/api/test/*` | Kategorien, Test starten und abgeben, Historie, Empfehlung, Lernkarten |
| `AdminServlet` | `/api/admin/*` | Fragen, Benutzer, Bilder und Kennzahlen verwalten (nur Rolle `admin`) |
| `ImageServlet` | `/api/images/*` | liefert gespeicherte Bilder aus der Datenbank aus |
| `HealthServlet` | `/health` | Lebenszeichen für Monitoring, antwortet mit `{"status":"ok"}` |
| `CharacterEncodingFilter` | `/*` | setzt UTF-8 für alle Anfragen und Antworten |
| `CorsFilter` | `/api/*` | setzt CORS-Header für Aufrufe von anderen Ursprüngen |

Hilfsklassen: `JsonUtil` (Gson-Instanz), `ServletUtils` (Body lesen, JSON und Fehler schreiben), `ImageUploadUtils` (Dateityp von Bildern erkennen).

Die Sitzung speichert nach dem Login `userId`, `role` und das `User`-Objekt. `AdminServlet` prüft bei jeder Anfrage, ob `role` gleich `admin` ist, und antwortet sonst mit HTTP 403.

!!! warning "CORS-Filter"
    `CorsFilter` übernimmt den `Origin`-Header jeder Anfrage unverändert in `Access-Control-Allow-Origin` und erlaubt zugleich Cookies (`Access-Control-Allow-Credentials: true`). Damit könnte jede fremde Website im Namen eingeloggter Nutzer die API aufrufen. Der Filter stammt aus einer früheren React-Variante; für die JSP-Oberfläche auf derselben Domain wird er nicht gebraucht. Er sollte entfernt oder auf eine feste Liste erlaubter Ursprünge beschränkt werden.

## Service-Schicht (`service`)

| Klasse | Aufgabe | nutzt |
|---|---|---|
| `AuthService` | Registrierung mit Eingabeprüfung, Login, Reset-Anfrage | `UserDao`, `PasswordUtils` |
| `TestService` | Fragen auswählen, Prüfungen aus Segmenten zusammenstellen, Antworten bewerten, Noten berechnen, Versuche speichern, Auto-Schwierigkeit bestimmen | `QuestionRepository`, `AnswerDao`, `ClozeTokenDao`, `AttemptDao`, `UserDao`, `ConfigDao` |
| `ProgressionService` | Regeln für Auf- und Abstieg im Auto-Modus (reine Logik ohne Datenbankzugriff) | wird von `TestService` erzeugt |
| `AdminService` | Fragen mit Antworten bzw. Lücken anlegen, ändern und löschen | `QuestionRepository`, `AnswerDao`, `ClozeTokenDao` |

Die Bewertungsregeln und die Notenberechnung stehen unter [Auto-Modus und Bewertung](auto-modus.md).

## Datenzugriff (`dao`)

Jede Tabelle hat ein Interface und eine JDBC-Implementierung. Die SQL-Abfragen nutzen durchgehend `PreparedStatement`, was vor SQL-Injection schützt.

| Interface | Implementierung | Tabelle(n) |
|---|---|---|
| `UserDao` | `JdbcUserDao` | `users` |
| `QuestionRepository` | `JdbcQuestionRepository` | `questions` |
| `AnswerDao` | `JdbcAnswerDao` | `answers` |
| `ClozeTokenDao` | `JdbcClozeTokenDao` | `cloze_answers` |
| `AttemptDao` | `JdbcAttemptDao` | `attempts`, `attempt_answers` |
| `QuestionImageDao` | `JdbcQuestionImageDao` | `question_images` |
| `ConfigDao` | `JdbcConfigDao` | `config` |

`QuestionDao` und `JdbcQuestionDao` sind veraltete Aliasse von `QuestionRepository` bzw. `JdbcQuestionRepository` und nur noch aus Kompatibilitätsgründen vorhanden.

## Datenobjekte (`model`)

| Klasse | Inhalt |
|---|---|
| `User` | Benutzername, E-Mail, Passwort-Hash und Salt, Rolle, Reset-Flag |
| `Question` | Fragetext, Typ, Schwierigkeit, Punkte, Kategorie, Bild-URL, Metadaten (JSON) |
| `QuestionType` | Enum mit `MC`, `CLOZE`, `FREE`, `IMAGE` |
| `AnswerOption` | Antwortoption einer MC-, Bild- oder Freitextfrage mit Korrekt-Flag und Teilwert |
| `ClozeToken` | erwarteter Begriff einer Lücke mit Position und Teilwert |
| `QuestionImage` | Bilddaten und Content-Type |
| `Attempt`, `AttemptAnswer` | ein abgeschlossener Testversuch und die Antworten je Frage |
| `AttemptResult`, `QuestionResultDetail` | Rückgabe an den Browser nach dem Abgeben: Punkte, Note, Details je Frage, empfohlene Schwierigkeit |

## Hilfsklassen (`util`)

- **`DbConnectionManager`** liest `db.properties` aus dem Classpath und baut daraus einen Verbindungspool mit HikariCP. Der JDBC-Treiber ist fest auf PostgreSQL eingestellt.
- **`PasswordUtils`** erzeugt einen zufälligen Salt und hasht Passwörter mit SHA-256 in 10.000 Iterationen.

!!! note "Passwort-Hashing"
    Iteriertes SHA-256 ist besser als ein einfacher Hash, aber kein spezialisiertes Passwort-Verfahren. Für einen produktiven Einsatz wären PBKDF2, bcrypt oder Argon2 die übliche Wahl.
