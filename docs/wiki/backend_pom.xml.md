# backend/pom.xml

Einfache Erklärung: Diese Datei sagt Maven, wie das Backend gebaut wird. Hier stehen alle Bibliotheken (z. B. Servlet‑API, JDBC, Tests) und dadurch weiß das Projekt, was es beim Build braucht.

## Zweck
Beschreibt das Maven‑Build für das Java‑Backend und erzeugt ein WAR‑Artefakt für Tomcat 9.x. Die Datei definiert Abhängigkeiten, Compiler‑Version und Build‑Plugins.

## Inhalt & Verantwortung
- **Packaging:** `war` für Tomcat‑Deployment.
- **Dependencies:**
  - `javax.servlet-api` (provided) für Servlet‑Schnittstellen.
  - `postgresql` JDBC‑Treiber für DB‑Zugriff.
  - `HikariCP` für Connection Pooling.
  - `gson` für JSON Serialisierung.
  - `junit-jupiter` für Tests.
- **Plugins:**
  - `maven-war-plugin` für WAR‑Build.
  - `maven-surefire-plugin` für JUnit‑Ausführung.

## Wichtige Entscheidungen
- Java 17 als Compiler‑Target.
- `failOnMissingWebXml=false` für moderne Servlet‑Konfigurationen.

## Verbindungen
- Baut das WAR, das **web.xml** und alle Java‑Klassen in `src/main/java` enthält.
- Tests in `src/test/java` werden über Surefire ausgeführt.
- Verwendet `db.properties` via Classpath in `DbConnectionManager`.
