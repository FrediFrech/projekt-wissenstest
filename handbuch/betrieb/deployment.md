# Deployment auf Tomcat

Für den Betrieb auf einem Server wird die Anwendung als WAR-Datei gebaut und in einen Tomcat gelegt. Die Datenbank wird getrennt davon eingerichtet.

## Was auf den Server muss

| Datei | Zweck |
|---|---|
| `mainlogik, backend/target/wissentest.war` | die komplette Anwendung, einziges Artefakt für Tomcat |
| `db/schema.sql` | legt die Tabellen an (nur bei einer neuen Datenbank) |
| `db/seeds.sql` | optional, Demo-Konten und Beispielfragen |

Nicht auf den Server gehören `startup/` samt Werkzeugen, die Dokumentation und der Quellcode.

## WAR bauen

Das Projekt akzeptiert beim Build **nur Java 17**; mit jeder anderen Version bricht Maven ab (Maven Enforcer). Vor dem Bauen deshalb prüfen:

```bash
mvn -v
# erwartet: Java version: 17.x
```

Zeigt Maven eine andere Java-Version, hilft unter Windows das Skript `build_war_jdk17.ps1` im Hauptordner des Repositorys. Es setzt für die laufende Sitzung `JAVA_HOME` auf JDK 17, baut die WAR, prüft, dass die Klassen wirklich für Java 17 übersetzt wurden, und legt eine Kopie mit Zeitstempel im Ordner `deploy/` ab.

Ohne Skript:

```bash
cd "mainlogik, backend"
mvn clean package
```

Die Datei liegt danach unter `target/wissentest.war`.

!!! note "Zugangsdaten stecken in der WAR"
    `db.properties` wird beim Build in die WAR gepackt (`WEB-INF/classes/db.properties`). Die Datenbankverbindung muss deshalb **vor** dem Bauen auf den Zielserver eingestellt sein.

## Tomcat-Version

Die Anwendung nutzt die Servlet-API unter dem Paketnamen `javax.servlet`. Sie läuft deshalb auf:

- Tomcat 8.5
- Tomcat 9

Tomcat 10 und 11 verwenden `jakarta.servlet` und können die Anwendung ohne Umstellung des Codes nicht starten.

## Bereitstellen

=== "webapps-Ordner"

    1. `wissentest.war` in den Ordner `webapps/` des Tomcat kopieren.
    2. Tomcat entpackt die Datei automatisch und startet die Anwendung.

=== "Tomcat Manager"

    1. Den Manager unter `http://<server>:8080/manager/html` öffnen.
    2. Unter „WAR file to deploy“ die Datei hochladen.

Der Dateiname bestimmt die Adresse: `wissentest.war` ist unter `/wissentest/` erreichbar. Heißt die Datei anders, zum Beispiel `wissentest_JDK17.war`, ändert sich auch die URL.

## Datenbank auf dem Server

=== "Neu aufsetzen"

    1. PostgreSQL bereitstellen, Datenbank `wissentest` und Benutzer anlegen.
    2. `db/schema.sql` ausführen.
    3. Optional `db/seeds.sql` ausführen.
    4. Bilder bei Bedarf über das Admin-Panel neu hochladen.

=== "Bestehende Daten übernehmen"

    Bilder liegen als Binärdaten in der Tabelle `question_images`. Ein normaler Datenbank-Dump nimmt sie deshalb automatisch mit, ein eigener Bilderordner muss nicht kopiert werden.

    ```bash
    # lokal exportieren (Startskript: Port 5433)
    pg_dump -p 5433 -U student -d wissentest -Fc -f wissentest.dump

    # auf dem Server einspielen
    pg_restore -U student -d wissentest --clean --if-exists wissentest.dump
    ```

!!! info "MS SQL wird nicht unterstützt"
    `DbConnectionManager` verwendet fest den PostgreSQL-Treiber, und das Schema nutzt PostgreSQL-Typen wie `JSONB` und `BYTEA`. Für MS SQL müssten Treiber, Verbindungscode und Schema angepasst werden.

## Fehlersuche

Die Logs stehen im Ordner `logs/` des Tomcat, vor allem in `catalina.<datum>.log` und `localhost.<datum>.log`.

| Symptom | Ursache |
|---|---|
| Anwendung erscheint im Manager, startet aber nicht | falsche Tomcat-Version (10/11) oder mit falscher Java-Version gebaut |
| keine Logs vorhanden | anderer Tomcat als vermutet, falscher Installationsordner |
| Fehler beim ersten Datenbankzugriff | `db.properties` in der WAR zeigt auf die falsche Datenbank |

## Checkliste

- [ ] `mvn -v` zeigt Java 17
- [ ] `db.properties` zeigt auf die Zieldatenbank
- [ ] `mvn clean package` erfolgreich, `target/wissentest.war` vorhanden
- [ ] Tomcat 8.5 oder 9
- [ ] Datenbank erreichbar, Schema eingespielt
- [ ] `/wissentest/health` liefert `{"status":"ok"}`
- [ ] Demo-Passwörter geändert, falls der Server öffentlich erreichbar ist
