# Lokale Installation

Es gibt zwei Wege, die Anwendung auf dem eigenen Rechner zu starten: das Startskript für Windows, das alles automatisch erledigt, oder die manuelle Einrichtung.

## Variante A: Startskript (Windows)

Das Skript `startup/start_project.ps1` lädt alle benötigten Werkzeuge als portable Versionen in den Ordner `startup/tools/`, baut die Anwendung und startet sie. Es muss vorher nichts installiert sein.

```powershell
cd startup
powershell -ExecutionPolicy Bypass -File .\start_project.ps1
```

Das Skript arbeitet in fünf Schritten:

1. **Werkzeuge prüfen und laden:** JDK 17, Maven 3.9, Tomcat 9, PostgreSQL 16 (und Node.js für die End-to-End-Tests)
2. **Datenbank vorbereiten:** PostgreSQL auf Port **5433** starten, beim ersten Mal Schema und Beispieldaten einspielen. Läuft die Datenbank schon, werden nur neue Beispieldaten ergänzt, vorhandene Daten bleiben erhalten.
3. **Bauen:** `mvn clean package` (ohne Unit-Tests, damit der Start schnell geht)
4. **Bereitstellen:** `wissentest.war` in den `webapps`-Ordner von Tomcat kopieren
5. **Starten:** Tomcat auf Port **8080** hochfahren

Danach ist die Anwendung unter <http://localhost:8080/wissentest/> erreichbar.

!!! warning "Port 8080"
    Ist Port 8080 bereits belegt, beendet das Skript den Prozess, der ihn benutzt, ohne nachzufragen. Vorher also prüfen, ob dort etwas Wichtiges läuft.

Der erste Seitenaufruf dauert etwas länger, weil Tomcat die JSP-Seiten beim ersten Zugriff übersetzt.

## Variante B: Manuelle Einrichtung

### Voraussetzungen

| Werkzeug | Version |
|---|---|
| Java (JDK) | genau 17, der Build bricht mit anderen Versionen ab |
| Maven | 3.8 oder neuer |
| PostgreSQL | 15 oder 16 |
| Tomcat | 8.5 oder 9 (nicht 10 oder 11, siehe [Deployment](deployment.md#tomcat-version)) |

### 1. Datenbank anlegen

```sql
CREATE USER student WITH PASSWORD 'student';
CREATE DATABASE wissentest OWNER student;
```

Danach Schema und Beispieldaten einspielen:

```bash
psql -p 5433 -U student -d wissentest -f db/schema.sql
psql -p 5433 -U student -d wissentest -f db/seeds.sql
```

Läuft PostgreSQL auf dem Standardport 5432, den Port in den Befehlen und in `db.properties` anpassen.

### 2. Verbindung einstellen

Datei `mainlogik, backend/src/main/resources/db.properties`:

```properties
db.url=jdbc:postgresql://localhost:5433/wissentest
db.user=student
db.password=student
```

### 3. Bauen und starten

```bash
cd "mainlogik, backend"
mvn clean package
```

Die Datei `target/wissentest.war` in den Ordner `webapps/` von Tomcat kopieren und Tomcat starten.

## Funktion prüfen

<http://localhost:8080/wissentest/health> muss mit folgendem antworten:

```json
{"status":"ok"}
```

Anschließend mit einem der Demo-Konten anmelden (siehe [Startseite](../index.md)).

## Häufige Probleme

| Symptom | Ursache und Lösung |
|---|---|
| Fehler bei Datenbankzugriffen | PostgreSQL läuft nicht oder Port/Zugangsdaten in `db.properties` stimmen nicht. |
| `relation "users" does not exist` | Das Schema wurde nicht eingespielt oder in eine andere Datenbank geladen. |
| Maven-Build bricht sofort ab | Maven läuft nicht mit Java 17. `mvn -v` prüfen, siehe [Deployment](deployment.md#war-bauen). |
| `/health` liefert 404 | Die WAR-Datei wurde nicht (richtig) bereitgestellt oder heißt anders als `wissentest.war`. |
| API antwortet mit „Not authenticated“ (400) oder „Forbidden“ (403) | Keine gültige Sitzung oder fehlende Admin-Rolle. Neu anmelden. |
