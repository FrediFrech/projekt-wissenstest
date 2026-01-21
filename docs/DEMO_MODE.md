# 🎬 Demo-Modus Anleitung

**Schnelles Frontend-Testing ohne echte Datenbank**

---

## Warum Demo-Modus?

| Szenario | Lösung |
|----------|--------|
| 🎯 Schnell das Frontend anschauen (5 Min) | ✅ Demo-Modus |
| 🧪 Features testen, ohne DB zu konfigurieren | ✅ Demo-Modus |
| 📊 Vor Publikum präsentieren | ✅ Demo-Modus |
| 💾 Echte Daten speichern/editieren | ❌ Braucht echte DB |
| 🔐 Echte Benutzer-Verwaltung | ❌ Braucht echte DB |

---

## 🚀 Schnellstart (ohne DB)

### 1️⃣ Backend bauen
```bash
cd "mainlogik, backend"
mvn clean package
```

### 2️⃣ WAR deployen
```bash
# Option A: Manuell kopieren
copy target\wissentest.war C:\tomcat11\webapps\

# Option B: Wenn Tomcat läuft, über Manager
# http://localhost:8080/manager -> Deploy WAR
```

### 3️⃣ Tomcat starten
```bash
# Windows
C:\tomcat11\bin\startup.bat

# Linux/Mac
./catalina.sh run
```

### 4️⃣ Im Browser öffnen
```
http://localhost:8080/wissentest/
```

### 5️⃣ Mit Demo-Konto einloggen
```
Benutzer: student
Passwort: student123

oder

Benutzer: admin
Passwort: admin123
```

✅ **Fertig! Frontend lädt mit Mock-Daten!**

---

## 📝 Demo-Konten (vorkonfiguriert)

Diese Konten sind **vordefiniert** und funktionieren auch ohne echte Datenbank:

### Student-Konto
```
Benutzername: student
Passwort: student123
Email: student@example.com
Rolle: Schüler
Status: Aktiv
```

### Admin-Konto
```
Benutzername: admin
Passwort: admin123
Email: admin@example.com
Rolle: Administrator
Status: Aktiv
```

---

## ✅ Was funktioniert im Demo-Modus?

### Frontend (anzeigen)
- ✅ Startseite / Landing Page
- ✅ Login-Formular
- ✅ Registrierungs-Formular
- ✅ Test-Übersicht
- ✅ Quiz-Interface
- ✅ Admin-Dashboard
- ✅ Lernmodus / Flip-Cards
- ✅ Styling & Animationen

### Backend (ohne DB)
- ⚠️ Login funktioniert (nur Demo-Konten)
- ⚠️ Fragen anzeigen (aus Mock-Daten)
- ❌ Neue Benutzer registrieren (nicht persistent)
- ❌ Noten speichern
- ❌ Admin-Änderungen speichern
- ❌ Echte Datenbankabfragen

---

## 🔧 Optional: Mock-Daten erweitern

### Wenn du mehr Demo-Daten möchtest:

**Datei:** `mainlogik, backend/src/main/java/.../web/DemoTestServlet.java`

```java
@WebServlet("/api/demo/tests")
public class DemoTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Demo-Tests zurückgeben
        JSONArray tests = new JSONArray();
        
        tests.put(new JSONObject()
            .put("id", 1)
            .put("title", "Mathematik Grundlagen")
            .put("description", "Test 1: Zahlen und Operationen")
            .put("questionCount", 5));
        
        tests.put(new JSONObject()
            .put("id", 2)
            .put("title", "Englisch Vokabeln")
            .put("description", "Test 2: Wortschatz")
            .put("questionCount", 10));
        
        tests.put(new JSONObject()
            .put("id", 3)
            .put("title", "Geschichte Europa")
            .put("description", "Test 3: Mittelalter bis Modern")
            .put("questionCount", 8));
        
        resp.setContentType("application/json");
        resp.getWriter().println(new JSONObject()
            .put("success", true)
            .put("tests", tests)
            .toString());
    }
}
```

Dann:
```bash
mvn clean package
# WAR neu deployen
```

---

## 🎯 Use Cases für Demo-Modus

### 1. Schnelle Demo für Dozent
```
Zeitbedarf: 10 Min
- Backend bauen
- WAR deployen
- Präsentieren
```

### 2. Feature-Testing
```
Zeitbedarf: 15 Min
- Frontend-Flows testen
- UI/UX überprüfen
- Styling kontrollieren
```

### 3. Entwicklung ohne DB
```
Zeitbedarf: Laufend
- JSP-Seiten ändern
- CSS/JS anpassen
- Schnell testen (mvn clean package + refresh)
```

### 4. Öffentliche Vorführung
```
Zeitbedarf: 20 Min
- Alle Features zeigen (mit Mock-Daten)
- Keine DB-Fehler möglich
- Stable & zuverlässig
```

---

## ⚠️ Bekannte Einschränkungen

| Feature | Demo-Modus | Mit echter DB |
|---------|-----------|---------------|
| Login mit Demo-Konten | ✅ | ✅ |
| Quiz durchführen | ⚠️ Simulated | ✅ Real |
| Noten speichern | ❌ | ✅ |
| Neue Benutzer anlegen | ❌ | ✅ |
| Admin-Einstellungen | ⚠️ UI only | ✅ |
| Lernmodus nutzen | ✅ UI | ⚠️ keine History |
| Statistiken/Reports | ⚠️ Mock | ✅ Real |

---

## 🔄 Von Demo zu Produktion

Wenn du von Demo-Modus zu **echter Datenbank** wechseln möchtest:

### 1. PostgreSQL installieren
```bash
# Siehe: POSTGRES_SETUP.md
```

### 2. DB konfigurieren
```bash
# Siehe: Schritt 1 in JSP_STARTUP_GUIDE.md
```

### 3. db.properties anpassen
```properties
db.url=jdbc:postgresql://localhost:5432/wissentest
db.user=student
db.password=student
db.driver=org.postgresql.Driver
```

### 4. Neu bauen & deployen
```bash
mvn clean package
copy target\wissentest.war C:\tomcat11\webapps\
# Tomcat restart
```

### 5. Mit echten Daten testen
```
Gleiche Demo-Konten (student/admin) sollten jetzt mit echten Daten funktionieren!
```

---

## 📚 Weitere Ressourcen

- **[JSP_STARTUP_GUIDE.md](JSP_STARTUP_GUIDE.md)** – Vollständige Installation
- **[POSTGRES_SETUP.md](POSTGRES_SETUP.md)** – PostgreSQL einrichten
- **[wiki/start_local.md](wiki/start_local.md)** – Schnellstart
- **[JSP_NATIVE_GUIDE.md](JSP_NATIVE_GUIDE.md)** – JSP Architektur

---

**Happy Testing! 🚀**
