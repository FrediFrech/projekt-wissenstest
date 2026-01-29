# Deployment-Anleitung (Wissenstest UML)

Diese Anwendung wird als **WAR** gebaut (Maven `packaging=war`) und auf einem **Tomcat** deployed.

## 1) Was du zum Deployen wirklich brauchst

### Minimal (für Tomcat)
- **`mainlogik, backend/target/wissentest.war`**  
  → *Das ist das eigentliche Deploy-Artefakt. Nur diese Datei muss auf den Tomcat.*

### Zusätzlich (für die Datenbank)
- **`db/schema.sql`**  
  → erstellt Tabellen/Struktur
- **`db/seeds.sql`** (optional, aber für Demo/Präsentation sehr hilfreich)  
  → Beispielnutzer + Beispiel-Fragen
- **`mainlogik, backend/src/main/resources/db.properties`**  
  → DB-Zugangsdaten (wird beim Build in die WAR gepackt)

### Was du NICHT auf den Server kopieren musst
- `startup/` inkl. `tools/` (das ist nur für „lokal alles automatisch starten“)
- `docs/` und `Doku/` (nur für Abgabe/Dokumentation)
- Quellcode (`src/...`) *wenn du die WAR schon gebaut hast*


## 2) WAR bauen (auf deinem Rechner)

### 2.1) WICHTIG: Maven muss mit Java 17 laufen (nicht 8/11/25)

Das Projekt ist absichtlich so konfiguriert, dass **nur Java 17** akzeptiert wird (Build bricht sonst ab).

**Prüfen (auf deinem Rechner):**
- `mvn -v`

Erwartung:
- Bei `Java version:` muss **17.x** stehen.

Wenn da z.B. `1.8.x` steht (sehr häufig auf Windows wegen Oracle `java8path`), dann baut Maven nicht mit Java 17.

**Schnellster Fix (empfohlen):** nutze das Skript im Repo
- `projekt-wissenstest/build_war_jdk17.ps1`

Das Skript:
- setzt in der Session `JAVA_HOME`/`PATH` auf **JDK 17** (nimmt bevorzugt die im Repo mitgelieferte unter `startup/tools/jdk-17.../`)
- baut die WAR
- prüft, dass die Klassen unter `WEB-INF/classes` wirklich **Classfile-Version 61** (Java 17) sind
- kopiert ein deploy-fertiges Artefakt nach `deploy/`

**Dauerhafter Fix (Windows):**
- In den Umgebungsvariablen `JAVA_HOME` auf JDK 17 setzen
- In `PATH` sicherstellen, dass `%JAVA_HOME%\bin` **vor** `...\Oracle\Java\java8path` steht (oder `java8path` entfernen)

1. In den Backend-Ordner wechseln:
   - `projekt-wissenstest/mainlogik, backend/`
2. **DB-Konfiguration prüfen** (wichtig, siehe Abschnitt 4)
3. Build starten:
   - `mvn clean package`

Ergebnis:
- Die WAR liegt danach unter **`mainlogik, backend/target/wissentest.war`**


## 3) Deploy in Tomcat

## 3.5) Deploy auf dem DHSN Uni-Server (1-ssabz-01.dssax.de)

Diese Schritte sind **direkt** an der Aufgabenbeschreibung (Prof. Geisel) orientiert.

### Tomcat richtig wählen
- **Tomcat 8.5** läuft auf: `http://1-ssabz-01.dssax.de:8080/`
  - Manager: `http://1-ssabz-01.dssax.de:8080/manager/html`
  - Login: Benutzer **`admin`** (oder **`tomcat`**), Passwort **`student`**
- **Tomcat 11** ist auf **8082** installiert → **nicht verwenden** (weil unser Projekt `javax.servlet` nutzt).

### WAR-Name = URL (wichtig!)
Der Dateiname bestimmt den Kontextpfad.

Empfehlung für den Uni-Server:
- WAR vor dem Deploy umbenennen auf etwas **eindeutig pro Student**,
  z.B. `wissentest_s100XXXX.war`

Dann ist die Seite erreichbar unter:
- `http://1-ssabz-01.dssax.de:8080/wissentest_s100XXXX/`
- Health-Check: `http://1-ssabz-01.dssax.de:8080/wissentest_s100XXXX/health`

### Deployment (Uni-Server)
1. Mit Remote Desktop auf den Server (via Horizon Client).
2. Tomcat 8.5 starten (falls aus): `C:\XAMPP\xampp-control.exe` → Tomcat Start.
3. In die Manager App einloggen.
4. WAR deployen.
5. Wenn Tomcat die App startet, sofort `/health` testen.

Wenn die App im Manager auftaucht, aber „failed“ ist: Logs in `C:\XAMPP\tomcat\logs\` prüfen.

### Datenbank auf dem Uni-Server

#### Option A (empfohlen, passt zum aktuellen Code): PostgreSQL 15 (lokal auf dem Server)
Laut Aufgabenbeschreibung ist **Postgres 15** installiert:
- Host: `localhost`
- Port: `5432`
- User: `postgres`
- Passwort: `superpostgres`

Mit pgAdmin4 (ist auf dem Server installiert):
1. pgAdmin4 öffnen
2. Server hinzufügen: `localhost:5432`, User `postgres`, Passwort `superpostgres`
3. Datenbank anlegen (z.B. `wissentest_s100XXXX`)
4. `db/schema.sql` ausführen
5. (optional) `db/seeds.sql` ausführen (enthält Demo-User `student/student`, `lehrer/student`)

Dann `db.properties` in der deployed App setzen auf:
- `db.url=jdbc:postgresql://localhost:5432/wissentest_s100XXXX`
- `db.user=postgres` (oder eigener User)
- `db.password=superpostgres`

Wo du `db.properties` nach dem Deploy ändern kannst:
- `C:\XAMPP\tomcat\webapps\<context>\WEB-INF\classes\db.properties`

Danach Tomcat neu laden / neu starten.

#### Option B (nur wenn es für die Bewertung zwingend ist): MS SQL
In der Aufgabenbeschreibung steht zwar „Schema in MS SQL übernehmen“.
**Wichtig:** Unser aktuelles Backend ist technisch auf **PostgreSQL** ausgelegt (Treiber + SQL-Dialekt: `SERIAL`, `BOOLEAN`, `JSONB`, `BYTEA`, `ON CONFLICT`).

Wenn ihr wirklich MS SQL nutzen müsst, brauchen wir **Code+SQL Anpassungen** (Treiber `mssql-jdbc`, anderes Schema, evtl. Datentyp-Mapping).
→ Sag dann explizit „wir müssen MS SQL machen“, dann ziehe ich das als nächsten Schritt durch.

### Variante A: Per Tomcat „webapps“-Ordner (simpel)
1. Tomcat stoppen
2. `wissentest.war` nach `<TOMCAT>/webapps/` kopieren
3. Tomcat starten
4. App prüfen:
   - Startseite: `http://<host>:<port>/wissentest/`
   - Health: `http://<host>:<port>/wissentest/health`

Wichtig:
- Der **Dateiname der WAR bestimmt den Kontextpfad**.
  Beispiel: `wissenstest01.war` wird unter `http://<host>:<port>/wissenstest01/` erreichbar.
- Beim Austausch einer WAR immer auch den entpackten Ordner löschen:
  - `<TOMCAT>/webapps/<name>.war`
  - `<TOMCAT>/webapps/<name>/`
  - (optional, aber hilfreich) `<TOMCAT>/work/Catalina/localhost/<name>/`


### Variante B: Per Tomcat Manager (GUI)
1. Tomcat Manager öffnen:
   - `http://<host>:8080/manager/html`
2. Einloggen
3. Unter **“WAR file to deploy”** die `wissentest.war` auswählen und deployen

#### Falls der Manager-Upload fehlschlägt (wie in deinem Screenshot)

Wenn oben steht (sinngemäß):

`java.io.FileNotFoundException: C:\xampp\tomcat\webapps\C:\Users\...\wissentest.war (Zugriff verweigert)`

Dann versucht Tomcat die WAR mit dem **kompletten Windows-Pfad** als Dateiname zu speichern
(`webapps\C:\Users\...`) – das geht unter Windows nicht.

**Fix (empfohlen): Deploy ohne Upload, per Kopieren in webapps**
- Kopiere die WAR manuell nach: `C:\xampp\tomcat\webapps\wissentest.war`
- Optional: lösche vorher alte Reste: `C:\xampp\tomcat\webapps\wissentest\` und eine alte `wissentest.war`
- Tomcat neu starten (oder im Manager „Neu laden“)

**Alternative Fix: „WAR file located on server“ nutzen**
- Lege die WAR zuerst irgendwo auf dem Server ab (z.B. `C:\temp\wissentest.war`)
- Nutze im Manager die Option „WAR file located on server“ (Pfad auf dem Server eintragen)

Hinweis: Der Fehler tritt oft bei bestimmten Browsern/Umgebungen auf, weil beim Upload der volle Pfad im Dateinamen landet.


## 4) Datenbank: was muss passen?

## 4.1) Warum ist die WAR „so klein“?

Das ist normal und sogar gut:

- Eine **WAR enthält nur die Web-App** (Java-Klassen, JSPs, JS/CSS, Libraries).
- **Datenbank-Inhalte** (User, Fragen, Versuche) liegen **nicht** in der WAR.
- **Bilder** liegen bei euch **in der Datenbank** (Tabelle `question_images`, Spalte `data` als `BYTEA`) und werden zur Laufzeit über das `ImageServlet` aus der DB ausgeliefert.

Heißt: Die WAR bleibt klein, auch wenn ihr später viele Fragen/Bilder in der DB habt.

## 4.2) Datenbank inkl. Bilder auf den Server übernehmen

Wichtig: Weil Bilder als `BYTEA` in `question_images.data` gespeichert werden, sind sie **automatisch mit drin**, sobald du die DB-Daten migrierst. Du musst **keinen extra Bilder-Ordner** kopieren.

Es gibt zwei sinnvolle Wege:

### Weg A: „Frisch auf dem Server“ (Schema + Seeds)

Das ist am einfachsten, wenn ihr keine echten Inhalte migrieren müsst:

1. Auf dem Server PostgreSQL bereitstellen (oder vorhandene Instanz nutzen).
2. Datenbank `wissentest` + User (z.B. `student`) anlegen.
3. `db/schema.sql` ausführen (Tabellen erstellen).
4. Optional `db/seeds.sql` ausführen (Demo-User/Fragen).
5. Bilder später über das Admin-UI wieder hochladen.

### Weg B: „1:1 Kopie“ eurer aktuellen Datenbank (inkl. Bilder)

Das ist der richtige Weg, wenn ihr bereits Fragen und Bilder im lokalen System habt und **genau diesen Stand** auf den Server bringen wollt.

Grob-Ablauf:

1. **Dump exportieren** von eurer lokalen DB (Port ist bei euch häufig `5433` durch das Startskript).
2. Dump-Datei auf den Server kopieren.
3. **Restore importieren** in die Server-DB.

Hinweise:
- Wenn ihr den „portable PostgreSQL“ aus `startup/start_project.ps1` benutzt: die Daten liegen in `startup/db-data/`.
- Für Dump/Restore nutzt man in der Praxis `pg_dump` und `psql`/`pg_restore`.
- Danach ist die Tabelle `question_images` samt Binärdaten auf dem Server vorhanden → Bilder funktionieren direkt.

## 4.3) DB-URL in der App richtig setzen

### Wie die App die DB konfiguriert
Die DB-Zugangsdaten kommen aus **`db.properties`** (Classpath):
- Pfad im Repo: `mainlogik, backend/src/main/resources/db.properties`
- In der WAR liegt das später typischerweise unter: `WEB-INF/classes/db.properties`

Wichtiger Punkt:
- Im aktuellen Stand ist in `DbConnectionManager` der Treiber **fest** auf PostgreSQL gesetzt (`org.postgresql.Driver`).

Das bedeutet:
- **PostgreSQL → funktioniert so wie es ist** (wenn URL/User/Pass stimmen)
- **MS SQL → wird so NICHT funktionieren**, auch wenn du `db.url=jdbc:sqlserver:...` einträgst (Treiber passt nicht)


### Für PostgreSQL (Stand heute „funktioniert“)
In `db.properties` z.B.:
- `db.url=jdbc:postgresql://localhost:5433/wissentest`
- `db.user=student`
- `db.password=student`

Dann musst du auf dem Zielsystem nur sicherstellen:
- Postgres läuft
- DB `wissentest` existiert
- Schema (`db/schema.sql`) ist importiert
- (optional) Seeds (`db/seeds.sql`) importiert


### Für MS SQL (falls für die Abgabe zwingend)
Aktuell fehlt dafür noch:
1. Maven-Dependency für Microsoft JDBC Driver
2. `DbConnectionManager` muss den Treiber dynamisch wählen (oder über `db.driver`-Property lesen)
3. Euer Schema/SQL muss ggf. auf T-SQL angepasst werden

Wenn ihr wirklich auf dem DHSN-Server in **MS SQL** deployen müsst, sag kurz Bescheid – dann passe ich das sauber an (kleiner Code-Change + Test).


## 5) Tomcat-Version: wichtiger Stolperstein

Eure App nutzt **`javax.servlet`** (Servlet API 4.0.1) → das passt zu:
- Tomcat 8.5
- Tomcat 9

NICHT ohne Migration kompatibel:
- Tomcat 10/11 (nutzt `jakarta.servlet`)

**Auf dem DHSN-Server daher Tomcat 8.5 auf Port 8080 verwenden, nicht Tomcat 11 auf 8082.**


## 6) Wo du Fehler findest (Logs)

Wenn etwas nicht startet:
- Tomcat-Logs im Ordner `<TOMCAT>/logs/`
  - z.B. `catalina.*.log`

## 6.2) „Keine Logs generiert“ – fast immer: falscher Ordner / falscher Tomcat

Tomcat schreibt praktisch immer Logs. Wenn du „keine“ findest, passiert meist eins davon:

1. **Du schaust in den falschen Tomcat-Ordner** (z.B. `C:\xampp\tomcat\...` vs. `C:\tomcat\...`).
2. **Tomcat läuft als Windows-Service** und nutzt ein anderes `CATALINA_BASE`.

So findest du den *richtigen* Log-Pfad zuverlässig:

- Im Tomcat Manager auf **„Server Status“** klicken.
- Dort steht **„Catalina Base“** / **„Catalina Home“**.
- Genau in **`<Catalina Base>\logs\`** liegen die aktuellen Logs.

Welche Dateien sind typisch?
- `catalina.<datum>.log` (Hauptlog)
- `localhost.<datum>.log` (Webapps/Deploy)
- `manager.<datum>.log` (Manager-App)

Pro-Tipp: Wenn im Log Dinge wie `de.meinprojekt...` oder völlig andere App-Namen stehen, liest du sehr wahrscheinlich das Log eines *anderen* Deployments/Tomcats.

Typische Fehlerbilder:
- **404** auf `/wissentest/health` → WAR nicht deployed / falscher Context
- **500** beim ersten Aufruf → meist DB-Connection (URL/Port/User/Pass), oder Treiber fehlt

## 6.3) XAMPP: Tomcat startet nicht („catalina.pid Zugriff verweigert“)

Wenn beim Start sowas kommt wie:

`C:\xampp\tomcat\logs\catalina.pid Zugriff verweigert`

Dann ist das **kein Java-17-Problem**, sondern ein **Windows-Rechte/Lock-Problem**.

Quick-Fix (in der Reihenfolge):
1. Prüfen, ob Tomcat/Java schon läuft (Task-Manager → Prozesse: `java.exe`/Tomcat). Falls ja: beenden.
2. Datei löschen: `C:\xampp\tomcat\logs\catalina.pid` (oder den ganzen `logs`-Ordner-Inhalt nicht, nur die PID-Datei).
3. XAMPP Control Panel **als Administrator** starten (Rechtsklick → „Als Administrator ausführen“).
4. Wenn es weiterhin knallt: Ordnerrechte prüfen (Eigenschaften → Sicherheit): dein Benutzer braucht Schreibrechte auf `C:\xampp\tomcat\logs`.

Wenn Tomcat danach immer noch nicht startet: die letzten ~50 Zeilen aus `C:\xampp\tomcat\logs\catalina.<datum>.log` posten.

## 6.1) Wenn die App im Manager auftaucht, aber „konnte nicht gestartet werden“

Das bedeutet: Tomcat hat die WAR gefunden, aber beim Starten des Web-Contexts ist eine Exception passiert.
Die genaue Ursache steht immer in den Logs (siehe oben). Die häufigsten Gründe bei diesem Projekt:

1. **Datenbank nicht erreichbar / falsche Credentials**
  - Standard in `db.properties` ist `jdbc:postgresql://localhost:5433/wissentest` mit `student/student`.
  - Auf Servern ist PostgreSQL oft auf **5432** (nicht 5433) oder es existiert kein User `student`.
  - Typische Log-Meldung: `PoolInitializationException`, `Connection refused`, `FATAL: password authentication failed`.
  - Fix: DB starten + DB/User anlegen + Schema importieren + `db.properties` passend setzen.

  Wo du `db.properties` auf dem Server schnell ändern kannst:
  - Nachdem Tomcat die WAR entpackt hat: `webapps/wissentest/WEB-INF/classes/db.properties`
  - Danach Tomcat neu starten oder im Manager „Neu laden“.

2. **Falsche Java-Version für Tomcat**
  - Die App ist mit **Java 17** gebaut.
  - Wenn Tomcat mit Java 8/11 läuft, gibt es `UnsupportedClassVersionError`.
  - Fix: Tomcat muss mit Java 17 laufen (JAVA_HOME/Tomcat-Service-Config prüfen) und danach neu starten.

3. **Falsche Tomcat-Version (Jakarta vs. javax)**
  - Dieses Projekt nutzt `javax.servlet`.
  - Tomcat 10/11 erwartet `jakarta.servlet` → Start kann scheitern.
  - Fix: Tomcat 8.5/9 verwenden (oder Code-Migration auf Jakarta).


## 7) Kurz-Checkliste fürs finale Deploy

- [ ] `mvn clean package` erfolgreich
- [ ] `target/wissentest.war` existiert
- [ ] Richtigen Tomcat gewählt (8.5/9, nicht 11)
- [ ] DB läuft und ist erreichbar
- [ ] `db.properties` zeigt auf die richtige DB
- [ ] `schema.sql` importiert, optional `seeds.sql`
- [ ] Health-Check: `/wissentest/health` liefert `{"status":"ok"}`
