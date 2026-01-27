# PlantUML Klassendiagramme - Wissenstest Projekt

Dieses Dokument beschreibt die aufgeteilten PlantUML-Diagramme für das Wissenstest-Projekt.

## 📋 Übersicht der Diagramme

Das komplette Klassendiagramm wurde in **6 sinnvolle Teildiagramme** aufgeteilt für bessere Lesbarkeit und Wartbarkeit.

---

## 1️⃣ **PlantUML_01_Model_Klassen.puml** 
### Model-Klassen und Datenstrukturen

**Enthält:**
- **Enums:** `QuestionType` (MC, CLOZE), `Role` (STUDENT, TEACHER, ADMIN)
- **Model-Klassen:**
  - `User` - Benutzer des Systems
  - `Question` - Testfragen mit Typ und Schwierigkeit
  - `AnswerOption` - Antwortoptionen für Multiple Choice
  - `ClozeToken` - Token für Lückentext-Fragen
  - `Test` - Test-Definition mit Konfigurationen
  - `Attempt` - Ein Testversuch eines Benutzers
  - `AttemptAnswer` - Gespeicherte Antworten pro Versuch

**Beziehungen:**
- User erstellt Tests und absolviert Attempts
- Question hat AnswerOptions (1:N)
- Question hat ClozeTokens (1:N)
- Test enthält Questions (N:M via test_questions)
- Attempt speichert AttemptAnswers (1:N)

**Größe:** Überschaubar und fokussiert auf Datenmodellierung

---

## 2️⃣ **PlantUML_02_DAO_Layer.puml**
### Data Access Object (DAO) Layer

**Enthält:**
- **DAO-Interfaces (6):**
  - `UserDao` - Benutzer-Persistierung
  - `QuestionDao` - Frage-Persistierung
  - `AnswerDao` - Antwort-Option-Persistierung
  - `ClozeTokenDao` - Lückentext-Persistierung
  - `TestDao` - Test-Persistierung
  - `AttemptDao` - Versuch-Persistierung

- **DAO-Implementierungen (6):**
  - `JdbcUserDao` - JDBC Implementation für Users
  - `JdbcQuestionDao` - JDBC Implementation für Questions
  - `JdbcAnswerDao` - JDBC Implementation für Answers
  - `JdbcClozeTokenDao` - JDBC Implementation für Tokens
  - `JdbcTestDao` - JDBC Implementation für Tests
  - `JdbcAttemptDao` - JDBC Implementation für Attempts

- **Repository:**
  - `QuestionRepository` - Repository-Pattern für komplexe Queries

**Muster:**
- Alle DAOs implementieren CRUD-Operationen (Create, Read, Update, Delete)
- PreparedStatements für SQL-Injection-Prävention
- ResultSet-Mapping zu Java-Objekten
- Connection Management via HikariCP

**Größe:** Mittelgroß, fokussiert auf Datenzugriff

---

## 3️⃣ **PlantUML_03_Service_Layer.puml**
### Business Logic Service Layer

**Enthält:**
- **Service-Klassen (4):**

  1. **AuthService**
     - Authentifizierung (Login/Register)
     - Passwort-Management
     - Input-Validierung

  2. **TestService**
     - Test-CRUD-Operationen
     - Test-Durchführung
     - Fragen-Management
     - Random-Auswahl

  3. **ProgressionService**
     - Score-Berechnung
     - Prozentuale Quote
     - Noten-Berechnung (1-6)
     - Statistik-Generierung

  4. **AdminService**
     - Benutzerverwaltung
     - System-Statistiken
     - Report-Generierung
     - Admin-Aktionen

**Charakteristiken:**
- Services sind "fat" und enthalten komplexe Business-Logik
- Koordinieren mehrere DAOs
- Nutzen Utility-Klassen wie PasswordUtils und Logger
- Single Responsibility Principle

**Größe:** Groß, aber überschaubar mit fokussierter Funktionalität

---

## 4️⃣ **PlantUML_04_Servlet_Layer.puml**
### Web/Servlet Layer (Controller)

**Enthält:**
- **Servlet-Klassen (5):**

  1. **AuthServlet** (`/auth/*`)
     - Login-Handling
     - Registrierung
     - Logout
     - Passwort-Reset

  2. **TestServlet** (`/test/*`)
     - Test-Liste
     - Test-Start
     - Test-Submit
     - Ergebnisse

  3. **QuestionServlet** (`/question/*`)
     - Fragen-Management (CRUD)
     - Antwort-Optionen
     - Lückentext-Verwaltung

  4. **AdminServlet** (`/admin/*`)
     - Admin-Panel
     - Benutzer-Verwaltung
     - Statistiken
     - *Benötigt Admin-Autorisierung*

  5. **ProgressionServlet** (`/progression/*`)
     - Benutzer-Statistiken
     - Versuch-Abruf
     - Test-Statistiken

- **Filter:**
  - `FilterAuthenticator` - Zentrale Authentifizierung

**Charakteristiken:**
- Request/Response-Handling
- Session-Management
- Authorization-Checks
- HTTP GET/POST-Verarbeitung

**Größe:** Mittel bis groß, aber klar strukturiert

---

## 5️⃣ **PlantUML_05_Utility_Architektur.puml**
### Utility Classes und Infrastruktur

**Enthält:**
- **Singleton-Klassen:**
  - `DbConnectionManager` - HikariCP Connection Pool Management
  - `ConfigManager` - Konfigurations-Management

- **Utility-Klassen:**
  - `PasswordUtils` - Hashing, Verifikation, Validierung
  - `Logger` - Zentrale Logging-Infrastruktur
  - `ValidationUtils` - Input-Validierung
  - `ExceptionHandler` - Zentrale Exception-Behandlung

- **Support-Klassen:**
  - `ErrorResponse` - Standardisierte Error-Responses

**Charakteristiken:**
- Stateless oder Singleton-Pattern
- Keine Geschäftslogik, nur technische Utilities
- Wiederverwendbar über alle Layer hinweg
- Sicherheits- und Fehlerbehandlung

**Größe:** Überschaubar

---

## 6️⃣ **PlantUML_06_Gesamtarchitektur.puml**
### Gesamtarchitektur und Request-Flow

**Enthält:**
- **Schichten-Übersicht:**
  1. Presentation Layer (Web Browser)
  2. Web Layer (Servlets)
  3. Business Logic Layer (Services)
  4. Data Access Layer (DAOs)
  5. Data Layer (PostgreSQL)
  6. Utility Layer (Infrastructure)

- **Request-Flow:**
  - Von Browser zu Servlet
  - Von Servlet zu Service
  - Von Service zu DAO
  - Von DAO zu Datenbank
  - Return-Paths mit Daten

- **Sicherheits-Maßnahmen:**
  - Session-Authentifizierung
  - RBAC-Autorisierung
  - Passwort-Hashing
  - SQL-Injection-Prävention
  - Input-Validierung

- **Deployment-Stack:**
  - Java 17
  - Tomcat 9.0.85
  - PostgreSQL 16
  - HikariCP Connection Pool

**Größe:** Übersichtlich, zeigt Verbindungen zwischen Komponenten

---

## 📚 Verwendung der Diagramme

### Online Rendering (Empfohlen)
1. **PlantUML Online Editor:**
   - https://www.plantuml.com/plantuml/uml/
   - Dateiinhalt kopieren und einfügen

### VS Code
1. **Extension installieren:**
   ```
   PlantUML (jebbs.plantuml)
   ```
2. **Datei öffnen und anzeigen:**
   - Alt+D für Vorschau
   - Cmd/Ctrl+Shift+P: "PlantUML: Export Diagram"

### Kommandozeile
```bash
# PlantUML CLI installieren (erfordert Java)
java -jar plantuml.jar PlantUML_01_Model_Klassen.puml

# Oder via Graphviz
plantuml -Tpng PlantUML_01_Model_Klassen.puml
```

### PDF/Druck
1. Im Online-Editor rendern
2. Browser Print (Ctrl+P)
3. Als PDF speichern
4. Optimale Größe: A3 oder Landscape

---

## 🎯 Empfohlene Lese-Reihenfolge

1. **START:** `PlantUML_06_Gesamtarchitektur.puml` - Überblick
2. **DANN:** `PlantUML_01_Model_Klassen.puml` - Datenstrukturen
3. **DANN:** `PlantUML_02_DAO_Layer.puml` - Datenzugriff
4. **DANN:** `PlantUML_03_Service_Layer.puml` - Geschäftslogik
5. **DANN:** `PlantUML_04_Servlet_Layer.puml` - Request-Handling
6. **OPTIONAL:** `PlantUML_05_Utility_Architektur.puml` - Infrastruktur

---

## 📊 Größen und Komplexität

| Diagramm | Klassen | Interfaces | Komplexität | Fokus |
|----------|---------|-----------|-------------|-------|
| 1 - Model | 7 | 2 Enums | ⭐ Niedrig | Datenmodelle |
| 2 - DAO | 12 | 6 Interfaces | ⭐⭐ Mittel | Datenzugriff |
| 3 - Service | 4 | 0 | ⭐⭐ Mittel | Business-Logik |
| 4 - Servlet | 6 | 0 | ⭐⭐⭐ Hoch | Web-Request |
| 5 - Utility | 6 | 0 | ⭐⭐ Mittel | Infrastruktur |
| 6 - Gesamt | - | - | ⭐⭐⭐ Hoch | Architektur |

---

## 🔑 Wichtige Patterns und Concepts

### Design Patterns
- **Singleton:** DbConnectionManager, ConfigManager
- **DAO Pattern:** Alle JdbcXxxDao Klassen
- **Repository Pattern:** QuestionRepository
- **Service Pattern:** AuthService, TestService, etc.
- **Filter Pattern:** FilterAuthenticator
- **MVC Pattern:** Servlets als Controller

### Architektur-Patterns
- **Layered Architecture:** 6 klar definierte Schichten
- **Separation of Concerns:** Jede Schicht hat spezifische Verantwortung
- **Single Responsibility:** Jede Klasse hat eine Aufgabe

### Sicherheits-Patterns
- **PreparedStatements:** SQL-Injection-Prävention
- **Session Management:** HttpSession für Authentication
- **RBAC:** Role-Based Access Control
- **Password Hashing:** SHA-256 mit Salt
- **Input Validation:** Server-seitige Validierung

---

## 💡 Tipps für die Dokumentation

1. **Für Druck-Ausgaben:**
   - Diagramme einzeln auf A3 oder Landscape drucken
   - Oder in PDF kombinieren (mit Bookmarks)

2. **Für Präsentationen:**
   - Diagramm 6 (Gesamtarchitektur) zuerst zeigen
   - Dann in spezifische Layer "zoomen"

3. **Für Code-Generierung:**
   - PlantUML-Code kann als Dokumentation im Repository bleiben
   - Mit `@startuml` und `@enduml` leicht erkennbar
   - Können mit CI/CD automatisch zu PNG/PDF konvertiert werden

4. **Für Updates:**
   - Änderungen am Code → Update der PlantUML-Dateien
   - Versionskontrolle mit Git empfohlen
   - Review zusammen mit Code-Reviews

---

## 📝 Lizenz und Verwendung

Diese PlantUML-Diagramme sind Teil der Projektdokumentation für "Wissenstest".

Sie können verwendet werden für:
- ✅ Projektdokumentation
- ✅ Präsentationen
- ✅ Code-Reviews
- ✅ Onboarding neuer Entwickler
- ✅ Architektur-Diskussionen

---

**Letzte Aktualisierung:** 25. Januar 2026  
**Status:** ✅ Komplett und teilweise optimiert  
**Format:** PlantUML (.puml)
