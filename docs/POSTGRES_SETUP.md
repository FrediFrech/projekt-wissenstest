# PostgreSQL & pgAdmin4 Setup-Anleitung

> **Hinweis:** Für dieses Projekt ist keine manuelle Installation von PostgreSQL erforderlich!
> Das Start-Skript `startup/start_project.ps1` lädt und startet automatisch eine portable PostgreSQL-Instanz auf Port **5433**.
> Diese Anleitung dient nur als Referenz für manuelle Setups oder pgAdmin4.

## Inhalt
1. [PostgreSQL Installation](#1-postgresql-installation)
2. [pgAdmin4 Installation & Konfiguration](#2-pgadmin4-installation--konfiguration)
3. [Datenbank einrichten](#3-datenbank-einrichten)
4. [Backend-Konfiguration](#4-backend-konfiguration)
5. [Verbindung testen](#5-verbindung-testen)
6. [Troubleshooting](#6-troubleshooting)

---

## 1. PostgreSQL Installation

### Windows
1. Download von [postgresql.org/download/windows](https://www.postgresql.org/download/windows/)
2. Installer ausführen (empfohlen: Version 15+)
3. Installation-Wizard durchlaufen:
   - Port: `5432` (Standard) **oder** `5433` (passt zum Repo‑Default)
   - Superuser Passwort: **gut merken!**
   - Locale: German/Deutschland oder Standard
4. Nach Installation: Prüfe ob PostgreSQL-Service läuft
   - Windows Services öffnen (Win + R → `services.msc`)
   - Suche "postgresql-x64-15" (oder deine Version)
   - Status sollte "Wird ausgeführt" sein

### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

### macOS
```bash
brew install postgresql@15
brew services start postgresql@15
```

---

## 2. pgAdmin4 Installation & Konfiguration

### Installation
- **Windows/macOS:** Download von [pgadmin.org](https://www.pgadmin.org/download/)
- **Linux:** 
```bash
sudo apt install pgadmin4
```

### Erstes Login in pgAdmin4
1. pgAdmin4 öffnen → Browser öffnet sich
2. Master-Passwort setzen (für pgAdmin selbst, nicht PostgreSQL!)
3. Server hinzufügen:
   - **Rechtsklick auf "Servers"** → Create → Server
   - **General Tab:**
     - Name: `Wissenstest Local`
   - **Connection Tab:**
     - Host: `localhost`
   - Port: `5433` (wenn du das Start‑Skript nutzt)
     - Maintenance database: `postgres`
     - Username: `postgres`
     - Password: [dein PostgreSQL Superuser Passwort]
     - ✅ "Save password?" aktivieren
   - **Save** klicken

### Server-Verbindung prüfen
- Linke Sidebar: `Servers` → `Wissenstest Local` aufklappen
- Wenn keine Fehlermeldung kommt → Verbindung erfolgreich ✅

---

## 3. Datenbank einrichten

### 3.1 Datenbank erstellen
**Option A: Via pgAdmin4 (GUI)**
1. Rechtsklick auf "Databases" → Create → Database
2. Database Name: `wissentest`
3. Owner: `postgres` (oder neuer User, siehe 3.2)
4. Encoding: `UTF8`
5. **Save**

**Option B: Via SQL**
```sql
CREATE DATABASE wissentest
  WITH ENCODING='UTF8'
       OWNER=postgres
       CONNECTION LIMIT=-1;
```

### 3.2 Datenbank-User erstellen (empfohlen)
**Für Produktion:** Eigenen User anlegen statt `postgres` zu nutzen.

```sql
-- User erstellen
CREATE USER student WITH PASSWORD 'student';

-- Alle Rechte auf wissentest-Datenbank geben
GRANT ALL PRIVILEGES ON DATABASE wissentest TO student;

-- Zur wissentest Datenbank wechseln
\c wissentest

-- Schema-Rechte geben
GRANT ALL ON SCHEMA public TO student;
GRANT ALL ON ALL TABLES IN SCHEMA public TO student;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO student;
```

### 3.3 Schema laden
1. In pgAdmin4: `Wissenstest Local` → `Databases` → `wissentest` auswählen
2. Oben auf **Tools** → **Query Tool**
3. Datei `db/schema.sql` öffnen und Inhalt einfügen
4. **F5** oder **Execute** Knopf drücken
5. Prüfen: `Tables` Ordner sollte jetzt folgende Tabellen zeigen:
   - `users`
   - `questions`
   - `answers`
   - `cloze_answers`
   - `attempts`
   - `attempt_answers`
   - `config`

### 3.4 Seed-Daten laden (optional aber empfohlen)
1. Datei `db/seeds.sql` öffnen
2. **Wichtig:** Admin-Passwort-Hash ersetzen:
   ```sql
   -- In seeds.sql finden:
   INSERT INTO users (username, password_hash, password_salt, role) VALUES
   ('admin', 'PLATZHALTER_HASH', 'PLATZHALTER_SALT', 'admin');
   ```
   
   **Hash generieren mit Java:**
   ```java
   // Im Backend-Projekt ausführen:
   String password = "admin123";
   String salt = PasswordUtils.generateSalt();
   String hash = PasswordUtils.hashPassword(password, salt);
   System.out.println("Salt: " + salt);
   System.out.println("Hash: " + hash);
   ```
   
   Oder direkt in PostgreSQL (wenn pgcrypto Extension installiert):
   ```sql
   -- pgcrypto installieren
   CREATE EXTENSION IF NOT EXISTS pgcrypto;
   
   -- Hash generieren
   SELECT encode(digest('admin123' || 'DEIN_SALT', 'sha256'), 'hex');
   ```

3. Seeds ausführen in Query Tool (F5)
4. Prüfen: Query `SELECT * FROM users;` sollte mind. 2 User zeigen

---

## 4. Backend-Konfiguration

### 4.1 db.properties anpassen
Datei: `mainlogik, backend/src/main/resources/db.properties`

```properties
# PostgreSQL Verbindung
db.url=jdbc:postgresql://localhost:5433/wissentest
db.user=student
db.password=student
db.pool.maxSize=10
```

**Wichtig:** 
- Für Entwicklung: `student/student` ist OK
- Für Produktion: Sicheres Passwort verwenden!

### 4.2 MS SQL Support (für Hochschul-Server)
Falls später MS SQL statt PostgreSQL genutzt wird:

```xml
<!-- In pom.xml: PostgreSQL-Treiber auskommentieren, MS SQL aktivieren -->
<dependency>
    <groupId>com.microsoft.sqlserver</groupId>
    <artifactId>mssql-jdbc</artifactId>
    <version>12.4.1.jre11</version>
</dependency>
```

```properties
# db.properties für MS SQL
db.url=jdbc:sqlserver://SERVER:1433;databaseName=wissentest;encrypt=false
db.user=IHR_USER
db.password=IHR_PASSWORT
```

---

## 5. Verbindung testen

### 5.1 Backend testen
```bash
cd "mainlogik, backend"
mvn clean test
```

**Erfolg:** Wenn Tests durchlaufen (grün), funktioniert DB-Verbindung ✅

**Fehler "Connection refused":**
- PostgreSQL läuft nicht → Service starten
- Port falsch → db.properties prüfen

### 5.2 pgAdmin4 Verbindung prüfen
```sql
-- Im Query Tool ausführen:
SELECT current_database(), current_user, version();
```

Erwartete Ausgabe:
```
current_database | current_user |  version
-----------------|--------------|----------
wissentest       | student      | PostgreSQL 15.x ...
```

### 5.3 Vollständiger Backend-Start
```bash
# WAR bauen
mvn clean package

# In Tomcat deployen
# → Öffne http://localhost:8080/wissentest/health
```

Erwartete Antwort:
```json
{
   "status": "ok"
}
```

---

## 6. Troubleshooting

### Problem: "Passwort-Authentifizierung fehlgeschlagen"

**Ursache:** pgAdmin/Backend nutzt falsches Passwort

**Lösung:**
```sql
-- Passwort für User zurücksetzen
ALTER USER student WITH PASSWORD 'neues_passwort';
```

Dann `db.properties` aktualisieren!

---

### Problem: "Verbindung zu Server konnte nicht hergestellt werden"

**Ursachen & Lösungen:**

1. **PostgreSQL läuft nicht**
   ```bash
   # Windows: Services prüfen (services.msc)
   # Linux:
   sudo systemctl status postgresql
   sudo systemctl start postgresql
   ```

2. **Falscher Port**
   - Standard: 5432 (manuelle Installation)
   - Start‑Skript: 5433
   - Prüfe in `postgresql.conf`: `port = 5432` oder `5433`
   - Oder finde Port: `sudo netstat -plnt | grep postgres`

3. **Firewall blockiert**
   ```bash
   # Linux: Port freigeben
   sudo ufw allow 5432/tcp
   # oder 5433, falls du den Script‑Port nutzt
   ```

---

### Problem: "Relation does not exist" bei SQL-Abfragen

**Ursache:** Schema wurde nicht geladen oder falscher User

**Lösung:**
1. Schema neu laden (Schritt 3.3)
2. User-Rechte prüfen (Schritt 3.2)
3. Im Query Tool: Aktive Datenbank prüfen (oben in pgAdmin4)

---

### Problem: pgAdmin4 hängt beim Start

**Lösung:**
```bash
# Alte Sessions löschen (Windows)
del /Q "%APPDATA%\pgAdmin\sessions\*"

# Linux/macOS
rm -rf ~/.pgadmin/sessions/*
```

---

### Problem: "Too many connections"

**Ursache:** Connection Pool nicht geschlossen oder zu viele parallele Requests

**Lösung:**
```sql
-- Aktive Verbindungen prüfen
SELECT count(*) FROM pg_stat_activity WHERE datname = 'wissentest';

-- Alte Verbindungen killen (Vorsicht!)
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = 'wissentest' AND pid <> pg_backend_pid();
```

**Dauerhafte Lösung:** In `db.properties`:
```properties
db.pool.maxSize=5  # Reduzieren falls nötig
```

---

## Anhang: Nützliche pgAdmin4 Features

### Visuelle Schema-Darstellung
1. Rechtsklick auf `wissentest` DB → **ERD For Database**
2. Zeigt Entity-Relationship-Diagram mit allen Tabellen

### Backup erstellen
1. Rechtsklick auf `wissentest` → **Backup...**
2. Filename: `wissentest_backup_DATUM.sql`
3. Format: **Plain** (für Text-SQL) oder **Custom** (komprimiert)
4. **Backup** klicken

### Restore aus Backup
1. Rechtsklick auf `wissentest` → **Restore...**
2. Backup-Datei auswählen
3. **Restore** klicken

### SQL-Query Ergebnisse exportieren
1. Query ausführen
2. Rechtsklick auf Ergebnistabelle → **Copy as CSV**

---

## Zusammenfassung der Ports

| Service       | Port  | URL                                    |
|---------------|-------|----------------------------------------|
| PostgreSQL    | 5433  | `jdbc:postgresql://localhost:5433/...` |
| pgAdmin4      | 5050  | `http://localhost:5050` (Browser)      |
| Tomcat        | 8080  | `http://localhost:8080/wissentest/`    |

---

## Kontakt & Support

Bei Problemen:
1. PostgreSQL Logs prüfen: `pgAdmin4 → Dashboard → Server Activity`
2. Backend Logs: Tomcat `logs/catalina.out`
3. HikariCP Connection Pool Statistiken im Backend aktivieren (siehe `DbConnectionManager.java`)

**Ende der Anleitung**
