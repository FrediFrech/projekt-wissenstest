# Projekt Wissenstest - UML Lernplattform

## 1. Projektziel
Entwicklung einer Webanwendung im Rahmen des Moduls Softwareprojekt. Die Anwendung ermöglicht Nutzeranmeldung, verarbeitet Formulareingaben und liest/schreibt Daten aus einer Server-Datenbank (Postgres/MS SQL).

## 2. Technische Anforderungs-Checkliste

### Backend
- [x] **Java Webtechnologie:** Servlets (Java 17)
- [x] **Testing:** JUnit 5 Tests vorhanden (siehe `testing_guide.md`)
- [x] **Deployment:** WAR-Datei für Tomcat 8.5/11
- [x] **Datenbank-Treiber:** PostgreSQL Treiber integriert (MS SQL Treiber vorbereitet)

### Frontend
- [x] **Framework:** JSP (Java Server Pages) mit Vanilla JS
- [x] **UI/UX:** Interaktives Design mit CSS3 Animationen
- [x] **Kommunikation:** REST-ähnliche API Calls zum Backend

### Datenbank
- [x] **Server:** Postgres Ver. 15 (Schema kompatibel)
- [x] **Zugriff:** Konfiguriert via `db.properties` (User: student / Pass: student)
- [x] **Schema:** Tabellen für User, Fragen, Antworten, Versuche (Scores)

### Funktionalität
- [x] **User Management:** Login/Registrierung, Rollen (Student/Admin)
- [x] **Test-Logik:** Zufällige Fragen, verschiedene Typen (MC, Lückentext)
- [x] **Bewertung:** Score-Berechnung und Noten-Ermittlung
- [x] **Lernmodus:** Interaktive Flip-Cards zum Üben

## 3. Installation & Start

### 📚 Dokumentation (WICHTIG!)

🚀 **START HIER für Übersicht:**
- **[Projekt-Übersicht & Funktionalität](docs/PROJECT_OVERVIEW.md)** – Alles auf einen Blick!
- **[Dokumentations-Status](docs/DOCUMENTATION_STATUS.md)** – Was wurde alles dokumentiert?
- **[Dokumentations-Index](docs/INDEX.md)** – Alle Dokumente & Navigation

**Compliance-Frage (KRITISCH!):**
- **[JSP Native Guide (KONFORM)](docs/JSP_NATIVE_GUIDE.md)** – Die konforme JSP-basierte Version.
- **[JSP Integration Guide (Hybrid Lösung)](docs/JSP_INTEGRATION_GUIDE.md)** – Wie wir die konformität sichergestellt haben.
- **[Compliance & JSP-Frage](docs/JSP_COMPLIANCE_ANALYSIS.md)** – Hintergrund-Analyse.

**Technische Architektur:**
- [Backend Klassendiagramme](docs/ARCHITECTURE_DIAGRAMS.md) – DAO/Service/Servlet-Pattern
- [JSP Frontend-Architektur](docs/JSP_NATIVE_GUIDE.md) – Komponenten & Server-seitiges Rendering
- [Datenbank Explorer](docs/DATABASE_EXPLORER.md) – ER-Diagramm & SQL-Queries

**Setup & Tests:**
- [PostgreSQL Setup](docs/POSTGRES_SETUP.md) – Lokale DB + PgAdmin4
- [JUnit Testing Guide](docs/wiki/testing_guide.md) – Integration Tests schreiben
- [Schnellstart Backend/Frontend](docs/wiki/start_local.md)

### Datenbank Setup
1. PostgreSQL installieren & konfigurieren (siehe `POSTGRES_SETUP.md`)
2. Datenbank `wissentest` anlegen
3. User `student` (Passwort: `student`) anlegen oder in `db.properties` anpassen
4. Schema via `db/schema.sql` laden
5. Testdaten via `db/seeds.sql` laden

### Backend Start (Tomcat)
```bash
cd "mainlogik, backend"
mvn clean package
# Dann wissentest.war in Tomcat deployen
```

### Frontend Start (JSP)
```bash
cd "mainlogik, backend"
# JSP wird automatisch mit Tomcat deployed
# Zugreifbar unter http://localhost:8080/wissentest
```

---

## 4. Projektstruktur (Schnellübersicht)

```
projekt-wissenstest/
├── docs/
│   ├── PROJECT_OVERVIEW.md           ⭐ START HERE!
│   ├── JSP_COMPLIANCE_ANALYSIS.md    ⚠️ Compliance?
│   ├── ARCHITECTURE_DIAGRAMS.md      Backend Klassen
│   ├── FRONTEND_ARCHITECTURE.md      React Komponenten
│   ├── DATABASE_EXPLORER.md          ER-Diagramm
│   ├── POSTGRES_SETUP.md             DB Setup
│   └── wiki/                         Komponenten-Doku
│
├── mainlogik, backend/               ☕ Java Backend
│   ├── src/main/java/.../web        Servlets
│   ├── src/main/java/.../service    Business-Logik
│   ├── src/main/java/.../dao        JDBC DAOs
│   ├── src/main/java/.../model      Datenmodelle
│   └── src/test/java/               JUnit Tests
│
├── alte_react_version/               🗂️ Archivierte React Version
│   ├── frondend/                     Alte React-Dateien
│   └── frontend_docs/                Alte React-Dokumentation
│
├── db/                               🗄️ Datenbank
│   ├── schema.sql                   Tabellen
│   └── seeds.sql                    Test-Daten
```

---

## 5. Tech-Stack

| Layer | Technologie | Konformität |
|-------|-------------|-------------|
| **Frontend** | JSP (Java Server Pages), Vanilla JS, CSS3 | ✅ Konform |
| **Backend** | Java 17, Servlets, JDBC | ✅ Konform |
| **Datenbank** | PostgreSQL 15 | ✅ Konform |
| **Testing** | JUnit 5 | ✅ Konform |

Mehr Details: [docs/JSP_COMPLIANCE_ANALYSIS.md](docs/JSP_COMPLIANCE_ANALYSIS.md)