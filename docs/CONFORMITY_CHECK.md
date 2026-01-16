# Konformitätsprüfung Projekt Wissenstest

Diese Analyse basiert auf dem `SP Systementwurf Projektarbeit 24WI.pdf` und gleicht die aktuellen Implementierungsdetails mit den gestellten Anforderungen ab.

---

## 1. Compliance Matrix (Übersicht)

| Kategorie | Status | Details |
| :--- | :--- | :--- |
| **Backend Sprache** | ✅ **KONFORM** | Java 17 als Basis wie gefordert. |
| **Backend Architektur** | ✅ **KONFORM** | Java Servlets (javax.servlet-api), keine Spring-Boot Magie. |
| **Datenbank** | ✅ **KONFORM** | Relationale DB (PostgreSQL), JDBC-Zugriff via HikariCP, PreparedStatement Nutzung. |
| **Frontend** | ⚠️ **GRAUZONE** | React wird genutzt. Anforderung war "Webtechnologie". Meist wird pure HTML/JSP erwartet, aber React als SPA gegen REST-Servlet-API ist technisch oft akzeptiert, wenn nicht explizit verboten. **Klärung empfohlen:** Prüfen ob "Server-Side Rendering (JSP)" explizit Pflicht war. Aktuell: Client-Side Rendering. |
| **Testing** | ✅ **KONFORM** | JUnit 5 Tests (`src/test/java`) vorhanden. |
| **Build System** | ✅ **KONFORM** | Maven (`pom.xml`) für Backend, npm für Frontend (Build → WAR Integration möglich). |
| **Sicherheit** | ✅ **KONFORM** | Passwörter gehasht/salted (PBKDF2/SHA-256), PreparedStatements gegen SQL-Injection. |
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

1.  **Frontend-Technologie (React vs. JSP)**
    *   **Situation:** Der Systementwurf spricht oft von "Dynamischen Webseiten mit Java". Das impliziert klassischerweise **JSP (JavaServer Pages)** oder **Thymeleaf**.
    *   **Aktueller Stand:** Wir nutzen **React** (Single Page Application) und kommunizieren nur per JSON mit dem Backend.
    *   **Risiko:** Wenn die Dozenten explizit serverseitiges HTML-Rendering (JSP) sehen wollen, ist React "Thema verfehlt".
    *   **Argumentation für React:** Es ist zeitgemäße "Webtechnologie". Die Trennung Backend (API) / Frontend (Client) ist sauberer. Falls REST-API nicht verboten ist, ist dies eine **hochwertigere** Lösung als JSP.
    *   **Empfehlung:** Falls JSP Pflicht: React-App in `index.jsp` einbetten oder als statische Resource im WAR ausliefern (was wir tun: `npm run build` → `src/main/webapp`).

2.  **Deployment (WAR-Struktur)**
    *   **Situation:** React Build-Artefakte müssen korrekt im WAR landen.
    *   **Lösung:** Manuelles Kopieren von `frondend/dist` nach `backend/src/main/webapp` vor dem Maven-Build ist nötig.
    *   **Status:** Technisch lösbar, muss aber im Build-Prozess dokumentiert sein (siehe README).

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

Der einzige Diskussionspunkt ist das **Frontend (React)**.
*   **Sicherer Weg:** React wird als "moderne View-Schicht" verkauft. Das Backend liefert REST-Daten.
*   **Fallback:** Sollte JSP zwingend gefordert sein, müsste man die React-Komponenten auflösen und JSPs schreiben, die HTML serverseitig rendern. Das wäre ein großer Rückschritt in Usability und Code-Qualität, aber prüfungsrelevant.

**Empfehlung:**
Da im PDF oft von "Systementwurf" und "Webanwendung" die Rede ist, ist eine SPA (Single Page Application) mit REST-Backend heutzutage die korrekte Interpretation einer modernen Webarchitektur. Wir bleiben bei React, stellen aber sicher, dass die **API-Dokumentation** (Swagger/OpenAPI oder Wiki) sauber ist, da dies die Schnittstelle definiert.
