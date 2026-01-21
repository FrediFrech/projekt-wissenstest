# Konformitätsprüfung Projekt Wissenstest

Diese Analyse basiert auf dem `SP Systementwurf Projektarbeit 24WI.pdf` und gleicht die aktuellen Implementierungsdetails mit den gestellten Anforderungen ab.

---

## 1. Compliance Matrix (Übersicht)

| Kategorie | Status | Details |
| :--- | :--- | :--- |
| **Backend Sprache** | ✅ **KONFORM** | Java 17 als Basis wie gefordert. |
| **Backend Architektur** | ✅ **KONFORM** | Java Servlets (javax.servlet-api), keine Spring-Boot Magie. |
| **Datenbank** | ✅ **KONFORM** | Relationale DB (PostgreSQL), JDBC-Zugriff via HikariCP, PreparedStatement Nutzung. |
| **Frontend** | ✅ **KONFORM** | JSP‑Seiten vorhanden (`index.jsp`, `native.jsp`, `jsp_native/*`). Server‑Side Rendering erfüllt die Vorgabe. |
| **Testing** | ✅ **KONFORM** | JUnit 5 Tests vorhanden (`src/test/java`). |
| **Build System** | ✅ **KONFORM** | Maven (`pom.xml`) für Backend/WAR. Frontend ist Teil des Webapp‑Ordners (kein separates React‑Build). |
| **Sicherheit** | ✅ **KONFORM** | Passwörter gehasht/salted (iteriertes SHA‑256), PreparedStatements gegen SQL‑Injection. |
| **Schichtenarchitektur** | ✅ **KONFORM** | Klare Trennung: `dao` (DB), `service` (Logik), `web` (HTTP/Servlet), `model` (Daten). |

---

## 2. Detaillierte Prüfung

### ✅ Konform (Vollständig erfüllt)

1.  **Java Standard & Version**
    *   **Anforderung:** Java 17, Standard-Bibliotheken.
    *   **Implementierung:** `pom.xml` definiert `<maven.compiler.source>17</maven.compiler.source>`. Nutzung von `java.util.*`, `java.sql.*`.

2.  **Servlet API**
    *   **Anforderung:** Nutzung von Java EE / Jakarta EE Servlets.
    *   **Implementierung:** `TestServlet extends HttpServlet`, `doGet`, `doPost` Methoden überschrieben. `web.xml` Mapping vorhanden.

3.  **Datenbankzugriff (DAO Pattern)**
    *   **Anforderung:** Kapselung der Datenbankzugriffe.
    *   **Implementierung:** Klassen wie `QuestionDao`, `UserDao` kapseln SQL. Keine SQL-Strings in Servlets/Services.

4.  **Verbindungspooling**
    *   **Anforderung:** Effiziente Ressourcenverwaltung.
    *   **Implementierung:** HikariCP (`HikariDataSource`) in `DbConnectionManager` implementiert.

5.  **Passwort-Sicherheit**
    *   **Anforderung:** Keine Klartext-Passwörter.
    *   **Implementierung:** `PasswordUtils` nutzt Hashing mit Salt.

6.  **Admin-Funktionalität**
    *   **Anforderung:** CRUD für Fragen.
    *   **Implementierung:** `AdminServlet` und `AdminPanel` erlauben Erstellen/Bearbeiten von Fragen.

### ⚠️ Grauzonen (Prüfung empfohlen)

1.  **Deployment (WAR-Struktur)**
    *   **Situation:** JSPs + statische Assets liegen direkt in `src/main/webapp`.
    *   **Status:** Maven baut ein WAR, Tomcat deployt ohne zusätzliche Build‑Schritte.

### ❌ Nicht Konform (Handlungsbedarf)

*   *Aktuell keine kritischen Verstöße identifiziert, unter der Annahme, dass eine REST-Architektur akzeptiert wird.*

---

## 3. Technische Constraints & Limits

### Scope Limits (Was wir NICHT tun)
*   Kein Spring Boot (Verboten laut Standard-Java-Web-Aufgaben, hier eingehalten: Nur reines Servlet-API).
*   Kein Hibernate/JPA (Verboten/Vermisst: Wir nutzen reines JDBC `java.sql`, was für Lernzwecke oft gefordert ist → **Konform**).
*   Keine Fremd-APIs für Core-Logik (Alles selbst implementiert).

### Externe Bibliotheken (Geprüft)
*   `org.postgresql:postgresql`: ✅ Notwendig für DB.
*   `com.zaxxer:HikariCP`: ✅ Standard für Pooling (Industriestandard).
*   `com.google.code.gson:gson`: ✅ Erlaubt für JSON-Parsing (Standard).
*   `org.junit.jupiter:junit-jupiter`: ✅ Standard für Tests.

---

## 4. Fazit & Empfehlung

Das Projekt ist **technisch sehr solide** und hält sich strikt an die **Java-Backend-Vorgaben** (Servlets, JDBC, Schichtenarchitektur).

Es gibt **keinen Frontend‑Diskussionspunkt**, da JSP aktiv genutzt wird.

**Empfehlung:**
Für die Abgabe reicht es, die JSP‑Startseite und die Servlet‑Routen zu zeigen. Die optionale REST/JSON‑Nutzung ist erlaubt.
