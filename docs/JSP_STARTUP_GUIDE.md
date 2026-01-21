# 🚀 JSP Startup Guide - Projekt Wissenstest

## 🟢 One-Click Setup (Empfohlen)

Wir haben ein automatisiertes Skript erstellt, das Java, Maven und Tomcat **automatisch herunterlädt und konfiguriert**, das Projekt baut und den Server startet. Du musst nichts vorinstallieren!

1. Öffne den Ordner `startup` im Projekt.
2. Rechtsklick auf `start_project.ps1` -> "Mit PowerShell ausführen".
3. Lehn dich zurück. Das Skript erledigt den Rest.

---

Diese Anleitung zeigt dir, wie du das Projekt mit **JSP Frontend** lokal oder auf einem Server startest.

---

## ⚡ Quick Start (nur Frontend Demo - 5 Minuten)

**Du willst nur schnell das Frontend anschauen? Hier der schnellste Weg:**

```bash
# 1. Backend bauen
cd "mainlogik, backend"
mvn clean package

# 2. WAR deployen
copy target\wissentest.war C:\tomcat11\webapps\

# 3. Tomcat starten (falls nicht läuft)
C:\tomcat11\bin\startup.bat

# 4. Öffnen im Browser:
# http://localhost:8080/wissentest/

# Login mit Demo-Konto:
# Benutzer: student
# Passwort: student123
```

**Das wars! Das Frontend lädt mit Mock-Daten!**

> 💡 **Hinweis:** Ohne echte PostgreSQL funktioniert nur die Anzeige. Zum Speichern von Daten muss die komplette Installation (Schritt 1-3 unten) erfolgen.

---

## 📋 Voraussetzungen

### Installiert sein müssen:
- ✅ **Java 17 JDK** (oder höher)
- ✅ **Maven 3.8+** (für das Build)
- ✅ **PostgreSQL 15** (oder kompatibel)
- ✅ **Tomcat 8.5 / 10 / 11** (für JSP-Rendering)

### Benötigte Dateien:
- ✅ `db/schema.sql` – Datenbank-Schema
- ✅ `db/seeds.sql` – Test-Daten
- ✅ `db.properties` – DB-Konfiguration (im Backend)

---

## 🔧 Schritt 1: Datenbank einrichten

### 1a) PostgreSQL starten
```bash
# Windows
pg_ctl -D "C:\Program Files\PostgreSQL\15\data" start

# Linux/Mac
sudo systemctl start postgresql
```

### 1b) Datenbank anlegen
```sql
-- Als Superuser (z.B. postgres) ausführen:
CREATE DATABASE wissentest;
CREATE USER student WITH ENCRYPTED PASSWORD 'student';
GRANT ALL PRIVILEGES ON DATABASE wissentest TO student;
```

### 1c) Schema laden
```bash
# Option 1: Mit pgAdmin4
# 1. Datenbank "wissentest" auswählen
# 2. Query-Tool öffnen
# 3. Dateiinhalt von db/schema.sql einfügen und ausführen

# Option 2: Mit psql (Terminal)
psql -U student -d wissentest -f db/schema.sql
```

### 1d) Testdaten laden
```bash
# Mit psql:
psql -U student -d wissentest -f db/seeds.sql

# Dann Admin-User Hash setzen (in db/seeds.sql):
# - Hash und Salt generieren (s. testing_guide.md)
# - In seeds.sql eintragen
# - Erneut ausführen
```

---

## 🏗️ Schritt 2: Backend mit JSP bauen

### 2a) In Backend-Verzeichnis wechseln
```bash
cd "mainlogik, backend"
```

### 2b) Maven Build ausführen
```bash
mvn clean package
```

**Ergebnis:**
- ✅ WAR-Datei: `target/wissentest.war`
- ✅ Logs zeigen: `BUILD SUCCESS`

### 2c) Fehlerbehandlung
Falls der Build fehlschlägt:

| Fehler | Lösung |
|--------|--------|
| `[ERROR] COMPILATION ERROR` | Java 17+ installieren: `java -version` |
| `[ERROR] Failed to read schema.sql` | `db/schema.sql` existiert? Pfad korrekt? |
| `Could not connect to database` | PostgreSQL läuft? `db.properties` korrekt? |

---

## 🚁 Schritt 3: Tomcat deployment

### Option A: Lokale Entwicklung (Windows)

#### 3a) Tomcat herunterladen & entpacken
```bash
# Oder bereits installiert?
C:\tomcat11\

# Ordnerstruktur:
C:\tomcat11\
├── bin/           # catalina.bat, startup.bat
├── webapps/       # Apps here
├── conf/          # server.xml
└── logs/          # catalina.out
```

#### 3b) WAR-Datei deployen
**Methode 1: Manuell kopieren (einfach)**
```bash
# WAR in Tomcat webapps kopieren:
copy "mainlogik, backend\target\wissentest.war" "C:\tomcat11\webapps\"

# Tomcat startet automatisch und entpackt die WAR
```

**Methode 2: Über Tomcat Manager (bequem)**
```
1. Tomcat starten: C:\tomcat11\bin\startup.bat
2. Browser: http://localhost:8080
3. "Manager App" öffnen
4. WAR hochladen unter "Deploy"
5. Warten bis "wissentest" im Status "running" ist
```

#### 3c) Tomcat starten
```bash
# Windows
C:\tomcat11\bin\startup.bat

# Linux/Mac
./catalina.sh run

# Oder als Service (Windows)
net start Tomcat11
```

### Option B: Remote Server (z.B. Uni-Server)

#### 3b-Remote) WAR auf Server übertragen
```bash
# SCP oder direkt in Tomcat-Verzeichnis kopieren
scp "mainlogik, backend\target\wissentest.war" user@server:/opt/tomcat/webapps/
```

#### 3c-Remote) Tomcat neustarten
```bash
# SSH zum Server
ssh user@server

# Tomcat neustarten
sudo systemctl restart tomcat

# Oder
cd /opt/tomcat
./bin/shutdown.sh
./bin/startup.sh
```

---

## 🎬 Alternative: Demo-Modus (ohne echte Datenbank)

### Schnelles Frontend-Testing ohne DB

Wenn du **nur das Frontend schnell anschauen** möchtest (ohne PostgreSQL zu installieren):

#### Schritt 1: Datenbank-Konfiguration anpassen
**Datei:** `mainlogik, backend/src/main/resources/db.properties`

Ändern zu:
```properties
# Demo-Modus aktivieren
demo.mode=true
demo.user=student
demo.admin=admin
```

### Schritt 2: Mock-Datenbank aktivieren (Optional)
**Datei:** `mainlogik, backend/src/main/java/de/dhsn/wissentest/util/DbConnectionManager.java`

Ändern der `getConnection()` Methode zu:
```java
public static Connection getConnection() throws SQLException {
    // Demo-Modus: Mock-Daten zurückgeben statt echter DB
    if (isDemoMode()) {
        return new MockConnection();
    }
    // ... normale DB-Verbindung
}
```

**Alternative (einfacher): Demo-Servlet hinzufügen**

Erstelle `DemoTestServlet.java` im Backend (`src/main/java/.../web/`):

```java
package de.dhsn.wissentest.web;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/api/demo/tests")
public class DemoTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Demo-Tests zurückgeben (ohne DB)
        JSONArray tests = new JSONArray();
        tests.put(new JSONObject()
            .put("id", 1)
            .put("title", "Demo-Test: Grundlagen")
            .put("description", "Dieser Test ist eine Demo"));
        tests.put(new JSONObject()
            .put("id", 2)
            .put("title", "Demo-Test: Fortgeschrittene")
            .put("description", "Für Test-Zwecke"));
        
        resp.setContentType("application/json");
        resp.getWriter().println(new JSONObject()
            .put("success", true)
            .put("data", tests)
            .toString());
    }
}
```

#### Schritt 3: Backend bauen & starten
```bash
cd "mainlogik, backend"
mvn clean package
# WAR deployen wie in Schritt 3 oben
```

#### Schritt 4: Im Browser öffnen
```
http://localhost:8080/wissentest/
```

#### Demo-Konten (für Testing):

| Benutzer | Passwort | Rolle |
|----------|----------|-------|
| `student` | `student123` | Student |
| `admin` | `admin123` | Admin |

---

### Was funktioniert im Demo-Modus? ✅

| Feature | Status | Beschreibung |
|---------|--------|-------------|
| 🏠 **Startseite anzeigen** | ✅ | Landing Page wird geladen |
| 🔐 **Login-Formular** | ✅ | Formular wird angezeigt |
| 📝 **Registrierung** | ⚠️ Demo | Demo-Benutzer nur (nicht speicherbar) |
| 📋 **Tests anzeigen** | ✅ | Demo-Tests aus Mock-Servlets |
| ✍️ **Test bearbeiten** | ✅ Demo | Anzeige funktioniert, DB-Save nicht |
| 👥 **Admin-Panel** | ✅ Demo | Oberfläche sichtbar, Änderungen nicht persistent |
| 💾 **Daten speichern** | ❌ | Keine echte Persistierung ohne DB |
| 📊 **Statistiken** | ⚠️ Demo | Mock-Daten angezeigt |

---

### Schnellstart Demo-Modus

```bash
# Alles auf einmal (ohne DB):
cd "mainlogik, backend"
mvn clean package

# WAR deployen
copy target\wissentest.war C:\tomcat11\webapps\

# Tomcat starten
C:\tomcat11\bin\startup.bat

# Im Browser öffnen:
# http://localhost:8080/wissentest/
# Login: student / student123
```

---



### 4a) Health-Check
```bash
# Terminal/Browser:
curl http://localhost:8080/wissentest/health
# Erwartete Antwort:
# {"status":"ok"}
```

### 4b) Frontend öffnen
```
Browser: http://localhost:8080/wissentest/
```

Du solltest sehen:
- ✅ Startseite mit "Projekt Wissenstest"
- ✅ Login-Button
- ✅ Registrierungs-Link

### 4c) Login testen
```
Testdaten (aus db/seeds.sql):
- Benutzer: student
- Passwort: student123
```

### 4d) Test durchführen
1. Nach Login: "Test starten" klicken
2. Fragen beantworten
3. Ergebnis mit Noten sehen

---

## 🐛 Fehlerbehebung

### "Seite nicht erreichbar"
```
Problem: Browser zeigt Fehler
Lösung:
  1. Tomcat läuft? (http://localhost:8080 sollte Tomcat-Startseite zeigen)
  2. WAR deployed? (http://localhost:8080/manager -> wissentest sollte GREEN sein)
  3. Ports korrekt? (Tomcat auf 8080? Nicht blockiert?)
```

### "Datenbankfehler"
```
Problem: Login funktioniert nicht, DB-Fehler
Lösung:
  1. PostgreSQL läuft? (psql -U student -d wissentest)
  2. Tabellen vorhanden? (SELECT * FROM "user";)
  3. db.properties korrekt? (Backend neu bauen: mvn clean package)
```

### "JSP-Seite zeigt Code statt zu rendern"
```
Problem: Quellcode wird angezeigt statt HTML
Lösung:
  1. Tomcat .jsp MIME-Type konfiguriert? (server.xml)
  2. Tomcat neu starten
  3. Browser Cache löschen
```

### "403 Forbidden"
```
Problem: Zugriff verweigert
Lösung:
  1. URL korrekt? (http://localhost:8080/wissentest/ nicht /wissentest)
  2. index.jsp vorhanden? (webapps/wissentest/index.jsp)
  3. Datei-Permissions prüfen
```

---

## 📁 Projektstruktur JSP

Die JSP-Dateien sind im Backend-Projekt organisiert:

```
mainlogik, backend/src/main/webapp/
│
├── index.jsp                           # Routing-Einstieg
├── native.jsp                          # Navigation
│
├── jsp_native/                         # JSP-Komponenten
│   ├── LandingPage.jsp                # Start-Seite
│   ├── Login.jsp                      # Login-Formular
│   ├── Register.jsp                   # Registrierung
│   ├── TestList.jsp                   # Test-Übersicht
│   ├── TestRunner.jsp                 # Quiz (interaktiv)
│   ├── Result.jsp                     # Ergebnis-Anzeige
│   ├── AdminPanel.jsp                 # Admin-Dashboard
│   ├── LearnMode.jsp                  # Lernmodus
│   └── FlipCard.jsp                   # Flip-Card (Fragment)
│
├── css/
│   ├── main.css                       # Global Styles
│   ├── components.css                 # Komponenten
│   └── animations.css                 # Animationen
│
└── js/
    ├── app.js                         # Business Logic
    ├── apiClient.js                   # REST-Client
    └── utils.js                       # Utilities
```

---

## 🔗 Wichtige URLs

| URL | Beschreibung |
|-----|-------------|
| `http://localhost:8080/wissentest/` | 🏠 Startseite |
| `http://localhost:8080/wissentest/native.jsp` | 📄 JSP-Test |
| `http://localhost:8080/wissentest/health` | ❤️ Health-Check |
| `http://localhost:8080/wissentest/api/auth/login` | 🔐 API-Endpoint |
| `http://localhost:8080/manager/html` | 🎮 Tomcat Manager |

---

## 📚 Weitere Dokumentation

- **[Compliance-Check](JSP_COMPLIANCE_ANALYSIS.md)** – Ist JSP konform?
- **[JSP Native Guide](JSP_NATIVE_GUIDE.md)** – Architektur-Details
- **[Wiki - JSP Komponenten](wiki/JSP_NATIVE_COMPONENTS.md)** – Komponenten dokumentiert
- **[Start Local (kurz)](wiki/start_local.md)** – Schnellversion dieser Anleitung
- **[Backend Architektur](ARCHITECTURE_DIAGRAMS.md)** – Class-Diagramme

---

## ✨ Besonderheiten der JSP-Version

✅ **Server-seitiges Rendering** – JSP wird auf dem Server zu HTML umgewandelt  
✅ **Keine Build-Tool nötig** – Nur Maven für Backend  
✅ **Volle Java-Integration** – Direct Access zu Servlets & Services  
✅ **Konform mit Anforderungen** – "Java Webtechnologie"  
✅ **Optimiert für Deployment** – Single WAR-Datei reicht  

---

**Viel Erfolg beim Start! 🎉**

Bei Fragen: Siehe [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md) für Detailinformationen.
