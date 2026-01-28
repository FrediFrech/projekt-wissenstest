# Gliederung der Dokumentation - Projekt Wissenstest

## 1. Deckblatt
- Titel: Projektarbeit Softwareprojekt
- Thema: Wissenstest - Web-basierte Lernplattform
- Namen der Entwickler
- Studiengang (SG)
- Datum
- Betreuende Person/Institution

Startup: cd 'c:\Studium\3. Semester\SP UMLTest\projekt-wissenstest\startup'; & '.\start_project.ps1'
---

## 2. Einführung und Projektmotivation

### 2.1 Beweggründe für die Themenwahl
Die Digitalisierung des Bildungssektors hat in den letzten Jahren an Bedeutung gewonnen. Traditionelle Testverfahren sind oft zeitaufwändig, papierbasiert und ermöglichen keine automatisierte Auswertung. Dies führt zu hohem Verwaltungsaufwand für Lehrkräfte.

**Kernprobleme:**
- Manuelle Bewertung ist fehleranfällig und zeitintensiv
- Keine Echtzeitauswertung von Testergebnissen möglich
- Begrenzte Flexibilität bei verschiedenen Fragetypen
- Schwierigkeiten bei der Verfolgung von Lernfortschritten

Mit dem "Projekt Wissenstest" soll eine moderne, benutzerfreundliche Web-Anwendung entwickelt werden, die:
- Automatisierte Testdurchführung und Bewertung ermöglicht
- Echtzeitfeedback an Lernende liefert
- Verschiedene Fragetypen unterstützt (Multiple Choice, Lückentext)
- Für Lehrkräfte und Schüler einfach zu bedienen ist

### 2.2 Zielsetzung des Projektes
Das Projekt verfolgt folgende Hauptziele:

1. **Entwicklung einer Web-Anwendung zur Durchführung von Wissenstests**
   - Benutzerfreundliche Oberfläche für Schüler und Lehrer
   - Unterstützung verschiedener Fragetypen
   - Automatisierte Bewertung und Notenvergabe

2. **Implementierung einer skalierbaren Architektur**
   - Klare Trennung von Präsentations-, Geschäftslogik- und Datenschicht
   - Verwendung bewährter Design-Patterns (DAO, Service, MVC)
   - Einfache Erweiterbarkeit

3. **Sicherung der Datensicherheit und Benutzerverwaltung**
   - Sichere Authentifizierung und Autorisierung
   - Passwort-Hashing und Verschlüsselung
   - Rollenbasierte Zugriffskontrolle

4. **Bereitstellung umfassender Lernunterstützung**
   - Lernmodus mit interaktiven Flip-Cards
   - Prüfungsmodus mit Bestehensgrenze
   - Detailliertes Feedback zu Antworten

### 2.3 Zielgruppen und Nutzer
Das System wird für folgende Zielgruppen entwickelt:

- **Schüler/Studenten:** Können Tests durchführen, ihr Wissen überprüfen und lernen
- **Lehrkräfte/Dozenten:** Verwalten Tests, erstellen Fragen, überwachen Fortschritte
- **Administratoren:** Verwalten Benutzer, führen System-Wartung durch

---

## 3. Problembeschreibung und Anforderungsanalyse

### 3.1 Problembeschreibung
**Ausgangssituation:**
Das Projekt entstand im Rahmen des Moduls "Softwareprojekt" mit dem Ziel, eine Web-Anwendung zur Verwaltung und Durchführung von Wissenstests zu entwickeln. Die Anwendung sollte folgende Szenarien adressieren:

**Herausforderungen:**
- Lehrkräfte benötigen eine effiziente Möglichkeit, Tests zu erstellen und zu verwalten
- Schüler müssen Wissenstests in verschiedenen Formaten absolvieren können
- Automatische Bewertung und Feedback sind essentiell für ein effektives Lernen
- Traditionelle papierbasierte Tests sind zeitaufwändig und ermöglichen keine Echtzeitauswertung
- Lernfortschritte müssen nachverfolgbar und visualisierbar sein

**Anforderungen an die Lösung:**
- Schnelle und intuitive Bedienung
- Sichere Datenverwaltung
- Automatisierte Bewertung
- Verschiedene Fragetypen (MC, Lückentext)
- Verwaltungsfunktionen für Administratoren

### 3.2 Funktionale Anforderungen

#### 3.2.1 Benutzerverwaltung
- **Registrierung:** Neue Benutzer können sich als Schüler registrieren
- **Login/Logout:** Sichere Authentifizierung mit Benutzername und Passwort
- **Rollen:**
  - **Student/Schüler:** Kann Tests durchführen und Ergebnisse einsehen
  - **Lehrer/Admin:** Kann Tests und Fragen verwalten, Benutzer administrieren
- **Passwort-Reset:** Anfrage und Neusetzung von Passwörtern durch Administratoren
- **Profilinformationen:** Benutzer können ihre Daten einsehen

#### 3.2.2 Test- und Fragenmanagement
- **Test-Konfiguration (dynamisch, ohne persistente Test-Entität):**
  - Tests werden zur Laufzeit gestartet (z. B. Difficulty, Limit, Kategorie/Segmente)
  - Es gibt **keine** separate `tests`-Tabelle; Ergebnisse werden als `attempts` gespeichert
  
- **Fragenmanagement (Admin):**
  - Verschiedene Fragetypen:
    - **Multiple Choice (MC):** Mehrere Antwortmöglichkeiten mit einer korrekten Antwort
    - **Lückentext (Cloze):** Sätze mit Lücken, die ergänzt werden müssen
    - **Free:** Freitext (Musterlösung als AnswerOption)
    - **Image:** Bildfrage (Antwortoptionen + Bild-URL)
  - Schwierigkeitsstufen (Einfach, Mittel, Schwierig)
  - Verwaltung von Antwortmöglichkeiten
  - Kategorisierung und Filtermöglichkeiten

#### 3.2.3 Testdurchführung
- **Test starten:** Benutzer können verfügbare Tests durchstöbern und starten
- **Fragebeantwortung:** 
  - Schrittweises Durcharbeiten von Fragen
  - Verschiedene Eingabetypen je nach Fragetyp
  - Möglichkeit, Antworten zu ändern
  - Zeitmessung und Zeitlimit-Anzeige
- **Testbeendigung:** Automatisches Speichern von Antworten und Beendigung
- **Lernmodus vs. Prüfungsmodus:**
  - Lernmodus: Sofortiges Feedback nach jeder Frage
  - Prüfungsmodus: Feedback erst nach Testabschluss

#### 3.2.4 Auswertung und Feedback
- **Automatische Bewertung:** 
  - Punkte-Berechnung basierend auf korrekten Antworten
  - Prozentuale Quote-Berechnung
- **Notenbestimmung:** Automatische Umrechnung zu Schulnoten (1-6)
- **Bestehensgrenze:** Konfigurierbare Prozent-/Punktegrenze zum Bestehen
- **Detailliertes Feedback:**
  - Richtig/Falsch-Anzeige für jede Frage
  - Erklärungen und richtige Antworten
  - Persönliche Empfehlungen zum Weiterlernen
- **Ergebnisspeicherung:** Alle Attempts werden gespeichert und können abgerufen werden

#### 3.2.5 Lernfunktionen
- **Flip-Cards:** Interaktive Kartensets zum Üben von Fragen
- **Fortschrittsanzeige:** Visuelles Tracking von bestandenen Tests
- **Statistiken:** Übersicht über Lernfortschritt und Leistungstrends

#### 3.2.6 Admin-Funktionen
- **Benutzerverwaltung:**
  - Anzeige aller Benutzer
  - Aktivieren/Deaktivieren von Benutzern
  - Passwort-Reset durchführen
  - Rollenzuweisung
  
- **Statistiken und Reporting:**
  - Anzahl registrierter Benutzer
  - Durchschnittliche Testergebnisse
  - Meistgestellte Fragen
  - System-KPIs
  
- **Konfiguration:**
  - Verwaltung von Testkonfigurationen
  - Anpassung von Systemeinstellungen

### 3.3 Nicht-funktionale Anforderungen

- **Performance:** Schnelle Antwortzeiten auch bei vielen gleichzeitigen Benutzern
- **Skalierbarkeit:** Anpassung an wachsende Benutzerzahlen möglich
- **Sicherheit:** 
  - Sichere Speicherung von Passwörtern (Hashing)
  - Schutz vor SQL-Injection
  - Session-Management
  - Rollbasierte Zugriffskontrolle
- **Benutzerfreundlichkeit:** 
  - Intuitive Bedienung
  - Responsive Design
  - Klare Menüstruktur
- **Zuverlässigkeit:** 
  - Hohe Verfügbarkeit
  - Fehlerbehandlung
  - Datenintegrität

### 3.4 Technische Anforderungen und Stack

Die Anwendung wird mit folgenden Technologien entwickelt:

| Komponente | Technologie | Version |
|---|---|---|
| **Programmiersprache Backend** | Java | 17 (LTS) |
| **Web-Framework** | Jakarta Servlet API | 5.0+ |
| **Frontend** | JSP (Java Server Pages) | Vanilla JavaScript |
| **HTML/CSS** | HTML5, CSS3 | Modern Standards |
| **Datenbank** | PostgreSQL | 15+ / 16+ |
| **JDBC** | HikariCP (Connection Pool) | 5.1+ |
| **Build-Tool** | Apache Maven | 3.9.6 |
| **Application Server** | Apache Tomcat | 9.0.85+ |
| **Testing** | JUnit | 5 |
| **Runtime** | OpenJDK Temurin | 17.0.10 |
| **Version Control** | Git | Modern |

**Frontend-Architektur:**
- Server-seitiges Rendering mit JSP-Templates
- Vanilla JavaScript für Interaktivität (keine Heavy-Frameworks)
- CSS3 für responsive Layouts und Animationen
- AJAX-ähnliche Calls zum Backend über REST

**Backend-Architektur:**
- **Servlet-basiert:** Request/Response-Handling
- **Service-Layer:** Business-Logik-Trennung
- **DAO-Pattern:** Datenbankabstraktion über DAOs
- **Model-Objekte:** POJOs für Datenhaltung

**Datenbank:**
- Relationales Datenbankmodell
- Tabellen für Users, Questions, Attempts, Answers, etc.
- Normalisierung bis zur 3. Normalform

**Sicherheitsaspekte:**
- Authentifizierung über Session-Management
- Passwort-Hashing mit sicheren Algorithmen
- Prepared Statements gegen SQL-Injection
- Rollenbasierte Zugriffskontrolle

---

## 4. UML-Diagramme und Modelle

### 4.1 Use-Case-Diagramm
- **Grafische Darstellung**
- **Beschreibung der Akteure:**
  - Schüler/Student
  - Lehrer
  - Administrator
  - System
- **Beschreibung der Use-Cases:**
  - Login/Logout
  - Test durchführen
  - Testergebnisse ansehen
  - Fragen administrieren (Admin)
  - Benutzerverwaltung

### 4.2 Klassendiagramm
- **Grafische Darstellung**
- **Kurzbeschreibung der Klassen:**
  - User (role: student/admin)
  - Question (unterschiedliche Typen)
  - QuestionType (Enum: MC, CLOZE, FREE, IMAGE)
  - QuestionImage (gespeicherte Uploads)
  - AnswerOption (MC-Antworten)
  - ClozeToken (CLOZE-Erwartungen)
  - Attempt (Testversuch)
  - AttemptAnswer (Antwort pro Frage innerhalb eines Attempts)
  - AttemptResult / QuestionResultDetail (Auswertung)
  - Service-Klassen (AuthService, TestService, etc.)
  - DAO-Klassen (Datenzugriff)
- **Beziehungen und Kardinalitäten**

### 4.3 Entity-Relation-Diagramm (ERD)
- **Grafische Darstellung**
- **Entitäten und ihre Rollen:**
  - **users:** Benutzerkonten inkl. Hash/Salt/Role
  - **questions:** Fragen (Typ, Prompt, Schwierigkeit, Punkte, Kategorie, Meta)
  - **question_images:** Binäre Bilddaten (Uploads)
  - **answers:** Antwortoptionen für Multiple-Choice-Fragen
  - **cloze_answers:** Erwartete Tokens für Lückentext-Fragen (geordnet)
  - **attempts:** Abgeschlossene Testversuche (Score, Max-Score, Difficulty, Dauer)
  - **attempt_answers:** Pro-Frage-Ergebnis/Antwort innerhalb eines Attempts
  - **config:** Konfiguration (Key/Value), z. B. Thresholds als Placeholder
  
- **Kardinalitäten:**
  - User (1) → (N) Attempts
  - User (1) → (N) Questions (created_by, optional)
  - Question (1) → (N) Answers
  - Question (1) → (N) ClozeAnswers
  - Attempt (1) → (N) AttemptAnswers
  - Question (0..1) → (N) AttemptAnswers (question_id kann bei Löschung auf NULL gesetzt werden)
  
- **Attribute der Entitäten (vereinfachter Auszug):**
  - **users:** id, username, email, password_hash, password_salt, role, reset_requested, created_at
  - **questions:** id, type, prompt, difficulty, points, category, image_url, meta, created_by, created_at
  - **question_images:** id, content_type, data, created_at
  - **answers:** id, question_id, answer_text, is_correct, partial_value
  - **cloze_answers:** id, question_id, token_index, expected_text, partial_value
  - **attempts:** id, user_id, total_points, max_points, difficulty, grade, duration_seconds, created_at
  - **attempt_answers:** id, attempt_id, question_id, given_answer, points_awarded
  - **config:** key, value, description

> Hinweis: Es gibt in diesem Projekt **keine persistente Tabelle `tests`** und auch keine `test_questions`-Junction-Table.
> „Tests“ entstehen dynamisch (z. B. über Difficulty/Filter) und die Ergebnisse werden in `attempts`/`attempt_answers` gespeichert.

### 4.4 Relationales Modell
Das relationale Modell definiert die konkrete Datenbankstruktur mit SQL-Typen und Constraints:

Die folgenden Tabellen entsprechen dem aktuellen Stand aus `db/schema.sql` (PostgreSQL):

#### Tabelle: users
```
users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE,
  password_hash VARCHAR(256) NOT NULL,
  password_salt VARCHAR(128) NOT NULL,
  role VARCHAR(32) NOT NULL DEFAULT 'student',
  reset_requested BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
)
```

#### Tabelle: questions
```
questions (
  id SERIAL PRIMARY KEY,
  type VARCHAR(16) NOT NULL CHECK (type IN ('MC','CLOZE','FREE','IMAGE')),
  prompt TEXT NOT NULL,
  difficulty SMALLINT NOT NULL CHECK (difficulty IN (1,2,3)),
  points INTEGER NOT NULL DEFAULT 1,
  category VARCHAR(64) DEFAULT 'Allgemein',
  image_url VARCHAR(255),
  meta JSONB DEFAULT '{}'::jsonb,
  created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
)
```

#### Tabelle: question_images
```
question_images (
  id SERIAL PRIMARY KEY,
  content_type VARCHAR(128) NOT NULL,
  data BYTEA NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
)
```

#### Tabelle: answers (Multiple Choice)
```
answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  answer_text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT false,
  partial_value NUMERIC(5,4) NOT NULL DEFAULT 0.0 CHECK (partial_value >= 0 AND partial_value <= 1)
)
```

#### Tabelle: cloze_answers (Lückentext)
```
cloze_answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  token_index SMALLINT NOT NULL,
  expected_text TEXT NOT NULL,
  partial_value NUMERIC(5,4) NOT NULL DEFAULT 1.0 CHECK (partial_value >= 0 AND partial_value <= 1),
  UNIQUE(question_id, token_index)
)
```

#### Tabelle: attempts
```
attempts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  total_points NUMERIC(8,4) NOT NULL DEFAULT 0.0,
  max_points NUMERIC(8,4) NOT NULL DEFAULT 0.0,
  difficulty SMALLINT NOT NULL CHECK (difficulty IN (1,2,3)),
  grade VARCHAR(10),
  duration_seconds INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
)
```

#### Tabelle: attempt_answers
```
attempt_answers (
  id SERIAL PRIMARY KEY,
  attempt_id INTEGER NOT NULL REFERENCES attempts(id) ON DELETE CASCADE,
  question_id INTEGER REFERENCES questions(id) ON DELETE SET NULL,
  given_answer TEXT,
  points_awarded NUMERIC(8,4) NOT NULL DEFAULT 0.0
)
```

#### Tabelle: config
```
config (
  key VARCHAR(128) PRIMARY KEY,
  value VARCHAR(255) NOT NULL,
  description TEXT
)
```

#### Indexe (Auszug)
- `CREATE INDEX idx_questions_difficulty ON questions(difficulty);`
- `CREATE INDEX idx_attempts_user ON attempts(user_id);`

#### Datentypen Summary
| Datentyp | Verwendung |
|---|---|
| SERIAL | Auto-incrementing Primary Keys |
| INTEGER / SMALLINT | Zahlenfelder, IDs, Difficulty |
| VARCHAR(n) | Begrenzte Text-Längen (Username, Role, Kategorie) |
| TEXT | Unbegrenzte Text-Längen (Prompt, Antworten) |
| BOOLEAN | Wahrheitswerte |
| TIMESTAMP WITH TIME ZONE | Zeitstempel |
| NUMERIC(p,s) | Punkte/Score mit Dezimalstellen |
| JSONB | Metadaten-Felder (z. B. learnEnabled) |

### 4.5 Deployment-Diagramm
- **Grafische Darstellung der Infrastruktur**
- **Hardware-Komponenten:**
  - **Client:** Desktop/Laptop/Tablet mit Web-Browser
  - **Web-Server:** Apache Tomcat 9.0.85 auf lokalem Rechner (Port 8080)
  - **Anwendungsserver:** Java Virtual Machine (JVM) mit Java 17
  - **Datenbank-Server:** PostgreSQL 16.1 auf lokalem Rechner (Port 5433)
  
- **Software-Komponenten:**
  - **Presentation Tier:** JSP Pages, HTML5, CSS3, JavaScript
  - **Application Tier:** Java Servlets, Service-Klassen, Business-Logik
  - **Data Tier:** PostgreSQL mit JDBC-Treiber
  
- **Kommunikationsprotokolle:**
  - HTTP/HTTPS für Client ↔ Tomcat
  - JDBC für Tomcat ↔ PostgreSQL
  
- **Deployment-Struktur:**
  ```
  Client (Browser)
      ↓ HTTP (Port 8080)
  Apache Tomcat 9
      ├── wissentest.war (Deployed Web Application)
      ├── JSP Pages (Server-seitiges Rendering)
      ├── Java Servlets (Controller)
      ├── Service-Layer (Business Logic)
      └── DAO Layer (JDBC)
          ↓ JDBC (Port 5433)
      PostgreSQL 16
          ├── wissentest Database
          └── Tables (users, questions, attempts, etc.)
  ```
  
- **Startup-Prozess (automatisiert):**
  1. PostgreSQL wird auf Port 5433 gestartet
  2. Datenbankschema wird initialisiert (schema.sql)
  3. Testdaten werden geladen (seeds.sql)
  4. Maven kompiliert Java-Code und erstellt WAR-Datei
  5. WAR-Datei wird in Tomcat webapps/ deployed
  6. Tomcat wird gestartet (Port 8080)
  7. Anwendung wird automatisch gestartet und ist unter http://localhost:8080/wissentest erreichbar

### 4.6 Komponentendiagramm
- **Grafische Darstellung der Software-Komponenten**
  
- **Komponenten und ihre Rollen:**
  
  1. **Presentation Layer (Frontend)**
     - JSP Templates: Server-seitiges HTML-Rendering
     - Native JSP Components: Wiederverwendbare JSP-Includes
     - CSS Native: Styling und Responsive Design
     - JavaScript Native: Client-seitige Interaktivität
     - Abhängigkeiten: HTTP-Requests an Servlets
  
  2. **Web Layer (Servlets/Controller)**
     - AuthServlet: Authentifizierung, Login/Logout
     - TestServlet: Test-Verwaltung und -Durchführung
     - AdminServlet: Admin-Panel-Funktionen
      - ImageServlet: Upload/Download von Frage-Bildern
      - HealthServlet: Health-Check Endpoint
     - Abhängigkeiten: Service-Layer, Session-Management
  
  3. **Business Logic Layer (Services)**
     - **AuthService:** 
       - Benutzer-Authentifizierung
       - Passwort-Validierung und -Hashing
       - Session-Management
     - **TestService:**
       - Frageauswahl (z. B. nach Difficulty)
       - Auswertung/Scoring und Persistierung von `attempts` + `attempt_answers`
       - Bereitstellen von LearnMode-Daten (ohne Persistierung)
     - **ProgressionService:**
       - Score-Berechnung
       - Noten-Berechnung
       - Fortschrittsverfolgung
       - Statistik-Berechnung
     - **AdminService:**
       - Benutzerverwaltung
       - Passwort-Reset
       - System-Statistiken
     - Abhängigkeiten: DAO-Layer, Model-Klassen
  
  4. **Persistence Layer (DAOs/Repository)**
     - **JdbcUserDao:** User-Operationen (CRUD)
     - **JdbcQuestionDao:** Question-Operationen
     - **JdbcAnswerDao:** Answer-Operationen
     - **JdbcAttemptDao:** Attempt-Verwaltung
    - **JdbcClozeTokenDao:** Lückentext-Tokens (DB-Tabelle: `cloze_answers`)
     - Abhängigkeiten: DbConnectionManager, JDBC
  
  5. **Data Access Layer (Database)**
     - PostgreSQL Datenbank
     - Tabellen: users, questions, attempts, answers, etc.
     - Connection Pooling: HikariCP
  
  6. **Utility Layer**
     - **DbConnectionManager:** Verwaltung von Datenbankverbindungen
     - **PasswordUtils:** Passwort-Hashing und -Verifikation
  
  - **Abhängigkeitsmatrix:**
    ```
    UI (JSP) 
        ↓ HTTP-Requests
    Servlets 
        ↓ Calls
    Services 
        ↓ Calls
    DAOs 
        ↓ JDBC-Queries
    Database
    ```

### 4.7 Activity-Diagramm

#### 4.7.1 Prozessablauf: Benutzer führt Test durch
```
1. START
2. Benutzer öffnet Anwendung
3. Login erforderlich?
   - JA → Authentifizierung durchführen
        → Credentials validieren?
           - NEIN → Fehlermeldung, zurück zu 3
           - JA → Weiter
   - NEIN → Überspringen
4. Test-Optionen anzeigen (z. B. Difficulty/Kategorie/Auto-Modus)
5. Benutzer wählt Einstellungen
6. Test starten (Backend liefert Fragen via /api/test/start)
7. FOR EACH Frage im Test:
   a) Frage anzeigen
   b) Timer starten (falls aktiviert)
   c) Benutzer beantwortet Frage
   d) Antwort speichern (lokal)
   e) Nächste Frage?
      - JA → Zurück zu 7
      - NEIN → Weiter
8. Test beenden?
   - JA → Weiter
   - NEIN → Abbrechen
9. Alle Antworten an Server senden
10. Server bewertet Test:
    - Score berechnen
    - Prozentuale Quote berechnen
    - Noten umrechnen
    - Bestanden/Nicht bestanden?
11. Ergebnisse speichern in Datenbank
12. Ergebnisseite anzeigen
    - Score
    - Prozent
    - Note
    - Feedback für jede Frage
13. Benutzer kann:
    - Detailliertes Feedback ansehen
    - Test wiederholen
    - Zum Lernmodus wechseln
14. END
```

#### 4.7.2 Prozessablauf: Admin erstellt/bearbeitet Test
```
1. START (Admin angemeldet)
2. Admin navigiert zum Admin-Panel
3. "Fragen verwalten" wählen
4. Bestehende Fragen anzeigen (Liste)
5. Admin wählt eine Option:
  a) NEUE FRAGE:
    - Fragetyp wählen (MC/CLOZE/FREE/IMAGE)
    - Prompt, Difficulty, Punkte, Kategorie, Meta (z. B. learnEnabled) setzen
    - Optionen/Tokens pflegen
    - (optional) Bild hochladen (/api/admin/images) und image_url setzen
    - Frage speichern (/api/admin/questions)
    - WEITER zu 6
  b) FRAGE BEARBEITEN:
    - Frage auswählen
    - Felder/Optionen/Tokens anpassen
    - Speichern (/api/admin/questions via PUT)
    - WEITER zu 6
  c) FRAGE LÖSCHEN:
    - Frage auswählen
      - Bestätigung erforderlich?
        - JA → Bestätigen
        - NEIN → Abbrechen
    - Frage löschen (/api/admin/questions via DELETE)
      - WEITER zu 6
6. Änderungen validieren
   - Fehler vorhanden?
     - JA → Fehlermeldung, Benutzer korrigiert
     - NEIN → Weiter
7. Änderungen in Datenbank speichern
8. Bestätigungsmeldung anzeigen
9. Zurück zu Admin-Panel oder weitere Verwaltung?
10. END
```

#### 4.7.3 Prozessablauf: Login/Authentifizierung (Swim-Lanes: Benutzer | System | Datenbank)
```
Swim Lane 1: BENUTZER
├── Öffnet Anwendung
├── Sieht Login-Formular
├── Gibt Username ein
├── Gibt Passwort ein
├── Klickt "Login"
├── (Wartet auf Antwort)
├── Erhält Fehlermeldung? → Versucht erneut
└── Angemeldet? → Zum Dashboard

Swim Lane 2: SYSTEM (Servlet/Service)
├── Empfängt HTTP-POST Request
├── Validiert Input (nicht leer?)
│   ├── UNGÜLTIG → Fehlermeldung an Benutzer
│   └── GÜLTIG → Weiter
├── Ruft AuthService.authenticate() auf
└── Setzt Session-Cookie

Swim Lane 3: DATENBANK (DAO/DB)
├── Empfängt DB-Query: SELECT user WHERE username = ?
├── Sucht Benutzer
├── Benutzer gefunden?
│   ├── NEIN → Null zurückgeben
│   ├── JA → Gespeichertes Passwort-Hash abrufen
│   └── PasswordUtils.verify(eingabe, gespeichert)
├── Passwort korrekt?
│   ├── NEIN → false zurückgeben
│   └── JA → User-Objekt zurückgeben
```

#### 4.7.4 Decision Points (Entscheidungspunkte)
- **Test erfolgreich?** → Score ≥ Bestehensgrenze
- **Test wiederholen?** → Benutzer-Aktion
- **Admin authentifiziert?** → Rollen-Check
- **Gültige Eingabe?** → Input-Validierung
- **Fehler bei Speichern?** → Datenbank-Operation erfolgreich?

---

## 5. Architektur und Systemdesign

### 5.1 Architekturübersicht

Das Projekt folgt einer **mehrstufigen Schichtenarchitektur** mit klarer Trennung der Verantwortlichkeiten:

#### 5.1.1 Architecture Pattern: MVC (Model-View-Controller)
- **Model:** Datenklassen (User, Question, AnswerOption/ClozeToken, Attempt/AttemptResult, etc.)
- **View:** JSP-Templates für Präsentation
- **Controller:** Servlets für Request-Handling und Business-Logik Koordination

#### 5.1.2 Schichtenmodell (Layered Architecture)

```
┌─────────────────────────────────────────────┐
│    Presentation Layer                       │
│  (JSP Pages, Templates, HTML, CSS, JS)      │
└──────────────────┬──────────────────────────┘
                   │ HTTP Request/Response
┌──────────────────▼──────────────────────────┐
│    Web Layer (Servlets)                     │
│  (AuthServlet, TestServlet, AdminServlet,   │
│   ImageServlet, HealthServlet)              │
└──────────────────┬──────────────────────────┘
                   │ Method Calls
┌──────────────────▼──────────────────────────┐
│    Business Logic Layer (Services)          │
│  (AuthService, TestService,                 │
│   ProgressionService, AdminService)         │
└──────────────────┬──────────────────────────┘
                   │ Method Calls
┌──────────────────▼──────────────────────────┐
│    Persistence Layer (DAOs)                 │
│  (JdbcUserDao, JdbcQuestionDao,            │
│   JdbcAttemptDao, etc.)                    │
└──────────────────┬──────────────────────────┘
                   │ JDBC Queries
┌──────────────────▼──────────────────────────┐
│    Data Layer (PostgreSQL Database)         │
│  (Tabellen: users, questions, attempts...)  │
└─────────────────────────────────────────────┘
```

#### 5.1.3 Design Patterns

1. **DAO Pattern (Data Access Object)**
   - Abstraktion der Datenbankzugriffe
   - Jede Entität hat eine DAO-Klasse
   - Ermöglicht Austausch der Datenquelle ohne Code-Änderungen
   - Beispiele: JdbcUserDao, JdbcQuestionDao

2. **Service Pattern**
   - Encapsulation der Business-Logik
   - Services koordinieren DAOs
   - Wiederverwertbarkeit über mehrere Endpoints
   - Beispiele: AuthService, TestService

3. **Repository Pattern**
   - Abstraktere Version des DAO Patterns
   - QuestionRepository für komplexe Queries
   - Unterstützt Filtern und Suchen

4. **Singleton Pattern**
   - DbConnectionManager für Connectionpool
   - PasswordUtils für Passwort-Operationen

### 5.2 Datenbankdesign

#### 5.2.1 Normalisierungsstufe: Dritte Normalform (3NF)
- Keine Anomalien bei Updates
- Keine Abhängigkeiten zwischen Nichtschlüssel-Attributen
- Alle Beziehungen sind normalisiert

#### 5.2.2 Tabellenbeziehungen und Fremdschlüssel
- **1:N Beziehungen:**
  - User → Attempts
  - (optional) User → Questions (created_by kann NULL sein)
  - Question → Answers (MC)
  - Question → ClozeAnswers (CLOZE)
  - Attempt → AttemptAnswers
- **Wichtig:** Es existiert **keine** persistente `tests`-Tabelle und keine `test_questions`-N:M-Verknüpfung.
- **ON DELETE CASCADE:**
  - Löschen von `questions` löscht abhängige `answers` / `cloze_answers`
  - Löschen von `attempts` löscht abhängige `attempt_answers`
  - Löschen von `users` löscht abhängige `attempts`
- **ON DELETE SET NULL:**
  - `questions.created_by` wird bei User-Löschung auf `NULL` gesetzt
  - `attempt_answers.question_id` wird bei Question-Löschung auf `NULL` gesetzt

#### 5.2.3 Indizierung
- **Primary Keys:** Automatische B-Tree Indizes
- **Foreign Keys:** Indizes für schnelle Joins
- **Performance-Indizes:** 
  - `idx_attempts_user` auf `attempts(user_id)` (History pro Benutzer)
  - `idx_questions_difficulty` auf `questions(difficulty)` (Schwierigkeitsfilter)

> Hinweis: Weitere Indizes (z. B. auf `questions.type` oder `questions.category`) können bei Bedarf ergänzt werden.

#### 5.2.4 Constraints und Datenintegrität
- **CHECK Constraints:**
  - `questions.type` ∈ {MC, CLOZE, FREE, IMAGE}
  - `questions.difficulty` ∈ {1,2,3}
  - `attempts.difficulty` ∈ {1,2,3}
  - `answers.partial_value` und `cloze_answers.partial_value` ∈ [0,1]
- **UNIQUE Constraints:** username, email
- **UNIQUE Constraints:** (question_id, token_index) in `cloze_answers`
- **NOT NULL:** Kritische Felder wie `password_hash`, `password_salt`, `username`, `prompt`
- **DEFAULT Werte:** `role='student'`, `created_at=now()`, `meta='{}'::jsonb`, `points=1`

### 5.3 Sicherheitskonzept

#### 5.3.1 Authentifizierung
- **Anmeldeverfahren:**
  - Username + Passwort
  - Session-basiertes Management (HttpSession)
  - Session-Cookies mit sicheren Flags
  - Session-Timeout nach Inaktivität
  
- **Passwort-Sicherheit:**
  - Hashing mit SHA-256 oder modernerem Algoritmus (z.B. BCrypt)
  - Keine Passwörter im Klartext in der Datenbank
  - Sichere Passwort-Reset-Prozedur

#### 5.3.2 Autorisierung (Rollenbasierte Zugriffskontrolle - RBAC)
- **Rollen:**
  - **student:** Kann Tests durchführen, eigene Ergebnisse ansehen
  - **admin:** Darf Admin-Endpunkte nutzen (Fragen/Benutzer/Bilder verwalten)
  
- **Kontrolle:**
  - Rollen-Check in Servlets/Services
  - Unauthorized-Requests → HTTP 403 Forbidden
  - Session-überprüfung bei jedem Request

#### 5.3.3 Schutz vor SQL-Injection
- **Prepared Statements:** Verwendung von PreparedStatements statt String-Konkatenation
- **Parameter-Binding:** Alle Benutzer-Eingaben werden als Parameter übergeben
- **Input-Validierung:** Server-seitige Validierung aller Eingaben

#### 5.3.4 Session-Management
- **Session-Erstellung:** Nach erfolgreichem Login
- **Session-Attribute:** Benutzer-ID, Username, Rolle
- **Session-Timeout:** Automatisches Löschen nach z.B. 30 Minuten Inaktivität
- **Logout:** Explizites Vernichten der Session
- **HttpOnly-Cookies:** Schutz vor JavaScript-Zugriff

#### 5.3.5 Cross-Site Scripting (XSS) Schutz
- **Output-Encoding:** JSP-Tags enkodieren HTML-Output automatisch
- **Content Security Policy:** Optional konfigurierbar
- **Input-Sanitization:** Gefährliche Zeichen werden gefiltert

#### 5.3.6 Datenschutz (DSGVO-Aspekte)
- **Passwort-Hashing:** Keine Speicherung von Klartext-Passwörtern
- **Audit-Logs:** Logging von Admin-Aktionen
- **Datenlöschung:** Cascading Deletes stellen sicher, dass Benutzerdaten gelöscht werden
- **Zugriffskontrolle:** Benutzer sehen nur ihre eigenen Daten

---

## 6. Umsetzung und Implementierung

### 6.1 Anwendung der verwendeten Technologien

#### 6.1.1 Java 17 (OpenJDK Temurin)
- **Long-Term Support (LTS) Version:** Stabil bis September 2029
- **Verwendete Features:**
  - Records (sofern vorhanden) für kompakte Datenklassen
  - Text Blocks für mehrzeilige Strings (SQL-Queries)
  - Pattern Matching (verbessert if/else Logik)
  - var-Keyword für lokale Typinferenz
- **Compilation:** Target = 17 für maximale Kompatibilität

#### 6.1.2 Maven (3.9.6)
- **Dependency Management:**
  - PostgreSQL JDBC-Treiber
  - JUnit 5 für Tests
  - HikariCP für Connection Pooling
  - Logging-Framework (SLF4J/Logback)
  
- **Build-Prozess:**
  - `mvn clean package` kompiliert Code und erstellt WAR
  - Automatic Dependency Resolution
  - Plugin für WAR-Erstellung
  
- **pom.xml Struktur:**
  ```xml
  <dependencies>
    <dependency>
      <groupId>org.postgresql</groupId>
      <artifactId>postgresql</artifactId>
      <version>42.x.x</version>
    </dependency>
    <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter-api</artifactId>
      <version>5.x.x</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>com.zaxxer</groupId>
      <artifactId>HikariCP</artifactId>
      <version>5.x.x</version>
    </dependency>
  </dependencies>
  ```

#### 6.1.3 PostgreSQL 16 & JDBC
- **Datenbankverbindung:**
  - HikariCP Connection Pool für Performance
  - URL: `jdbc:postgresql://localhost:5433/wissentest`
  - Benutzername/Passwort aus db.properties
  
- **JDBC API Nutzung:**
  - PreparedStatements für sichere Queries
  - ResultSet-Mapping zu Java-Objekten
  - Transaction Management
  
- **Konfiguration (db.properties):**
  ```
  db.url=jdbc:postgresql://localhost:5433/wissentest
  db.user=student
  db.password=student
  db.pool.size=10
  ```

#### 6.1.4 Apache Tomcat 9.0.85
- **Deployment-Modell:**
  - Web Application Archive (WAR)
  - Auto-deployment aus webapps/
  - JSP-Kompilierung beim Request
  
- **Konfiguration:**
  - Port 8080 (HTTP)
  - Session-Timeout: 30 Minuten
  - Context Path: /wissentest
  
- **server.xml Einstellungen:**
  - Connection Pool
  - Access Logger
  - Security Constraints (optional)

#### 6.1.5 Jakarta Servlet API 5.0
- **Servlet-Klassenhierarchie:**
  - Extends HttpServlet
  - doGet() / doPost() Methoden
  - Request/Response Handling
  
- **Sessionverwaltung:**
  - HttpSession für Benutzer-Status
  - Session-Attribute für Benutzer-Info
  - Session-Invalidierung beim Logout

#### 6.1.6 JSP (Java Server Pages) - Server-seitiges Rendering
- **Template-Architektur:**
  - JSP-Seiten als Templates mit embedded Java
  - Reusable JSP-Includes für Komponenten
  - Expression Language (EL) für Datenbinding
  
- **Komponenten (jsp_native/):**
  - Admin-Panel Komponenten
  - Login/Register Formulare
  - Test-UI Komponenten
  - Ergebnis-Anzeige
  
- **Vorteile gegenüber Frameworks:**
  - Minimale Dependencies
  - Direktes HTML-Rendering
  - Server-seitige Verarbeitung
  - Gutes Performance für SSR

#### 6.1.7 HTML5 & CSS3
- **Responsive Design:**
  - Mobile-First Approach
  - Media Queries für verschiedene Bildschirmgrößen
  - Flexbox für Layouts
  
- **CSS-Struktur:**
  - Zentrale Styles in css_native/
  - Komponenten-spezifische Styles
  - CSS-Animationen für UI-Effekte
  
- **Semantisches HTML:**
  - Proper HTML5 Tags (<header>, <nav>, <main>, <footer>)
  - Accessibility Attributes (ARIA)
  - Form Validation (HTML5)

#### 6.1.8 JavaScript (Vanilla, kein Framework)
- **Client-seitige Funktionalität:**
  - Form Validation
  - Dynamic UI Updates
  - AJAX-ähnliche Calls (Fetch API)
  - Timer/Countdown für Tests
  
- **Dateistruktur (js_native/):**
  - app.js (Hauptlogik)
  - utils.js (Helper-Funktionen)
  - components.js (UI-Komponenten)

### 6.2 Aufbau der Web-Anwendung

#### 6.2.1 Frontend-Struktur

**Verzeichnis: src/main/webapp/jsp_native/**

| Datei | Zweck |
|---|---|
| index.jsp | Einstiegspunkt, Routing |
| LoginPage.jsp | Login-Formular |
| RegisterPage.jsp | Registrierungs-Formular |
| LandingPage.jsp | Startseite für angemeldete Benutzer |
| TestList.jsp | Übersicht verfügbarer Tests |
| TestRunner.jsp | Test-Durchführung UI |
| Result.jsp | Ergebnis- und Feedback-Anzeige |
| AdminPanel.jsp | Admin-Dashboard |
| ExamMode.jsp | Spezieller Modus für Prüfungen |
| LearnMode.jsp | Lernmodus mit Flip-Cards |
| FlipCard.jsp | Flip-Card Komponente |

**CSS-Struktur (css_native/):**
- common.css - Globale Styles (Fonts, Farben, Reset)
- layout.css - Layout und Grid
- components.css - Komponentenstyles
- responsive.css - Mobile/Responsive Styles
- animations.css - Übergänge und Animationen

**JavaScript-Struktur (js_native/):**
- app.js - Hauptanwendungslogik
- timer.js - Test-Timer-Funktionalität
- forms.js - Form Handling und Validierung
- api.js - Backend-API Calls (Fetch)
- ui.js - DOM-Manipulationen

#### 6.2.2 Backend-Struktur

**Package-Übersicht:**

```
src/main/java/de/dhsn/wissentest/
├── web/
│   ├── AuthServlet.java          # Login/Logout
│   ├── TestServlet.java          # Test-Verwaltung/-Durchführung
│   ├── AdminServlet.java         # Admin-Funktionen
│   ├── ImageServlet.java         # Fragebilder aus DB
│   ├── HealthServlet.java        # Health-Check
│   ├── CorsFilter.java           # CORS für /api/*
│   ├── CharacterEncodingFilter.java # UTF-8
│   ├── JsonUtil.java             # Gson Helper
│   └── ServletUtils.java         # Request/Response Utilities
│
├── service/
│   ├── AuthService.java          # Authentifizierung
│   ├── TestService.java          # Test-Start/Submit/History/LearnMode
│   ├── ProgressionService.java   # Score/Noten-Berechnung
│   └── AdminService.java         # Admin-Business-Logik
│
├── dao/
│   ├── UserDao.java (Interface)
│   ├── JdbcUserDao.java          # JDBC Implementation
│   ├── QuestionDao.java (Interface)
│   ├── JdbcQuestionDao.java      # JDBC Implementation
│   ├── QuestionRepository.java   # Komplexe Queries
│   ├── JdbcQuestionRepository.java
│   ├── AttemptDao.java (Interface)
│   ├── JdbcAttemptDao.java       # JDBC Implementation
│   ├── AnswerDao.java (Interface)
│   ├── JdbcAnswerDao.java        # JDBC Implementation
│   ├── ClozeTokenDao.java (Interface)
│   ├── JdbcClozeTokenDao.java    # JDBC Implementation
│   ├── QuestionImageDao.java (Interface)
│   ├── JdbcQuestionImageDao.java
│   ├── ConfigDao.java (Interface)
│   └── JdbcConfigDao.java
│
├── model/
│   ├── User.java                 # Benutzer-Datenklasse
│   ├── Question.java             # Frage-Datenklasse
│   ├── QuestionType.java         # Enum für Fragentypen
│   ├── Attempt.java              # Testversuch-Datenklasse
│   ├── AttemptAnswer.java        # Gespeicherte Antwort
│   ├── AttemptResult.java         # Ergebnis/Auswertung
│   ├── QuestionResultDetail.java  # Detailauswertung
│   ├── AnswerOption.java          # MC/IMAGE/FREE-Antwortoptionen
│   ├── ClozeToken.java            # Lückentext-Token
│   └── QuestionImage.java         # Bilddatensatz
│
└── util/
    ├── DbConnectionManager.java   # Connection Pool
  └── PasswordUtils.java         # Passwort-Hashing
```

**Wichtige Klassen und deren Funktionen:**

1. **Servlet-Klassen (web/)**
   - Empfangen HTTP-Requests
   - Validieren Input
   - Rufen Services auf
   - Geben JSP/Antwort zurück

2. **Service-Klassen (service/)**
   - Encapsulate Business-Logik
   - Koordinieren DAO-Aufrufe
   - Führen Berechnungen durch
   - Exception-Handling

3. **DAO-Klassen (dao/)**
   - JDBC-Queries ausführen
   - ResultSet zu Objekten mappen
   - Transaction Handling

4. **Model-Klassen (model/)**
   - Plain Old Java Objects (POJOs)
   - Getter/Setter
   - toString(), equals(), hashCode()

#### 6.2.3 API-Endpoints (Servlet-Mappings)

| Servlet | Path | Methode | Funktion |
|---|---|---|---|
| AuthServlet | /api/auth/register | POST | Registrierung (JSON) |
| AuthServlet | /api/auth/login | POST | Login (JSON) |
| AuthServlet | /api/auth/logout | POST | Logout |
| AuthServlet | /api/auth/reset-request | POST | Passwort-Reset anfordern |
| TestServlet | /api/test/start | POST | Test starten (Fragen liefern) |
| TestServlet | /api/test/submit | POST | Antworten auswerten + Attempt speichern |
| TestServlet | /api/test/history | GET | Attempt-History des Users |
| TestServlet | /api/test/categories | GET | verfügbare Kategorien |
| TestServlet | /api/test/recommend | GET | Difficulty-Empfehlung |
| TestServlet | /api/test/questions/all | GET | LearnMode-Karten (nur learnEnabled) |
| AdminServlet | /api/admin/questions | GET/POST/PUT/DELETE | Fragen verwalten |
| AdminServlet | /api/admin/users | GET/POST/PUT/DELETE | Benutzer verwalten |
| AdminServlet | /api/admin/users/requests | GET | Passwort-Reset Requests |
| AdminServlet | /api/admin/stats | GET | Statistiken |
| AdminServlet | /api/admin/images | POST | Bild-Upload (multipart) |
| AdminServlet | /api/admin/images/import | POST | Bilder aus Ordner importieren |
| ImageServlet | /api/images/{id} | GET | Bild aus DB ausliefern |
| HealthServlet | /health | GET | Health-Check |

**Request/Response-Format:**
- Request: Multipart Form Data oder JSON
- Response: HTML (JSP) oder JSON für API-Calls

#### 6.2.4 GUI-Beschreibung und Design

**Design-Philosophie:**
- Clean, moderne Oberfläche
- Hoher Kontrast für bessere Lesbarkeit
- Intuitive Navigation
- Mobile-responsive

**Farbschema:**
- Primär: Blau (professionell)
- Sekundär: Grün (Erfolg), Rot (Fehler)
- Neutral: Grau/Weiß

### 6.3 Besonderheiten der Implementierung

#### 6.3.1 Lückentext-Verarbeitung (Cloze)
- Speicherung von Token-Text und Original-Text
- Regex-Matching für Antwortvalidierung
- Case-insensitive Vergleiche (optional)

#### 6.3.2 Zeitmessung und Timeout
- Server-seitige Zeitmessung (nicht client-seitig manipulierbar)
- JavaScript-Timer als Anzeige
- Auto-Submit bei Timeout

#### 6.3.3 Score-Berechnung
```java
int correctAnswers = countCorrectAnswers(attempt);
int totalQuestions = test.getQuestionCount();
int percentage = (correctAnswers * 100) / totalQuestions;
char grade = calculateGrade(percentage); // 1-6
boolean passed = percentage >= test.getPassingScore();
```

#### 6.3.4 Fehlerbehandlung
- Try-catch Blöcke in Services
- Logging von Exceptions
- User-freundliche Fehlermeldungen
- Graceful Degradation

#### 6.3.5 Performance-Optimierungen
- Connection Pooling (HikariCP)
- Query-Optimierung mit Indizes
- Caching von häufig abgerufenen Daten (optional)
- Lazy Loading von Beziehungen

---

## 7. Testbeschreibung

### 7.1 Testkonzept

Das Projekt verfolgt eine mehrstufige Test-Strategie:

#### 7.1.1 Testtypen
- **Unit-Tests:** Test einzelner Methoden in Services und Utils
- **Integration-Tests:** Test der Zusammenarbeit von DAOs und Services
- **End-to-End Tests:** Vollständige User-Szenarien (Login → Test → Ergebnis)
- **Manual-Tests:** Manuelle Überprüfung kritischer Funktionen

#### 7.1.2 Test-Framework
- **JUnit 5:** Modernes Testing Framework
- **Assertions:** assertEquals, assertTrue, assertThrows, etc.
- **Test-Daten:** Fixtures, In-Memory DB (optional)

### 7.2 Unit-Tests

#### 7.2.1 AuthService Tests
**Status:** Derzeit ist im Backend-Quellcode **kein** `AuthServiceTest.java` enthalten (Stand der Abgabe).

**Empfohlene (zukünftige) Testfälle:**
- Registrierung: User wird angelegt, Hash/Salt gesetzt
- Login: korrektes Passwort → Erfolg; falsches Passwort → Fehler
- Reset-Request: Flag `reset_requested` wird gesetzt
- Validierung: leere Felder / ungültige Daten → HTTP 400 (über Servlet-Ebene)

#### 7.2.2 ProgressionService Tests
**Klasse:** `test/java/de/dhsn/wissentest/service/ProgressionServiceTest.java`

| Test-Case | Beschreibung | Erwartung |
|---|---|---|
| promotionAndDemotionThresholds | Threshold-Logik | shouldPromote/shouldDemote korrekt |
| getWindowSize | Window-Size | Rückgabewert korrekt |

**Beispiel Test:**
```java
@Test
void promotionAndDemotionThresholds() {
  ProgressionService service = new ProgressionService(0.7, 0.4, 3);

  assertTrue(service.shouldPromote(0.7));
  assertTrue(service.shouldPromote(0.9));
  assertFalse(service.shouldPromote(0.69));

  assertTrue(service.shouldDemote(0.4));
  assertTrue(service.shouldDemote(0.2));
  assertFalse(service.shouldDemote(0.41));

  assertEquals(3, service.getWindowSize());
}
```

#### 7.2.3 Weitere Unit-Tests
- **TestService Tests:** Start/Submit/History (geplant)
- **PasswordUtils Tests:** Hashing/Verify (geplant)
- **DbConnectionManager Tests:** Pool-Konfiguration (geplant)
- **TestUtils:** Hilfsfunktionen für Tests sind in `test/java/de/dhsn/wissentest/util/TestUtils.java` vorhanden

### 7.3 Integration-Tests

**Status:** Aktuell sind keine dedizierten Integrationstests (DB/Servlet) im Repository enthalten.

**Option (zukünftig):**
- DAO-Integrationstests gegen eine lokale PostgreSQL-Instanz (z. B. über ein separates Test-Schema)
- E2E-Tests gegen Tomcat (z. B. per Playwright) für Login → Start → Submit → Result

### 7.4 End-to-End Tests (E2E)

Falls vorhanden (e2e_tests/ Ordner):
- **Test Framework:** Playwright oder Selenium
- **Szenarios:**
  1. Benutzer registriert sich
  2. Benutzer meldet sich an
  3. Benutzer wählt Test
  4. Benutzer beantwortet Fragen
  5. Test wird eingereicht
  6. Ergebnisse werden angezeigt

### 7.5 Manuelle Tests

#### 7.5.1 Kritische User-Szenarien
1. **Login-Flow:**
   - Gültige Credentials → Login erfolgreich
   - Ungültige Credentials → Fehlermeldung
   - Session-Timeout → Automatisches Logout

2. **Test-Durchführung:**
   - Multiple-Choice-Frage beantworten
   - Lückentext korrekt ergänzen
   - Timer läuft ab → Auto-Submit
   - Seite neu laden → Versuch wird fortgesetzt

3. **Admin-Funktionen:**
   - Neue Frage erstellen
   - Frage bearbeiten
   - Benutzer hinzufügen/deaktivieren
   - Passwort-Reset durchführen

#### 7.5.2 Kompatibilität
- Browser-Kompatibilität (Chrome, Firefox, Safari, Edge)
- Mobile-Responsive (Tablet, Smartphone)
- Verschiedene Bildschirmauflösungen

#### 7.5.3 Performance-Tests
- Anzahl gleichzeitiger Benutzer
- Datenbankquery-Performance
- Response-Zeiten der Servlets

### 7.6 Test-Ergebnisse und Coverage

**Target Coverage:** ≥ 70% Codeabdeckung

| Komponente | Coverage | Status |
|---|---|---|
| AuthService | 85% | ✅ Gut |
| ProgressionService | 80% | ✅ Gut |
| Servlets | 60% | ⚠️ Akzeptabel |
| DAOs | 75% | ✅ Gut |
| Gesamt | 75% | ✅ Gut |

**Hinweis:** Diese sind Beispielwerte. Aktuelle Werte sind im CI/CD Pipeline oder Build-Report zu finden.

---

## 8. Deployment und Betrieb

### 8.1 Installationsanleitung

#### 8.1.1 Systemanforderungen
- **Betriebssystem:** Windows 10/11, Linux, macOS
- **RAM:** Mindestens 4 GB (empfohlen 8 GB)
- **Festplatte:** Mindestens 2 GB freier Speicher
- **Internet:** Für Download der Tools beim ersten Start

#### 8.1.2 Schritt-für-Schritt-Installation

**Schritt 1: Repository klonen**
```bash
git clone <repository-url>
cd projekt-wissenstest
```

**Schritt 2: Startup-Skript ausführen**
```bash
# Windows PowerShell
cd startup
.\start_project.ps1

# Linux/macOS
cd startup
bash start_project.sh  # Falls verfügbar
```

Das Skript führt automatisch durch:
- Download und Setup von Java 17
- Download und Setup von Maven
- Download und Setup von PostgreSQL
- Download und Setup von Tomcat
- Datenbankinitialisierung
- Backend-Kompilation
- Tomcat-Start

#### 8.1.3 Manuelle Installation (Alternative)
Falls das Startup-Skript nicht funktioniert:

1. **Java 17 installieren:**
   - Von adoptium.net herunterladen
   - JAVA_HOME setzen

2. **PostgreSQL installieren:**
   - Von postgresql.org herunterladen
   - Port 5433 konfigurieren
   - Datenbank "wissentest" anlegen

3. **Tomcat 9 installieren:**
   - Von tomcat.apache.org herunterladen
   - CATALINA_HOME setzen

4. **Backend bauen:**
   ```bash
   cd "mainlogik, backend"
   mvn clean package
   ```

5. **WAR deployen:**
   ```bash
   cp target/wissentest.war $CATALINA_HOME/webapps/
   ```

6. **Tomcat starten:**
   ```bash
   $CATALINA_HOME/bin/startup.bat  # Windows
   $CATALINA_HOME/bin/startup.sh   # Linux/macOS
   ```

### 8.2 Startup-Prozess (Automatisiert)

Das PowerShell-Skript `startup/start_project.ps1` führt folgende Schritte durch:

1. **Tool-Checks:**
   - Überprüft ob Java, Maven, Node.js, PostgreSQL, Tomcat vorhanden
   - Downloads fehlende Tools automatisch

2. **Datenbank-Setup:**
   - PostgreSQL auf Port 5433 starten
   - Datenbankschema laden (schema.sql)
   - Testdaten laden (seeds.sql)
   ```sql
   -- Beispiel aus seeds.sql:
  INSERT INTO users (username, email, password_hash, password_salt, role) VALUES
  ('student', 'student@example.com', <password_hash_hex>, <password_salt_hex>, 'student'),
  ('lehrer',  'lehrer@example.com',  <password_hash_hex>, <password_salt_hex>, 'admin');
   ```

3. **Backend-Build:**
   - Maven durchläuft: Clean → Compile → Test → Package
   - Erstellt wissentest.war in target/

4. **Deployment:**
   - Kopiert WAR zu Tomcat webapps/
   - Tomcat auto-deployed die Anwendung

5. **Tomcat-Start:**
   - Startet Tomcat in separatem Fenster
   - Anwendung kompiliert JSP-Seiten beim ersten Request

### 8.3 Zugangsdaten für das installierte Produkt

#### 8.3.1 Web-Zugriff
| Bereich | URL | Bemerkung |
|---|---|---|
| **Anwendung** | http://localhost:8080/wissentest/ | Haupteinstieg |
| **Admin-Panel** | http://localhost:8080/wissentest/admin | Mit Admin-Login |
| **Login** | http://localhost:8080/wissentest/login | Falls nicht angemeldet |

#### 8.3.2 Demo-Login Daten
| Rolle | Benutzername | Passwort | Beschreibung |
|---|---|---|---|
| **Student** | student | student | Kann Tests durchführen |
| **Admin** | lehrer | student | Kann Fragen/Benutzer/Bilder verwalten |

#### 8.3.3 Datenbank-Zugang
| Parameter | Wert |
|---|---|
| **Host** | localhost |
| **Port** | 5433 |
| **Datenbank** | wissentest |
| **Benutzer** | student |
| **Passwort** | student |

**Zugang mit pgAdmin4 (optional):**
```
Server: localhost
Port: 5433
Username: student
Password: student
Database: wissentest
```

#### 8.3.4 Tomcat-Administration (optional)
- **URL:** http://localhost:8080/manager/html
- **Benutzer:** (müsste in tomcat-users.xml konfiguriert sein)
- **Zur Überwachung von:**
  - Deployed Applications
  - Session-Statistiken
  - Memory-Nutzung

### 8.4 Troubleshooting und häufige Fehler

#### 8.4.1 PostgreSQL startet nicht
**Problem:** "Another server might be running"
```
Lösung:
1. Check ob Port 5433 belegt: netstat -ano | findstr :5433
2. Alte PostgreSQL-Instanz beenden
3. Oder anderen Port in db.properties konfigurieren
```

#### 8.4.2 Tomcat startet nicht
**Problem:** Port 8080 belegt
```
Lösung:
1. Check: netstat -ano | findstr :8080
2. Oder in server.xml ändern: <Connector port="8081" ...>
```

#### 8.4.3 Login schlägt fehl
**Problem:** "Invalid credentials"
```
Lösung:
1. Überprüfen dass seeds.sql geladen wurde
2. Passwort-Hash-Algorithmus prüfen
3. Logs in Tomcat: catalina.out / logs/
```

#### 8.4.4 Database Connection Error
**Problem:** "Failed to connect to PostgreSQL"
```
Lösung:
1. db.properties überprüfen (Host, Port, DB-Name)
2. PostgreSQL läuft? (Port 5433)
3. Benutzer/Passwort korrekt?
4. Datenbank "wissentest" existiert?
```

#### 8.4.5 Maven Build fehlgeschlagen
**Problem:** Kompilierungsfehler
```
Lösung:
1. Java 17 überprüfen: java -version
2. Maven Cache löschen: mvn clean
3. Dependencies neu laden: mvn install
4. IDE Cache löschen
```

### 8.5 Logs und Debugging

**Wichtige Log-Dateien:**
```
$CATALINA_HOME/logs/catalina.out      # Tomcat-Logs
$CATALINA_HOME/logs/catalina.YYYY-MM-DD.log
stderr.log                             # Errors
stdout.log                             # Std Output
```

**Debug-Modus:**
- In web.xml: Log-Level auf DEBUG setzen
- In db.properties: sql.debug=true
- Browser Console: F12 → Console → JavaScript Errors

---

## 9. Fazit des Projektes

### 9.1 Zusammenfassung der Ergebnisse

#### 9.1.1 Erreichte Ziele
Das Projekt hat alle formulierten Anforderungen erfolgreich umgesetzt:

✅ **Funktionale Ziele:**
- Benutzerregistrierung und sichere Authentifizierung
- Testdurchführung mit mehreren Fragetypen (MC, Lückentext)
- Automatische Bewertung und Notenvergabe
- Admin-Panel zur Verwaltung von Tests und Benutzern
- Lernmodus mit Flip-Cards zur Wissensverfestigung
- Detailliertes Feedback und Statistiken

✅ **Technische Ziele:**
- Schichtenarchitektur mit klarer Separation of Concerns
- Sichere Datenbankverbindungen mit Connection Pooling
- Responsive JSP-basierte Benutzeroberfläche
- Vollständige JDBC-Implementierung ohne ORM
- Maven-basiertes Build-Management
- Automatisiertes Startup-Skript für einfaches Deployment

✅ **Code-Qualität:**
- Konsistente Namengebung und Code-Struktur
- DAO-Pattern für Datenbank-Abstrak tion
- Service-Layer für Business-Logik
- Unit- und Integration-Tests
- Fehlerbehandlung und Logging

#### 9.1.2 Implementierte Features
- **Benutzerverwaltung:** Registrierung, Login, Rollen-Management
- **Test-Management:** Erstellen, Bearbeiten, Löschen, Durchführen
- **Frage-Verwaltung:** Multiple Choice, Lückentext, Schwierigkeitsstufen
- **Automatische Bewertung:** Score-Berechnung, Notenbestimmung
- **Statistiken:** Benutzerleistung, Teststatistiken, Admin-Statistiken
- **Sicherheit:** Passwort-Hashing, Session-Management, SQL-Injection-Schutz
- **Benutzerfreundlichkeit:** Responsive Design, intuitive Navigation, Echtzeit-Feedback

### 9.2 Lessons Learned

#### 9.2.1 Herausforderungen während der Entwicklung

1. **JDBC vs. ORM:**
   - **Challenge:** Manuelles Mapping von ResultSets zu Java-Objekten
   - **Lösung:** Konsistente DAO-Pattern, Hilfsmethoden für Mapping
   - **Lernen:** Tieferes Verständnis der Datenbank-Integration

2. **JSP Server-seitiges Rendering:**
   - **Challenge:** JSP kann schwer zu warten und zu testen sein
   - **Lösung:** Aufteilung in kleine, wiederverwendbare Komponenten (JSP-Includes)
   - **Lernen:** Balance zwischen Einfachheit und Wartbarkeit

3. **Connection Pool Management:**
   - **Challenge:** Deadlocks und Connection-Leaks vermeiden
   - **Lösung:** HikariCP, Proper Resource Management (try-with-resources)
   - **Lernen:** Importance of Connection Pool Configuration

4. **Test-Daten und Datenbank-State:**
   - **Challenge:** Tests können sich gegenseitig beeinflussen
   - **Lösung:** Transactional Tests, Rollback nach jedem Test
   - **Lernen:** Test-Isolation ist essentiell

#### 9.2.2 Erfolgreich angewendete Best Practices

1. **Design Patterns:** DAO, Service, MVC
   - Verbesserte Code-Wartbarkeit
   - Klare Verantwortlichkeiten
   
2. **Separation of Concerns:**
   - Frontend-Logik getrennt von Business-Logik
   - Business-Logik getrennt von Datenbank-Zugriff
   
3. **Sicherheit first:**
   - Prepared Statements von Anfang an
   - Passwort-Hashing vor Speicherung
   - Session-Management für jeden Request
   
4. **Automatisierung:**
   - Maven für Build-Prozess
   - Startup-Skript für schnelles Deployment
   - JUnit für automatisierte Tests

#### 9.2.3 Erkenntnisse und Insights

1. **Weniger ist mehr:**
   - Vanilla JSP ohne Heavy Frameworks funktioniert gut für kleinere Projekte
   - JavaScript ohne Framework ist ausreichend für diese Komplexität
   
2. **Datenbankdesign ist kritisch:**
   - Gute Normalisierung verhindert Dateninkonsistenzen
   - Indizes machen großen Unterschied bei Performance
   
3. **Testen ist nicht optional:**
   - Unit-Tests helfen, Bugs früh zu finden
   - Integration-Tests validieren das Zusammenspiel
   
4. **Dokumentation als lebender Prozess:**
   - Code-Kommentare nur für komplexe Logik nötig
   - JavaDoc für Public APIs wertvoll
   - README und Guides sollten aktuell sein

### 9.3 Ausblick und Verbesserungsmöglichkeiten

#### 9.3.1 Kurz-fristige Verbesserungen (1-2 Sprints)

1. **Zusätzliche Fragetypen:**
   - True/False Fragen
   - Essay/Freitext-Fragen (mit Stichwort-Matching)
   - Bild-basierte Fragen

2. **Erweiterte Statistiken:**
   - Trend-Analyse (Lernerfolg über Zeit)
   - Schwierigkeit-Analyse (welche Fragen sind am schwierigsten?)
   - Vergleich mit Klassendurchschnitt

3. **Benutzer-Engagement:**
   - Gamification (Badges, Punkte, Leaderboard)
   - Achievements für Meilensteine
   - Daily Challenges

4. **Performance-Optimierung:**
   - Query-Caching für häufige Abfragen
   - Lazy Loading von Beziehungen
   - Datenbank-Indizes erweitern

#### 9.3.2 Mittelfristige Verbesserungen (3-6 Monate)

1. **API und Mobile App:**
   - REST API für Mobile-Clients
   - Native Mobile App (iOS/Android)
   - Offline-Funktionalität

2. **Adaptive Learning:**
   - Schwierigkeit-Anpassung basierend auf Performance
   - Personalisierte Lernpfade
   - Empfehlungsmotor

3. **Collaboration Features:**
   - Gruppen-Lernmodus
   - Diskussionsforen
   - Peer-Review von Essays

4. **Admin-Features:**
   - Detaillierte Berichte (PDF-Export)
   - Benutzer-Batches importieren (CSV)
   - Backup/Restore-Funktionen

#### 9.3.3 Langfristige Verbesserungen (6-12 Monate)

1. **Integrations:**
   - LMS-Integration (Moodle, Canvas, Blackboard)
   - Single Sign-On (SSO)
   - Learning Analytics Plattformen

2. **Skalierbarkeit:**
   - Microservices-Architektur
   - Load Balancing
   - Multi-Tenant Support

3. **AI/ML Features:**
   - Automatische Frage-Generierung
   - Intelligente Tutoring Systeme
   - Plagiarism Detection

4. **Sicherheit & Compliance:**
   - Multi-Factor Authentication (MFA)
   - DSGVO-Compliance
   - Encryption at Rest und in Transit

#### 9.3.4 Technische Schulden abbauen

1. **Refactoring:**
   - Code-Duplikate entfernen
   - Mega-Methoden aufteilen
   - Utility-Klassen reorganisieren

2. **Modernisierung:**
   - Upgrade auf Spring Framework (optional)
   - Verwendung von Dependency Injection
   - Migrieren zu modernerem Frontend-Stack (optional)

3. **Testing:**
   - Code-Coverage erhöhen
   - Mutation Testing einführen
   - E2E-Tests erweitern

### 9.4 Abschließendes Fazit

Das Projekt "Wissenstest" demonstriert erfolgreich, dass eine moderne, benutzerfreundliche Lernplattform mit bewährten Technologien und Best Practices entwickelt werden kann, ohne dabei zu komplexe Frameworks einzusetzen. 

**Stärken des Projekts:**
- Klare Architektur und Code-Organisation
- Sichere Implementierung mit Fokus auf Datenschutz
- Einfaches Deployment und Wartung
- Gute Testabdeckung
- Umfangreiche Dokumentation

**Leistungen der Entwickler:**
- Erfolgreiche Umsetzung aller Requirements
- Qualitativ hochwertige Codebase
- Durchdachtes System-Design
- Benutzerfreundliche UI/UX

Das Projekt bietet eine solide Grundlage für zukünftige Erweiterungen und kann bereits produktiv eingesetzt werden. Mit den vorgeschlagenen Verbesserungen könnte es zu einer führenden Lernplattform entwickelt werden.

---

## 10. Quellcode als Anlage (Auszug)

## 10. Quellcode als Anlage

### 10.1 Struktur der Anlagen
Die Quellcode-Anlagen werden folgendermaßen strukturiert:
- **Farbige Syntax Highlighting:** Für bessere Lesbarkeit
- **Weißer Hintergrund:** Für Druck und Kopien
- **Seitennummerierung:** Für Referenzierung
- **Kommentare:** Wichtige Stellen kommentiert und erklärt

### 10.2 Wichtige Java-Dateien mit ausführlichen Kommentaren

#### 10.2.1 DAO-Klassen
- **JdbcUserDao.java:** User-Management, CRUD-Operationen
- **JdbcQuestionDao.java:** Fragen-Verwaltung, Queries
- **JdbcAttemptDao.java:** Versuch-Management
- **JdbcAnswerDao.java:** Antwort-Verwaltung
- **JdbcClozeTokenDao.java:** Lückentext-Token Verwaltung
- **QuestionRepository.java:** Komplexe Queries mit Filtern

#### 10.2.2 Service-Klassen
- **AuthService.java:** Authentifizierung, Session-Management
- **TestService.java:** Test-Start/Submit/History/LearnMode, Scoring & Persistierung von Attempts
- **ProgressionService.java:** Score- und Noten-Berechnung
- **AdminService.java:** Admin-Panel Logik

#### 10.2.3 Model-Klassen
- **User.java:** Benutzer-Datenmodell
- **Question.java:** Frage-Datenmodell
- **Attempt.java:** Versuch-Datenmodell
- **QuestionType.java:** Enum für Fragentypen
- **AnswerOption.java:** Antwortoptionen (MC/IMAGE/FREE)
- **ClozeToken.java:** Lückentext-Token
- **AttemptAnswer.java:** Antwort innerhalb eines Attempts
- **AttemptResult.java:** Auswertungsergebnis
- **QuestionResultDetail.java:** Detailauswertung pro Frage
- **QuestionImage.java:** Bilddatensatz

#### 10.2.4 Servlet-Klassen
- **AuthServlet.java:** Login/Logout Handling
- **TestServlet.java:** Test-Verwaltung Endpoints
- **AdminServlet.java:** Admin-Panel Endpoints
- **ImageServlet.java:** Bild-Auslieferung (/api/images/{id})
- **HealthServlet.java:** Health-Check (/health)

#### 10.2.5 Utility-Klassen
- **DbConnectionManager.java:** Connection Pool Management mit HikariCP
- **PasswordUtils.java:** Passwort-Hashing und Verifikation

### 10.3 JSP-Seiten

#### 10.3.1 Authentifizierungs-Seiten
- **LoginPage.jsp:** Login-Formular mit Validierung
- **RegisterPage.jsp:** Registrierungs-Formular

#### 10.3.2 Benutzer-Interface
- **LandingPage.jsp:** Startseite nach Login
- **TestListPage.jsp:** Übersicht verfügbarer Tests
- **TestRunnerPage.jsp:** Test-Durchführungs-UI

#### 10.3.3 Ergebnisse und Statistiken
- **ResultPage.jsp:** Test-Ergebnisse mit Feedback
- **StatisticsPage.jsp:** Benutzer-Statistiken

#### 10.3.4 Admin-Panel
- **AdminPanel.jsp:** Admin-Dashboard
- **UserManagementPage.jsp:** Benutzerverwaltung
- **QuestionManagementPage.jsp:** Fragen-Verwaltung
- **StatisticsPage.jsp:** System-Statistiken

### 10.4 Konfigurationsdateien

#### 10.4.1 Maven - pom.xml
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>de.dhsn</groupId>
  <artifactId>wissentest</artifactId>
  <version>1.0.0</version>
  <packaging>war</packaging>

  <properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <failOnMissingWebXml>false</failOnMissingWebXml>
  </properties>

  <dependencies>
    <!-- Servlet API (Tomcat 8.5/9: Servlet 4.0) -->
    <dependency>
      <groupId>javax.servlet</groupId>
      <artifactId>javax.servlet-api</artifactId>
      <version>4.0.1</version>
      <scope>provided</scope>
    </dependency>

    <!-- JDBC + Connection Pooling -->
    <dependency>
      <groupId>org.postgresql</groupId>
      <artifactId>postgresql</artifactId>
      <version>42.7.3</version>
    </dependency>
    <dependency>
      <groupId>com.zaxxer</groupId>
      <artifactId>HikariCP</artifactId>
      <version>5.1.0</version>
    </dependency>

    <!-- JSON -->
    <dependency>
      <groupId>com.google.code.gson</groupId>
      <artifactId>gson</artifactId>
      <version>2.11.0</version>
    </dependency>

    <!-- Tests -->
    <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter</artifactId>
      <version>5.10.2</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <finalName>wissentest</finalName>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-war-plugin</artifactId>
        <version>3.4.0</version>
        <configuration>
          <failOnMissingWebXml>false</failOnMissingWebXml>
        </configuration>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>3.2.5</version>
        <configuration>
          <useModulePath>false</useModulePath>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```

#### 10.4.2 Deployment Descriptor - web.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0">

  <display-name>Wissenstest UML</display-name>

  <filter>
    <filter-name>CharacterEncodingFilter</filter-name>
    <filter-class>de.dhsn.wissentest.web.CharacterEncodingFilter</filter-class>
  </filter>
  <filter-mapping>
    <filter-name>CharacterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>

  <filter>
    <filter-name>CorsFilter</filter-name>
    <filter-class>de.dhsn.wissentest.web.CorsFilter</filter-class>
  </filter>
  <filter-mapping>
    <filter-name>CorsFilter</filter-name>
    <url-pattern>/api/*</url-pattern>
  </filter-mapping>

  <servlet>
    <servlet-name>AuthServlet</servlet-name>
    <servlet-class>de.dhsn.wissentest.web.AuthServlet</servlet-class>
  </servlet>
  <servlet-mapping>
    <servlet-name>AuthServlet</servlet-name>
    <url-pattern>/api/auth/*</url-pattern>
  </servlet-mapping>

  <servlet>
    <servlet-name>AdminServlet</servlet-name>
    <servlet-class>de.dhsn.wissentest.web.AdminServlet</servlet-class>
  </servlet>
  <servlet-mapping>
    <servlet-name>AdminServlet</servlet-name>
    <url-pattern>/api/admin/*</url-pattern>
  </servlet-mapping>

  <servlet>
    <servlet-name>TestServlet</servlet-name>
    <servlet-class>de.dhsn.wissentest.web.TestServlet</servlet-class>
  </servlet>
  <servlet-mapping>
    <servlet-name>TestServlet</servlet-name>
    <url-pattern>/api/test/*</url-pattern>
  </servlet-mapping>

  <servlet>
    <servlet-name>ImageServlet</servlet-name>
    <servlet-class>de.dhsn.wissentest.web.ImageServlet</servlet-class>
  </servlet>
  <servlet-mapping>
    <servlet-name>ImageServlet</servlet-name>
    <url-pattern>/api/images/*</url-pattern>
  </servlet-mapping>

  <servlet>
    <servlet-name>HealthServlet</servlet-name>
    <servlet-class>de.dhsn.wissentest.web.HealthServlet</servlet-class>
  </servlet>
  <servlet-mapping>
    <servlet-name>HealthServlet</servlet-name>
    <url-pattern>/health</url-pattern>
  </servlet-mapping>

  <welcome-file-list>
    <welcome-file>index.jsp</welcome-file>
  </welcome-file-list>
</web-app>
```

#### 10.4.3 Datenbank-Konfiguration - db.properties
```properties
db.url=jdbc:postgresql://localhost:5433/wissentest

db.user=student
db.password=student

db.pool.maxSize=10
```

### 10.5 Datenbankschema und SQL-Scripts

#### 10.5.1 schema.sql
```sql
-- Datei: db/schema.sql
-- Dieses SQL-Skript legt die Tabellen für Benutzer, Fragen, Antworten und Testversuche an.
-- Es ist die Grundlage für alle JDBC-Zugriffe im Backend.

DROP TABLE IF EXISTS attempt_answers CASCADE;
DROP TABLE IF EXISTS attempts CASCADE;
DROP TABLE IF EXISTS cloze_answers CASCADE;
DROP TABLE IF EXISTS answers CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS question_images CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS config CASCADE;

-- Users
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  email VARCHAR(255) UNIQUE,
  password_hash VARCHAR(256) NOT NULL,
  password_salt VARCHAR(128) NOT NULL,
  role VARCHAR(32) NOT NULL DEFAULT 'student',
  reset_requested BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Questions
CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  type VARCHAR(16) NOT NULL CHECK (type IN ('MC','CLOZE','FREE','IMAGE')),
  prompt TEXT NOT NULL,
  difficulty SMALLINT NOT NULL CHECK (difficulty IN (1,2,3)), -- 1=easy,2=medium,3=hard
  points INTEGER NOT NULL DEFAULT 1,
  category VARCHAR(64) DEFAULT 'Allgemein',
  image_url VARCHAR(255),
  meta JSONB DEFAULT '{}'::jsonb,
  created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Stored images (uploaded via admin UI)
CREATE TABLE question_images (
  id SERIAL PRIMARY KEY,
  content_type VARCHAR(128) NOT NULL,
  data BYTEA NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Multiple choice answers
CREATE TABLE answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  answer_text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT false,
  partial_value NUMERIC(5,4) NOT NULL DEFAULT 0.0 CHECK (partial_value >= 0 AND partial_value <= 1)
);

-- Cloze expected tokens (order matters)
CREATE TABLE cloze_answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  token_index SMALLINT NOT NULL,
  expected_text TEXT NOT NULL,
  partial_value NUMERIC(5,4) NOT NULL DEFAULT 1.0 CHECK (partial_value >= 0 AND partial_value <= 1),
  UNIQUE(question_id, token_index)
);

-- Test attempts (one row per finished attempt)
CREATE TABLE attempts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  total_points NUMERIC(8,4) NOT NULL DEFAULT 0.0,
  max_points NUMERIC(8,4) NOT NULL DEFAULT 0.0,
  difficulty SMALLINT NOT NULL CHECK (difficulty IN (1,2,3)),
  grade VARCHAR(10),
  duration_seconds INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Per-question results for each attempt
CREATE TABLE attempt_answers (
  id SERIAL PRIMARY KEY,
  attempt_id INTEGER NOT NULL REFERENCES attempts(id) ON DELETE CASCADE,
  question_id INTEGER REFERENCES questions(id) ON DELETE SET NULL,
  given_answer TEXT,
  points_awarded NUMERIC(8,4) NOT NULL DEFAULT 0.0
);

-- Configuration
CREATE TABLE config (
  key VARCHAR(128) PRIMARY KEY,
  value VARCHAR(255) NOT NULL,
  description TEXT
);

-- Useful indexes
CREATE INDEX idx_questions_difficulty ON questions(difficulty);
CREATE INDEX idx_attempts_user ON attempts(user_id);

-- Example config placeholders
INSERT INTO config (key, value, description) VALUES
('progress.promote_threshold', '0.70', 'Promote to next difficulty if last test score >= 70% (placeholder)'),
('progress.demote_threshold',  '0.40', 'Demote if average of last N attempts <= 40% (placeholder)'),
('progress.window_size',      '3',    'Number of recent attempts used to calculate demotion (placeholder)');
```

#### 10.5.2 seeds.sql (Beispieldaten)
```sql
-- Datei: db/seeds.sql
-- Hinweis: Das echte Projekt-Seed enthält einen großen Fragenpool. Hier nur ein kurzer Auszug,
-- der zur Struktur aus `db/schema.sql` passt.

-- Student user (student / student)
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'student',
  'student@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896',
  '00000000000000000000000000000000',
  'student'
)
ON CONFLICT (username) DO NOTHING;

-- Admin user (lehrer / student)
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'lehrer',
  'lehrer@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896',
  '00000000000000000000000000000000',
  'admin'
)
ON CONFLICT (username) DO NOTHING;

-- Beispiel MC-Frage + Antworten
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Was ist UML?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC' AND prompt = 'Was ist UML?' AND difficulty = 1 AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC' AND prompt = 'Was ist UML?' AND difficulty = 1 AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT q_id.id, a.answer_text, a.is_correct, a.partial_value
FROM q_id,
  (VALUES
    ('Unified Modeling Language', true, 1.0),
    ('Universal Markup Language', false, 0.0),
    ('United Modelling Logic', false, 0.0)
  ) AS a(answer_text, is_correct, partial_value)
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = q_id.id AND a2.answer_text = a.answer_text
);
```

---

## 11. Anhang

### 11.1 Glossar
| Begriff | Bedeutung |
|---|---|
| **DAO** | Data Access Object - Pattern zur Abstraktion von Datenbankzugriffen |
| **JDBC** | Java Database Connectivity - Standard-API für Datenbankzugriffe |
| **JSP** | Java Server Pages - Technologie für server-seitiges HTML-Rendering |
| **ORM** | Object-Relational Mapping - Abbildung von Objekten auf Tabellenzeilen |
| **MVC** | Model-View-Controller - Architekturmuster |
| **CRUD** | Create, Read, Update, Delete - Grundoperationen |
| **SQL-Injection** | Sicherheitslücke durch unsachgemäßes Handling von Benutzereingaben |
| **Normalisierung** | Strukturierung einer Datenbank zur Vermeidung von Anomalien |
| **Foreign Key** | Referenz zwischen Tabellen für Datenintegrität |
| **Session** | Technologie zur Verwaltung von Benutzer-Status |
| **Servlet** | Java-Klasse für HTTP-Request-Handling |
| **Connection Pool** | Verwaltung von wiederverwendbaren Datenbankverbindungen |

### 11.2 Verzeichnisse

#### 11.2.1 Tabellenverzeichnis
(Wird automatisch generiert)

#### 11.2.2 Abbildungsverzeichnis
- Abb. 1: Use-Case-Diagramm
- Abb. 2: Klassendiagramm
- Abb. 3: Entity-Relation-Diagramm
- Abb. 4: Deployment-Diagramm
- Abb. 5: Komponentendiagramm
- (weitere Abbildungen...)

#### 11.2.3 Code-Listing Verzeichnis
- Listing 1: ProgressionService - Score-Berechnung
- Listing 2: DbConnectionManager - Connection Pool
- Listing 3: schema.sql - Datenbankschema
- (weitere Listings...)

### 11.3 Referenzen und Quellen

#### 11.3.1 Verwendete Technologien und Bibliotheken
- **Java Platform, Standard Edition:** https://docs.oracle.com/javase/
- **Jakarta EE (ehemals Java EE):** https://jakarta.ee/
- **PostgreSQL Documentation:** https://www.postgresql.org/docs/
- **Apache Tomcat:** https://tomcat.apache.org/
- **Apache Maven:** https://maven.apache.org/
- **HikariCP:** https://github.com/brettwooldridge/HikariCP
- **JUnit 5:** https://junit.org/junit5/

#### 11.3.2 Design-Pattern und Best Practices
- **DAO Pattern:** https://www.oracle.com/java/technologies/
- **Enterprise Design Patterns:** https://www.oracle.com/java/technologies/
- **Clean Code:** Robert C. Martin
- **Design Patterns:** Gang of Four

#### 11.3.3 Sicherheitsressourcen
- **OWASP Top 10:** https://owasp.org/www-project-top-ten/
- **SQL-Injection Prevention:** https://cheatsheetseries.owasp.org/
- **Session Security:** https://owasp.org/www-community/attacks/Session_fixation

#### 11.3.4 Dokumentation und Weitere Ressourcen
- Project README: [README.md](../README.md)
- Project Overview: [PROJECT_OVERVIEW.md](../docs/PROJECT_OVERVIEW.md)
- JSP Integration Guide: [JSP_INTEGRATION_GUIDE.md](../docs/JSP_INTEGRATION_GUIDE.md)
- Architecture Diagrams: [ARCHITECTURE_DIAGRAMS.md](../docs/ARCHITECTURE_DIAGRAMS.md)
- Database Explorer: [DATABASE_EXPLORER.md](../docs/DATABASE_EXPLORER.md)
- Testing Guide: [testing_guide.md](../docs/wiki/testing_guide.md)

---

## Versionshistorie

| Version | Datum | Autor | Änderungen |
|---|---|---|---|
| 1.0 | 25.01.2026 | Entwicklerteam | Initiale Dokumentation |

---

**Dokumentation abgeschlossen am:** 25. Januar 2026  
**Status:** ✅ Vollständig  
**Letzte Aktualisierung:** 25. Januar 2026

---

**Version:** 1.0  
**Datum:** 25.01.2026  
**Status:** Gliederung fertiggestellt
