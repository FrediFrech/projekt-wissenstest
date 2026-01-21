# 🚀 JSP Startup Guide - Projekt Wissenstest

## 🟢 One-Click Setup (Empfohlen)
Nutze das Skript in [startup/start_project.ps1](../startup/start_project.ps1). Es lädt Java, Maven, Tomcat und PostgreSQL portabel, baut das WAR und startet alles.

**Ablauf:**
1. Ordner `startup` öffnen.
2. `start_project.ps1` mit PowerShell ausführen.
3. Warten, bis Tomcat startet.

**Standard‑Ports (Skript):**
- PostgreSQL: **5433**
- Tomcat: **8080**

**Login:**
- Student: `student` / `student`
- Admin: `lehrer` / `student`

---

## 📋 Manuelles Setup (falls du kein Skript nutzt)

### Voraussetzungen
- Java 17
- Maven 3.8+
- PostgreSQL 15/16
- Tomcat 9.x (empfohlen)

### 1) Datenbank einrichten
```
DB Name: wissentest
User: student
Passwort: student
```

Schema & Seeds:
- `db/schema.sql`
- `db/seeds.sql`

### 2) `db.properties` prüfen
Datei: `mainlogik, backend/src/main/resources/db.properties`

Default im Repo:
```
db.url=jdbc:postgresql://localhost:5433/wissentest
db.user=student
db.password=student
```

**Wenn du PostgreSQL auf 5432 nutzt:**
Passe `db.url` auf `5432` an.

### 3) Build
```
cd "mainlogik, backend"
mvn clean package
```

### 4) Deploy
Kopiere `target/wissentest.war` nach Tomcat `webapps/` und starte Tomcat.

---

## ✅ Health‑Check
URL: `http://localhost:8080/wissentest/health`

Antwort:
```
{"status":"ok"}
```

---

## 🛠️ Troubleshooting (Kurz)
- **DB‑Fehler:** Läuft PostgreSQL? Stimmt Port in `db.properties`?
- **401/403:** Login erforderlich (Session).
- **404 /health:** WAR korrekt deployed?

---

## Hinweis zu „Demo‑Modus“
Ein echter DB‑freier Demo‑Modus ist **nicht implementiert**. Für eine schnelle Demo nutze das Start‑Skript, es bringt die DB automatisch mit.

✅ **Server-seitiges Rendering** – JSP wird auf dem Server zu HTML umgewandelt  
✅ **Keine Build-Tool nötig** – Nur Maven für Backend  
✅ **Volle Java-Integration** – Direct Access zu Servlets & Services  
✅ **Konform mit Anforderungen** – "Java Webtechnologie"  
✅ **Optimiert für Deployment** – Single WAR-Datei reicht  

---

**Viel Erfolg beim Start! 🎉**

Bei Fragen: Siehe [ARCHITECTURE_DIAGRAMS.md](ARCHITECTURE_DIAGRAMS.md) für Detailinformationen.
