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
1. **🎬 [DEMO_MODE.md](DEMO_MODE.md)** – Schnellstart mit lokaler DB (Script)
2. **[JSP_STARTUP_GUIDE.md](JSP_STARTUP_GUIDE.md)** – 🚀 Detaillierter JSP-Startup (Vollständig)
3. **[POSTGRES_SETUP.md](POSTGRES_SETUP.md)** – PostgreSQL lokal installieren
4. **[wiki/testing_guide.md](wiki/testing_guide.md)** – JUnit Tests schreiben

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
- `dao_QuestionImageDao.java.md` – Bild-Interface (NEU)
- `dao_JdbcQuestionImageDao.java.md` – Bild-Implementierung (NEU)

#### Models
- `model_User.java.md` – Benutzer-Datenmodell
- `model_Question.java.md` – Frage-Datenmodell
- `model_QuestionType.java.md` – Enum für Fragetypen
- `model_AnswerOption.java.md` – Antwort-Option
- `model_Attempt.java.md` – Test-Versuch
- `model_AttemptAnswer.java.md` – Gegebene Antwort
- `model_AttemptResult.java.md` – Test-Ergebnis Wrapper (NEU)
- `model_ClozeToken.java.md` – Lückenelement
- `model_QuestionImage.java.md` – Fragebild (NEU)
- `model_QuestionResultDetail.java.md` – Fragen-Einzelergebnis (NEU)

#### Web/Servlets
- `web_AuthServlet.java.md` – Login/Registrierung HTTP
- `web_TestServlet.java.md` – Test-HTTP Handler
- `web_AdminServlet.java.md` – Admin-HTTP Handler
- `web_CorsFilter.java.md` – Cross-Origin Filter
- `web_CharacterEncodingFilter.java.md` – UTF-8 Filter (NEU)
- `web_ImageServlet.java.md` – Bildauslieferung (NEU)
- `web_JsonUtil.java.md` – JSON-Serialisierung
- `web_ServletUtils.java.md` – Servlet Hilfsmethoden
- `web_HealthServlet.java.md` – Health Check

#### Utilities
- `util_DbConnectionManager.java.md` – DB-Verbindung (Singleton)
- `util_PasswordUtils.java.md` – Passwort‑Hashing (iteriertes SHA‑256)

#### JSP Frontend Components
- `jsp_native_LandingPage.md` – Startseite (JSP)
- `jsp_native_Login.md` – Login-Formular (JSP)
- `jsp_native_Register.md` – Registrierungs-Formular (JSP)
- `jsp_native_TestList.md` – Test-Dashboard (JSP)
- `jsp_native_ExamMode.md` – Prüfungsmodus-Konfiguration (JSP)
- `jsp_native_TestRunner.md` – Quiz-Durchführung (JSP)
- `jsp_native_Result.md` – Ergebnis-Anzeige (JSP)
- `jsp_native_AdminPanel.md` – Admin-Dashboard (JSP)
- `jsp_native_FlipCard.md` – Flip-Card Komponente (JSP Fragment)
- `jsp_native_LearnMode.md` – Lernmodus (JSP)
- `jsp_native_AccessDenied.md` – Zugriff verweigert Seite (NEU)

#### JSP Native Frontend (Komplette Dokumentation)
- `JSP_NATIVE_COMPONENTS.md` – Komplette Komponenten-Übersicht ⭐ START HERE
- `jsp_native_app_main.md` – Vanilla JS Business-Logic

#### Datenbank
- `db_schema.sql.md` – Tabellen-Definitionen
- `db_seeds.sql.md` – Test-Daten

#### Sonstige Wiki-Dokumente
- `testing_guide.md` – JUnit Integration Test Guide
- `verbindungen_uebersicht.md` – Verbindungs-Übersicht
- `DOKUMENTATION_ABSCHLUSS.md` – Projektabschluss & UAT-Protokoll

---

## 🔗 Navigations-Tipps

### Nach Rollen

**Dozent/Prüfer:**
1. [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) – Was kann die App?
2. [JSP_COMPLIANCE_ANALYSIS.md](JSP_COMPLIANCE_ANALYSIS.md) – Ist sie konform?
3. [COMPLIANCE_SCAN.md](COMPLIANCE_SCAN.md) – Detaillierter Check
5. [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md) – Ist die Architektur sauber?

**Sicherheitsbewusster Student (Fallback):**
1. [JSP_NATIVE_GUIDE.md](JSP_NATIVE_GUIDE.md) – Sichere Alternative
2. [wiki/JSP_NATIVE_COMPONENTS.md](wiki/JSP_NATIVE_COMPONENTS.md) – JSP-Komponenten

**Backend-Entwickler:**
1. [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md) – Klassen & Pattern
2. [wiki/testing_guide.md](wiki/testing_guide.md) – Tests schreiben
3. Service & DAO Dokumentation in [wiki/](wiki/) – Spezifische Komponenten

**Frontend-Entwickler:**
1. [wiki/JSP_NATIVE_COMPONENTS.md](wiki/JSP_NATIVE_COMPONENTS.md) – Komponenten-Baum (JSP)
2. [wiki/jsp_native_*](wiki/) – JSP Komponenten-Details
3. [wiki/jsp_native_app_main.md](wiki/jsp_native_app_main.md) – JS‑Logik

**DevOps/Datenbank-Admin:**
1. [DATABASE_EXPLORER.md](DATABASE_EXPLORER.md) – ER-Diagramm
2. [POSTGRES_SETUP.md](POSTGRES_SETUP.md) – Setup Anleitung
3. [wiki/db_schema.sql.md](wiki/db_schema.sql.md) – Schema Details

**Tester/QA:**
1. [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) – Funktionen
2. [wiki/testing_guide.md](wiki/testing_guide.md) – Wie testet man?
3. [JSP_STARTUP_GUIDE.md](JSP_STARTUP_GUIDE.md) – Lokales Setup

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

### "Wie funktioniert die JSP-Native Variante?"
→ [JSP_NATIVE_GUIDE.md](JSP_NATIVE_GUIDE.md) → [wiki/JSP_NATIVE_COMPONENTS.md](wiki/JSP_NATIVE_COMPONENTS.md) ⭐

### "Wie funktioniert die Architektur?"
→ [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md)

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
**Dokumentations-Editor:** GitHub Copilot + Frederik Dehn
