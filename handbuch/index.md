# Projekt Wissenstest

Projekt Wissenstest ist eine webbasierte Lernplattform, mit der Studierende ihr Wissen zu UML prüfen und trainieren können. Die Anwendung entstand im Modul Software Engineering an der Staatlichen Studienakademie Bautzen (DHSN). Sie wird serverseitig mit JSP gerendert, die Logik liegt in Java-Servlets, die Daten in PostgreSQL.

Dieses Handbuch beschreibt die Nutzung, die Architektur und den Betrieb der Anwendung. Die Dokumentation wird direkt aus dem Repository über GitHub Pages veröffentlicht.

## Funktionen auf einen Blick

<div class="grid cards" markdown>

-   **Tests durchführen**

    Zufällig zusammengestellte Tests nach Kategorie, Anzahl und Schwierigkeit. Fragetypen: Multiple Choice, Lückentext, Freitext und Bildfragen.

-   **Auto-Modus**

    Die Schwierigkeit passt sich an die letzten Ergebnisse an: Wer gut abschneidet, steigt auf, wer dauerhaft Probleme hat, steigt ab.

-   **Lernmodus**

    Alle freigegebenen Fragen als Karteikarten zum Umdrehen, ohne Bewertung und ohne Zeitdruck.

-   **Prüfungsmodus**

    Fest konfigurierte Prüfung mit Zeitlimit und Bestehensgrenze in Prozent oder Punkten.

-   **Admin-Panel**

    Fragen, Bilder und Benutzer verwalten, Passwort-Reset-Anfragen bearbeiten, Kennzahlen einsehen.

-   **Notenberechnung**

    Punkte werden serverseitig in Schulnoten von 1 bis 6 umgerechnet, abhängig von der Schwierigkeitsstufe.

</div>

## Wo fange ich an?

| Ich möchte … | Seite |
|---|---|
| die Anwendung als Lernende:r nutzen | [Für Lernende](nutzung/lernende.md) |
| Fragen und Benutzer verwalten | [Für Lehrende](nutzung/lehrende.md) |
| verstehen, wie das System aufgebaut ist | [Architektur-Überblick](architektur/ueberblick.md) |
| die Anwendung lokal starten | [Lokale Installation](betrieb/installation.md) |
| die Anwendung auf einem Server bereitstellen | [Deployment auf Tomcat](betrieb/deployment.md) |

## Technologie

| Bereich | Technologie |
|---|---|
| Frontend | JSP, HTML5, CSS3, Vanilla JavaScript (Fetch/AJAX) |
| Backend | Java 17, Servlet API 4.0 (`javax.servlet`), Gson |
| Datenbank | PostgreSQL 15/16, JDBC, HikariCP |
| Build | Maven, Auslieferung als WAR-Datei |
| Laufzeit | Apache Tomcat 8.5 oder 9 |
| Tests | JUnit 5, Playwright (End-to-End) |

!!! info "Demo-Zugänge für die lokale Installation"
    Die Beispieldaten (`db/seeds.sql`) legen unter anderem diese Konten an:

    | Rolle | Benutzername | Passwort |
    |---|---|---|
    | Lernende:r | `student` | `student` |
    | Admin | `lehrer` | `student` |

    Die Zugänge sind nur für lokale Tests gedacht. Auf einem öffentlich erreichbaren Server sollten die Passwörter sofort geändert werden.
