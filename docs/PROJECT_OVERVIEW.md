# Projekt Wissenstest - Allgemeine Übersicht

## 📋 Projektbeschreibung
Das **Projekt Wissenstest** ist eine web-basierte Lernplattform, die Schülern ermöglicht, ihr Wissen durch automatisierte Tests zu überprüfen. Die Plattform bietet verschiedene Fragetypen (Multiple Choice, Lückentext), adaptive Schwierigkeitsanpassung und detailliertes Feedback. Administratoren können Tests verwalten und Statistiken einsehen.

## 🎯 Kernfunktionalität

### Für Schüler
- **Benutzerverwaltung:** Registrierung, Login, Profilinformationen
- **Test-Durchführung:** Zufällige Frageauswahl, verschiedene Fragetypen
- **Echtzeit-Bewertung:** Sofortiges Feedback zu jeder Antwort
- **Notenberechnung:** Automatische Umrechnung der Punkte in Schulnoten (1-6)
- **Lernmodus:** Interaktive Flip-Cards zum Üben und Wiederholen
- **Fortschrittsanzeige:** Tracking von Testergebnissen

### Für Administratoren
- **Fragenverwaltung:** CRUD-Operationen für Test-Fragen
- **Nutzerverwaltung:** Verwaltung von Schülern (aktiv/inaktiv)
- **Statistiken:** Einsicht in Lernergebnisse und Schulstatistiken

---

## 🏗️ Architektur-Übersicht

### Schichtenmodell

```
┌─────────────────────────────────────────────────────┐
│             Präsentationsschicht (Frontend)         │
│  React SPA mit Komponenten (Login, TestRunner, etc) │
│              REST-API Kommunikation                 │
└──────────────────────────────────────────────────────┘
                         ↓ (HTTP/JSON)
┌──────────────────────────────────────────────────────┐
│            Kontroll-/Service-Schicht (Backend)       │
│  Java 17 Servlets + Business Logic (Services)       │
│  - AuthServlet, TestServlet, AdminServlet           │
│  - AuthService, TestService, ProgressionService     │
│                                                      │
│            Datenzugriff-Schicht (DAOs)              │
│  JDBC-basierte Data Access Objects                  │
│  - UserDao, QuestionDao, AttemptDao, AnswerDao      │
└──────────────────────────────────────────────────────┘
                         ↓ (SQL)
┌──────────────────────────────────────────────────────┐
│              Datenbank-Schicht                       │
│  PostgreSQL 15 mit relationales Schema              │
│  Tabellen: users, questions, attempts, answers      │
└──────────────────────────────────────────────────────┘
```

---

## 📁 Projektstruktur

### Backend (`mainlogik, backend/`)
```
src/main/java/de/dhsn/wissentest/
├── web/                      # HTTP-Schicht (Servlets)
│   ├── AuthServlet.java      # Login/Registrierung
│   ├── TestServlet.java      # Test-Durchführung
│   ├── AdminServlet.java     # Admin-Funktionen
│   ├── CorsFilter.java       # CORS-Header
│   ├── ServletUtils.java     # Hilfsmethoden
│   ├── JsonUtil.java         # JSON-Serialisierung
│   └── HealthServlet.java    # Health Check
│
├── service/                   # Business-Logik
│   ├── AuthService.java      # Login, Registrierung
│   ├── TestService.java      # Test-Logik, Scoring
│   ├── ProgressionService.java # Fortschritt-Tracking
│   └── AdminService.java     # Admin-Funktionen
│
├── dao/                      # Datenzugriff (JDBC)
│   ├── UserDao.java          # User-Schnittstelle
│   ├── JdbcUserDao.java      # User-Implementation
│   ├── QuestionDao.java      # Fragen-Schnittstelle
│   ├── JdbcQuestionDao.java  # Fragen-Implementation
│   ├── AttemptDao.java       # Versuche-Schnittstelle
│   ├── JdbcAttemptDao.java   # Versuche-Implementation
│   ├── AnswerDao.java        # Antworten-Schnittstelle
│   ├── JdbcAnswerDao.java    # Antworten-Implementation
│   ├── ClozeTokenDao.java    # Lückentext-Schnittstelle
│   └── JdbcClozeTokenDao.java # Lückentext-Implementation
│
├── model/                    # Datenmodelle (POJOs)
│   ├── User.java             # Benutzer
│   ├── Question.java         # Frage
│   ├── QuestionType.java     # Enum: MC, CLOZE
│   ├── AnswerOption.java     # Antwort-Option
│   ├── Attempt.java          # Test-Versuch
│   ├── AttemptAnswer.java    # Gegebene Antwort
│   └── ClozeToken.java       # Lückenelement
│
├── util/                     # Hilfsfunktionen
│   ├── DbConnectionManager.java # Datenbankverbindung
│   └── PasswordUtils.java       # Passwort-Hashing
│
└── test/                     # Unit & Integration Tests
    ├── AuthServiceTest.java
    ├── ProgressionServiceTest.java
    └── util/TestUtils.java   # Test-Hilfsmittel
```

### Frontend (`frondend/`)
```
src/
├── App.jsx                   # Hauptkomponente, Routing
├── main.jsx                  # React Entry Point
│
├── components/               # React-Komponenten
│   ├── LandingPage.jsx       # Startseite (Features)
│   ├── Login.jsx             # Login-Formular
│   ├── Register.jsx          # Registrierungsformular
│   ├── TestList.jsx          # Übersicht verfügbarer Tests
│   ├── TestRunner.jsx        # Test-Durchführung (UI)
│   ├── Result.jsx            # Ergebnis-Anzeige
│   ├── AdminPanel.jsx        # Admin-Dashboard
│   ├── LearnMode.jsx         # Lernmodus
│   └── FlipCard.jsx          # Flip-Card Komponente
│
├── services/
│   └── apiClient.js          # REST-API Kommunikation
│
└── styles/
    └── main.css              # Globale Styles

vite.config.js               # Vite Build-Konfiguration
package.json                 # npm Dependencies
```

### Datenbank (`db/`)
```
schema.sql                   # DB-Schema (Tabellen, Keys)
seeds.sql                    # Beispieldaten (Test-Fragen)
```

---

## 🔄 Datenfluss - Beispiel: Test durchführen

### Ablauf-Diagramm
```
Benutzer                Frontend                Backend              DB
   │                       │                       │                  │
   │─── Klick Test ─────→  │                       │                  │
   │                       │─── GET /test/start ─→ │                  │
   │                       │                       │──── SQL Query ───→│
   │                       │                       │←── 10 Fragen ─────│
   │                       │←─── JSON Fragen ──────│                  │
   │      Zeige Fragen     │                       │                  │
   │      & Input          │                       │                  │
   │─── Antworten ────────→│                       │                  │
   │                       │─── POST /test/answer→ │                  │
   │                       │                       │──── Validierung ──│
   │                       │                       │──── Score ────────│
   │                       │←─── Result JSON ──────│                  │
   │      Zeige Ergebnis   │                       │                  │
   │      & Fortschritt    │                       │                  │
```

---

## 🗄️ Datenbankschema (vereinfacht)

```
┌──────────────────┐
│      users       │
├──────────────────┤
│ id (PK)          │
│ username (UNIQUE)│
│ email (UNIQUE)   │
│ password_hash    │
│ is_admin         │
│ created_at       │
└──────────────────┘
         ↑
         │ (1:n)
         │
┌──────────────────────────────────────┐
│           attempts                   │
├──────────────────────────────────────┤
│ id (PK)                              │
│ user_id (FK → users)                 │
│ score                                │
│ max_score                            │
│ grade (1-6)                          │
│ completed_at                         │
└──────────────────────────────────────┘
         ↑
         │ (1:n)
         │
┌──────────────────────────────────────┐
│      attempt_answers                 │
├──────────────────────────────────────┤
│ id (PK)                              │
│ attempt_id (FK → attempts)           │
│ question_id (FK → questions)         │
│ given_answer                         │
│ is_correct                           │
└──────────────────────────────────────┘

         ↓ (n:1)
         │

┌──────────────────────────────────────┐
│      questions                       │
├──────────────────────────────────────┤
│ id (PK)                              │
│ question_text                        │
│ question_type (MC / CLOZE)           │
│ difficulty                           │
│ created_at                           │
└──────────────────────────────────────┘
         ↑
         │ (1:n)
         │
┌──────────────────────────────────────┐
│    answer_options                    │
├──────────────────────────────────────┤
│ id (PK)                              │
│ question_id (FK → questions)         │
│ option_text                          │
│ is_correct                           │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│     cloze_tokens                     │
├──────────────────────────────────────┤
│ id (PK)                              │
│ question_id (FK → questions)         │
│ token_text (fehlender Wort)          │
│ position                             │
└──────────────────────────────────────┘
```

---

## 🔐 Sicherheitsmerkmale

1. **Passwort-Hashing:** PBKDF2 mit Salt (in `PasswordUtils.java`)
2. **CORS-Filter:** Kontrollierte Cross-Origin Requests
3. **Session-Management:** Auf HTTP-Ebene (Backend-Session)
4. **Authentifizierung:** Login-Validierung in `AuthService`
5. **Autorisierung:** Admin-Check für sensible Operationen

---

## 🧪 Testing

### Test-Framework
- **JUnit 5** (Backend Integration Tests)
- **Test-Hilfsmittel:** `TestUtils.java` für Daten-Generierung

### Existierende Tests
- `AuthServiceTest.java` – Login/Registrierung Logik
- `ProgressionServiceTest.java` – Scoring & Fortschritt

---

## 🚀 Technologie-Stack

| Layer | Technologien |
|-------|--------------|
| **Frontend** | React 18, Vite, Framer Motion, HTML5, CSS3 |
| **Backend** | Java 17, Servlet API, JDBC |
| **Datenbank** | PostgreSQL 15 |
| **Build Tools** | Maven (Backend), npm/Vite (Frontend) |
| **Testing** | JUnit 5, TestUtils |
| **Deployment** | Tomcat WAR-Datei |

---

## 📊 Klassifikaation

- **REST-API:** ✅ Backend liefert JSON, Frontend verarbeitet es
- **3-Schichten-Architektur:** ✅ Web/Service/DAO/DB
- **Datenbankgebunden:** ✅ PostgreSQL mit JDBC
- **Benutzerauthentifizierung:** ✅ Login & Admin-Rollen
- **Automatisierte Tests:** ✅ JUnit 5 Integration Tests

---

## 📚 Dokumentation

Weitere Details findest du hier:
- [Compliance & JSP-Analyse](JSP_COMPLIANCE_ANALYSIS.md)
- [Postgres Setup Guide](POSTGRES_SETUP.md)
- [JUnit Testing Guide](wiki/testing_guide.md)
- [Individuelle Komponenten-Dokumentation](wiki/)

---

## 👤 Autor & Status
**Status:** Aktive Entwicklung
**Letzte Aktualisierung:** Januar 2026
**Conforitmität:** Java Backend (Servlets, JDBC) ✅ / Frontend (React statt JSP) ⚠️
