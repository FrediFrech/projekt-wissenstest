# Projekt Wissenstest - UML Lernplattform

## 1. Projektziel
Entwicklung einer umfangreichen Webanwendung im Rahmen des Moduls Softwareprojekt. Die Anwendung ermöglicht Nutzeranmeldung, verarbeitet Formulareingaben und liest/schreibt Daten aus einer Server-Datenbank (Postgres/MS SQL).

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

###  Dokumentation 

 **START HIER für Übersicht:**
- **[Projekt-Übersicht & Funktionalität](docs/PROJECT_OVERVIEW.md)** – Alles auf einen Blick!
- **[Dokumentations-Index](docs/INDEX.md)** – Alle Dokumente & Navigation

**Technische Architektur:**
- [Backend Klassendiagramme](docs/ARCHITECTURE_DIAGRAMS.md) – DAO/Service/Servlet-Pattern
- [JSP Frontend-Architektur](docs/JSP_NATIVE_GUIDE.md) – Komponenten & Server-seitiges Rendering
- [Datenbank Explorer](docs/DATABASE_EXPLORER.md) – ER-Diagramm & SQL-Queries

**Setup & Tests:**
- [PostgreSQL Setup](docs/POSTGRES_SETUP.md) – Lokale DB + PgAdmin4
- [JUnit Testing Guide](docs/wiki/testing_guide.md) – Integration Tests schreiben
- [Schnellstart](docs/JSP_STARTUP_GUIDE.md) – Detailliertes Setup

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
│   ├── ARCHITECTURE_DIAGRAMS.md      Backend Klassen
│   ├── JSP_NATIVE_GUIDE.md           JSP Frontend-Architektur
│   ├── DATABASE_EXPLORER.md          ER-Diagramm
│   ├── POSTGRES_SETUP.md             DB Setup
│   └── wiki/                         Komponenten-Doku (60+ Dateien)
│
├── mainlogik, backend/                Java Backend
│   ├── src/main/java/.../web        Servlets (9 Dateien)
│   ├── src/main/java/.../service    Business-Logik (4 Dateien)
│   ├── src/main/java/.../dao        JDBC DAOs (14 Dateien)
│   ├── src/main/java/.../model      Datenmodelle (10 Dateien)
│   ├── src/main/webapp/jsp_native   JSP Komponenten (11 Dateien)
│   └── src/test/java/               JUnit Tests
│
├── startup/                           Start-Skripte
│   └── start_project.ps1            One-Click Setup
│
├── db/                                Datenbank
│   ├── schema.sql                   Tabellen
│   └── seeds.sql                    Test-Daten
│
├── Doku/                              Formelle Dokumentation
│   ├── Diagramme/                   PlantUML Diagramme
│   └── FragenPool/                  Fragen-Vorlagen
```

