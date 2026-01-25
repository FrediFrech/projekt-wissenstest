# Der Startup-Prozess des Projektes Wissenstest - Eine verständliche Erklärung

## Überblick: Was passiert beim Hochfahren?

Wenn Sie die Anwendung zum ersten Mal starten, geschieht hinter den Kulissen eine Menge. Das Startup-Skript automatisiert diese Prozesse für Sie, sodass Sie nicht jede Komponente einzeln konfigurieren müssen. Im Grunde lädt das System alles, was es braucht, um die Anwendung ans Laufen zu bringen.

## Die fünf Phasen des Startup-Prozesses

### Phase 1: Überprüfung und Installation der Werkzeuge

Zunächst schaut das Startup-Skript nach, ob alle notwendigen Programme bereits auf Ihrem Computer installiert sind. Das sind wie die Werkzeuge, die Sie brauchen, um das Haus zu bauen - wenn sie fehlen, können Sie nicht beginnen.

Das Skript überprüft auf Folgendes:
- **Java 17:** Die Programmiersprache, in der die Anwendung geschrieben ist
- **Maven:** Das Tool, das den Code zusammensetzt und kompiliert
- **PostgreSQL:** Die Datenbank, in der alle Informationen gespeichert werden
- **Tomcat:** Der Server, der die Anwendung im Web verfügbar macht
- **Node.js:** Ein zusätzliches Werkzeug (falls benötigt)

Sollte eines dieser Programme fehlen, lädt das Skript es automatisch herunter und installiert es in einem lokalen Ordner. Das ist der große Vorteil - Sie brauchen nichts von Hand zu installieren. Es passiert alles automatisch beim ersten Start.

### Phase 2: Vorbereitung der Datenbank

Nachdem alle Werkzeuge vorhanden sind, kümmert sich das Skript um die Datenbank. Das ist wie das Vorbereiten eines leeren Schranks, bevor Sie Ihre Sachen reinstellen.

Das Skript macht hier folgende Schritte:

**Starten der Datenbank:** PostgreSQL wird auf Port 5433 gestartet. Das ist quasi die Adresse, unter der die Datenbank erreichbar ist. Der Port 5433 wurde gewählt, um Konflikte mit anderen Datenbanken zu vermeiden, falls Sie mehrere auf dem Computer haben.

**Aufbau der Tabellenstruktur:** Das Skript lädt die Datei `schema.sql`, die beschreibt, wie die Datenbank strukturiert sein soll. Das ist wie ein Blueprint - es definiert, welche Tabellen es gibt, wie sie heißen, welche Informationen sie enthalten und wie sie miteinander verbunden sind. 

Im Projekt gibt es folgende wichtige Tabellen:
- `users` für Benutzer (Schüler, Lehrer, Admins)
- `questions` für die Testfragen
- `tests` für die Testdefinitionen
- `attempts` für jeden Testversuch, den ein Benutzer macht
- `answers` für die Antworten, die ein Benutzer gibt

**Laden von Beispieldaten:** Danach lädt das Skript die Datei `seeds.sql`, die Beispieldaten enthält. Das sind vordefinierte Benutzer und Testfragen, damit Sie sofort die Anwendung testen können, ohne alles von Hand eingeben zu müssen.

In diesem Schritt werden zum Beispiel zwei Demo-Benutzer erstellt:
- Ein Student-Account mit dem Namen "student" und Passwort "student"
- Ein Admin-Account mit dem Namen "lehrer" und Passwort "student"

Diese Daten sind verschlüsselt, nicht im Klartext gespeichert, also vollkommen sicher.

### Phase 3: Kompilierung des Backends

Jetzt wird der Code der Anwendung vorbereitet. Die Anwendung ist hauptsächlich in Java geschrieben, und Java-Code muss kompiliert werden - das heißt, er wird in eine Form übersetzt, die der Computer verstehen kann.

Hier kommt Maven ins Spiel. Maven führt mehrere Schritte automatisch aus:

**Clean:** Zuerst räumt Maven auf und löscht alte Kompilierungsergebnisse. Das ist wie, die Baustelle von gestern abzuräumen, bevor man neu anfängt.

**Compile:** Der Java-Code wird kompiliert. Maven überprüft auch automatisch, dass alle benötigten Abhängigkeiten (externe Bibliotheken) vorhanden sind. Falls nicht, lädt Maven sie herunter.

**Test:** Maven führt automatisierte Tests aus, um sicherzustellen, dass der Code funktioniert.

**Package:** Am Ende erstellt Maven eine WAR-Datei (Web Application Archive). Das ist im Grunde eine Zip-Datei, die die gesamte kompilierte Anwendung enthält - alle Java-Klassen, JSP-Seiten, CSS-Dateien, JavaScript-Dateien und Konfigurationen. Diese Datei wird unter `target/wissentest.war` gespeichert.

Wenn dieser Prozess erfolgreich ist, haben Sie eine fertige, einsatzbereite Anwendung. Wenn es Fehler gibt, werden diese angezeigt und der Prozess stoppt.

### Phase 4: Deployment (Bereitstellung)

Jetzt wird die kompilierte Anwendung zum Tomcat-Server übertragen. Das ist wie, das fertige Haus in die Straße zu stellen, in der es später stehen soll.

Das Startup-Skript kopiert die Datei `wissentest.war` in das Verzeichnis `$CATALINA_HOME/webapps/`. Das ist der spezielle Ordner, in dem Tomcat nach Anwendungen zum Bereitstellen schaut.

Tomcat erkennt automatisch, dass eine neue WAR-Datei da ist, und packt sie aus. Das nennt man "Auto-Deployment". Die Anwendung ist jetzt verfügbar, aber noch nicht laufen.

### Phase 5: Start von Tomcat und der Anwendung

Im letzten Schritt wird Tomcat selbst gestartet. Das ist der Moment, in dem das Haus "eingeschaltet" wird.

Das Skript startet Tomcat in einem separaten Fenster, sodass Sie die Logs (Meldungen) sehen können, während die Anwendung lädt. Tomcat läuft dann auf Port 8080.

Wenn Sie dann zum ersten Mal die Seite öffnen (http://localhost:8080/wissentest/), kompiliert Tomcat auch noch die JSP-Seiten. JSPs sind eine spezielle Art von Seiten, die Server-seitig zu HTML kompiliert werden müssen. Das passiert beim ersten Request - es kann also eine Sekunde länger dauern, bis die erste Seite lädt.

## Was passiert nach dem Startup?

Sobald alles hochgefahren ist, können Sie die Anwendung nutzen:

**Web-Zugriff:** Öffnen Sie Ihren Browser und gehen Sie zu http://localhost:8080/wissentest/

**Demo-Logins verfügbar:**
- **Schüler-Konto:** Benutzername "student", Passwort "student"
- **Admin-Konto:** Benutzername "lehrer", Passwort "student"

Mit diesen Accounts können Sie die gesamte Anwendung testen - als Schüler Tests durchführen oder als Admin Tests verwalten.

## Wenn etwas schiefgeht

Das Startup-Skript ist robust und gibt Ihnen hilfreiche Fehlermeldungen, falls etwas nicht stimmt. Hier sind ein paar häufige Probleme:

**PostgreSQL startet nicht:** Das kann passieren, wenn bereits eine andere Instanz auf Port 5433 läuft. Die Lösung ist, diese zu beenden oder einen anderen Port zu konfigurieren.

**Tomcat startet nicht:** Das bedeutet wahrscheinlich, dass Port 8080 bereits belegt ist. Sie können in der Konfiguration einen anderen Port einstellen.

**Maven-Build schlägt fehl:** Das passiert meistens, wenn Java nicht installiert ist oder nicht korrekt konfiguriert. Überprüfen Sie, ob `java -version` funktioniert.

**Datenbank-Fehler beim Login:** Überprüfen Sie, dass PostgreSQL läuft und die Datenbank "wissentest" existiert.

## Zusammenfassung

Der Startup-Prozess ist ein automatisiertes Orchester, das fünf Dinge nacheinander macht:

1. **Werkzeuge checken** - Sind Java, Maven, PostgreSQL und Tomcat da?
2. **Datenbank vorbereiten** - PostgreSQL starten, Tabellen erstellen, Demo-Daten laden
3. **Code kompilieren** - Maven übersetzt den Java-Code in eine WAR-Datei
4. **Deployment** - Die WAR-Datei wird zu Tomcat übertragen
5. **Alles starten** - Tomcat wird gestartet und die Anwendung ist bereit

Das ganze sollte 2-5 Minuten dauern, abhängig von Ihrem Computer. Danach können Sie die Anwendung unter http://localhost:8080/wissentest/ nutzen.

Die Schönheit dieses Systems ist, dass Sie als Benutzer nur das Startup-Skript ausführen müssen - alles andere passiert automatisch. Keine manuellen Konfigurationen, keine komplizierten Schritte. Just Works.

---

**Erstellt:** 25. Januar 2026  
**Für:** Projekt Wissenstest  
**Schwierigkeitsgrad:** Anfänger bis Fortgeschrittene
