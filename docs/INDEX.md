# 📖 Dokumentations-Index

## 🚀 Einstiegspunkte

### Für Anfänger / Übersicht
1. **[README.md](../README.md)** – Projekt-Ziele und Quick-Links
2. **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** – Komplette Funktionalität und Architektur-Übersicht

### Für Compliance / Abnahme
1. **[JSP_COMPLIANCE_ANALYSIS.md](JSP_COMPLIANCE_ANALYSIS.md)** – Ist das Projekt konform? (WICHTIG!)
2. **[COMPLIANCE_SCAN.md](COMPLIANCE_SCAN.md)** – Detaillierter Abgleich mit Anforderungen
3. **[CONFORMITY_CHECK.md](CONFORMITY_CHECK.md)** – Technologie-Audit

### Für Entwickler
1. **[ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md)** – Backend Klassen & Pattern
2. **[JSP_NATIVE_GUIDE.md](JSP_NATIVE_GUIDE.md)** – JSP Komponenten & UI-Architektur
3. **[DATABASE_EXPLORER.md](DATABASE_EXPLORER.md)** – ER-Diagramm & SQL-Schema

### Für Setup & Testing
1. **🎬 [DEMO_MODE.md](DEMO_MODE.md)** – Frontend ohne DB anzeigen (5 Min Quick Demo!)
2. **[JSP_STARTUP_GUIDE.md](JSP_STARTUP_GUIDE.md)** – 🚀 Detaillierter JSP-Startup (Vollständig)
3. **[POSTGRES_SETUP.md](POSTGRES_SETUP.md)** – PostgreSQL lokal installieren
4. **[wiki/testing_guide.md](wiki/testing_guide.md)** – JUnit Tests schreiben
5. **[wiki/start_local.md](wiki/start_local.md)** – Backend + Frontend starten (Kurzversion)

---

## 📋 Alle Dokumente

### Hauptdokumente (docs/)
| Datei | Inhalt | Zielgruppe |
|-------|--------|-----------|
| **PROJECT_OVERVIEW.md** | Funktionen, Architektur, Tech-Stack | Alle |
| **JSP_COMPLIANCE_ANALYSIS.md** | Compliance-Bewertung, Handlungsoptionen | Dozent, Student |
| **COMPLIANCE_SCAN.md** | Anforderungen vs. Implementierung | Prüfer |
| **CONFORMITY_CHECK.md** | Technologie-Whitelist/Blacklist | Prüfer |
| **ARCHITECTURE_DIAGRAMS.md** | Klassen-, Sequenz-, Abhängigkeits-Diagramme | Entwickler |
| **JSP_NATIVE_GUIDE.md** | JSP-Komponenten, Server-seitiges Rendering | Frontend-Dev |
| **DEMO_MODE.md** | 🎬 Frontend ohne DB in 5 Min anschauen! | Alle |
| **JSP_STARTUP_GUIDE.md** | 🚀 Detailliertes Setup & Deployment für JSP | Entwickler |
| **DATABASE_EXPLORER.md** | ER-Diagramm, Tabellen-Schema, SQL | DB-Admin |
| **POSTGRES_SETUP.md** | PostgreSQL 15 & PgAdmin4 Setup | DevOps/Setup |

### Wiki-Dokumente (docs/wiki/)
#### Backend Components
- `backend_db.properties.md` – Datenbankverbindung
- `backend_pom.xml.md` – Maven Konfiguration
- `backend_web.xml.md` – Servlet Registrierung
- `test_util_TestUtils.java.md` – Test-Hilfsmittel (Neu!)
- `test_AuthServiceTest.java.md` – Auth-Tests
- `test_ProgressionServiceTest.java.md` – Progression-Tests

#### Services
- `service_AuthService.java.md` – Login/Registrierung
- `service_TestService.java.md` – Test-Durchführung
- `service_ProgressionService.java.md` – Fortschritt-Tracking
- `service_AdminService.java.md` – Admin-Funktionen

#### DAOs
- `dao_UserDao.java.md` – User-Interface
- `dao_JdbcUserDao.java.md` – User-Implementierung
- `dao_QuestionDao.java.md` – Fragen-Interface
- `dao_JdbcQuestionDao.java.md` – Fragen-Implementierung
- `dao_AttemptDao.java.md` – Versuche-Interface
- `dao_JdbcAttemptDao.java.md` – Versuche-Implementierung
- `dao_AnswerDao.java.md` – Antworten-Interface
- `dao_JdbcAnswerDao.java.md` – Antworten-Implementierung
- `dao_ClozeTokenDao.java.md` – Lückentext-Interface
- `dao_JdbcClozeTokenDao.java.md` – Lückentext-Implementierung

#### Models
- `model_User.java.md` – Benutzer-Datenmodell
- `model_Question.java.md` – Frage-Datenmodell
- `model_QuestionType.java.md` – Enum für Fragetypen
- `model_AnswerOption.java.md` – Antwort-Option
- `model_Attempt.java.md` – Test-Versuch
- `model_AttemptAnswer.java.md` – Gegebene Antwort
- `model_ClozeToken.java.md` – Lückenelement

#### Web/Servlets
- `web_AuthServlet.java.md` – Login/Registrierung HTTP
- `web_TestServlet.java.md` – Test-HTTP Handler
- `web_AdminServlet.java.md` – Admin-HTTP Handler
- `web_CorsFilter.java.md` – Cross-Origin Filter
- `web_JsonUtil.java.md` – JSON-Serialisierung
- `web_ServletUtils.java.md` – Servlet Hilfsmethoden
- `web_HealthServlet.java.md` – Health Check

#### Utilities
- `util_DbConnectionManager.java.md` – DB-Verbindung (Singleton)
- `util_PasswordUtils.java.md` – PBKDF2 Passwort-Hashing

#### JSP Frontend Components
- `jsp_native_LandingPage.md` – Startseite (JSP)
- `jsp_native_Login.md` – Login-Formular (JSP)
- `jsp_native_Register.md` – Registrierungs-Formular (JSP)
- `jsp_native_TestList.md` – Test-Dashboard (JSP)
- `jsp_native_TestRunner.md` – Quiz-Durchführung (JSP)
- `jsp_native_Result.md` – Ergebnis-Anzeige (JSP)
- `jsp_native_AdminPanel.md` – Admin-Dashboard (JSP)
- `jsp_native_FlipCard.md` – Flip-Card Komponente (JSP Fragment)

#### JSP Native Frontend (Komplette Dokumentation)
- `JSP_NATIVE_COMPONENTS.md` – Komplette Komponenten-Übersicht ⭐ START HERE
- `jsp_native_app.md` – Vanilla JS Business-Logic

#### Datenbank
- `db_schema.sql.md` – Tabellen-Definitionen
- `db_seeds.sql.md` – Test-Daten

#### Utilities
- `start_local.md` – Schnellstart-Anleitung
- `testing_guide.md` – JUnit Integration Test Guide
- `verbindungen_uebersicht.md` – Verbindungs-Übersicht

---

## 🔗 Navigations-Tipps

### Nach Rollen

**Dozent/Prüfer:**
1. [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) – Was kann die App?
2. [JSP_COMPLIANCE_ANALYSIS.md](JSP_COMPLIANCE_ANALYSIS.md) – Ist sie konform?
3. [COMPLIANCE_SCAN.md](COMPLIANCE_SCAN.md) – Detaillierter Check
4. [wiki/JAVASCRIPT_ERLAUBNIS.md](wiki/JAVASCRIPT_ERLAUBNIS.md) – JavaScript Erlaubnis geklärt
5. [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md) – Ist die Architektur sauber?

**Sicherheitsbewusster Student (Fallback):**
1. [JSP_NATIVE_GUIDE.md](JSP_NATIVE_GUIDE.md) – Sichere Alternative
2. [wiki/JSP_NATIVE_COMPONENTS.md](wiki/JSP_NATIVE_COMPONENTS.md) – JSP-Komponenten
3. [wiki/JAVASCRIPT_ERLAUBNIS.md](wiki/JAVASCRIPT_ERLAUBNIS.md) – Rechtfertigung

**Backend-Entwickler:**
1. [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md) – Klassen & Pattern
2. [wiki/testing_guide.md](wiki/testing_guide.md) – Tests schreiben
3. Service & DAO Dokumentation in [wiki/](wiki/) – Spezifische Komponenten

**Frontend-Entwickler:**
1. [FRONTEND_ARCHITECTURE.md](FRONTEND_ARCHITECTURE.md) – Komponenten-Baum (React)
2. [wiki/JSP_NATIVE_COMPONENTS.md](wiki/JSP_NATIVE_COMPONENTS.md) – Komponenten-Baum (JSP)
3. [wiki/frontend_*](wiki/) – React Komponenten-Details
4. [wiki/jsp_native_*](wiki/) – JSP Komponenten-Details
5. [wiki/frontend_services_apiClient.js.md](wiki/frontend_services_apiClient.js.md) – API-Integration

**DevOps/Datenbank-Admin:**
1. [DATABASE_EXPLORER.md](DATABASE_EXPLORER.md) – ER-Diagramm
2. [POSTGRES_SETUP.md](POSTGRES_SETUP.md) – Setup Anleitung
3. [wiki/db_schema.sql.md](wiki/db_schema.sql.md) – Schema Details

**Tester/QA:**
1. [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) – Funktionen
2. [wiki/testing_guide.md](wiki/testing_guide.md) – Wie testet man?
3. [wiki/start_local.md](wiki/start_local.md) – Lokales Setup

---

## 📊 Dokumentations-Status

| Kategorie | Status | Letztes Update |
|-----------|--------|-----------------|
| Projekt-Übersicht | ✅ Vollständig | Jan 2026 |
| Compliance | ✅ Vollständig (Neu!) | Jan 2026 |
| Backend-Architektur | ✅ Vollständig (Neu!) | Jan 2026 |
| Frontend-Architektur | ✅ Vollständig (Neu!) | Jan 2026 |
| Datenbank | ✅ Vollständig (Neu!) | Jan 2026 |
| Komponenten | ✅ Aktualisiert (LandingPage, FlipCard, LearnMode) | Jan 2026 |
| Testing | ✅ Vollständig | Jan 2026 |
| Setup | ✅ Vollständig | Jan 2026 |

---

## ❓ Häufig gestellte Fragen

### "Wo fange ich an?"
→ [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)

### "Ist das Projekt konform mit den Anforderungen?"
→ [JSP_COMPLIANCE_ANALYSIS.md](JSP_COMPLIANCE_ANALYSIS.md)

### "Ist JavaScript erlaubt?"
→ [wiki/JAVASCRIPT_ERLAUBNIS.md](wiki/JAVASCRIPT_ERLAUBNIS.md) ⭐

### "Wie funktioniert die JSP-Native Variante?"
→ [JSP_NATIVE_GUIDE.md](JSP_NATIVE_GUIDE.md) → [wiki/JSP_NATIVE_COMPONENTS.md](wiki/JSP_NATIVE_COMPONENTS.md) ⭐

### "Wie funktioniert die Architektur?"
→ [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md) + [FRONTEND_ARCHITECTURE.md](FRONTEND_ARCHITECTURE.md)

### "Wie schreibe ich einen Test?"
→ [wiki/testing_guide.md](wiki/testing_guide.md)

### "Wie starte ich Backend/Frontend lokal?"
→ [wiki/start_local.md](wiki/start_local.md)

### "Was wurde heute dokumentiert?"
→ [wiki/DOKUMENTATION_ABSCHLUSS.md](wiki/DOKUMENTATION_ABSCHLUSS.md) ⭐

### "Wie richte ich die Datenbank ein?"
→ [POSTGRES_SETUP.md](POSTGRES_SETUP.md)

### "Wie funktioniert die Datenbank?"
→ [DATABASE_EXPLORER.md](DATABASE_EXPLORER.md)

---

## 🎯 Dokumentations-Ziele

✅ **Verständlichkeit:** Diagramme, Code-Beispiele, Erklärungen
✅ **Vollständigkeit:** Alle Komponenten dokumentiert
✅ **Wartbarkeit:** Übersichtliche Struktur, Verlinkung
✅ **Konformität:** Anforderungen vs. Implementierung geprüft
✅ **Praxis:** Setup- & Test-Guides vorhanden

---

**Zuletzt aktualisiert:** Januar 2026
**Dokumentations-Editor:** GitHub Copilot (Claude Haiku)
