# Konformitäts- und Technologie-Scan

## 1. Compliance-Analyse basierend auf Systementwurf

### Anforderungen vs. Implementierung

| Anforderung (aus Systementwurf) | Status | Implementierung im Projekt |
| :--- | :--- | :--- |
| **Backend: Java Webtechnologie** | ✅ **ERFÜLLT** | Nutzung von Java 17, `javax.servlet` API, Tomcat Wart-Deployment Package (`maven-war-plugin`). |
| **Frontend: Dynamische Webseiten** | ✅ **ERFÜLLT** | JSP‑Seiten sind vorhanden (`index.jsp`, `native.jsp`, `jsp_native/*`). HTML wird serverseitig gerendert, zusätzliche Dynamik via AJAX. |
| **Datenbank: Relational (SQL)** | ✅ **ERFÜLLT** | PostgreSQL (Ver. 15), Schema (`schema.sql`) vorhanden, JDBC Zugriff. |
| **Schichtenarchitektur** | ✅ **ERFÜLLT** | Klare Trennung: `src/main/java/.../web` (Controller), `service` (Business Logic), `dao` (Data Access), `model` (Entities). |
| **Benutzerverwaltung** | ✅ **ERFÜLLT** | Tabelle `users`, Login/Register Formulare, Passwort‑Hashing (SHA‑256, iteriert) in `PasswordUtils`. |
| **Funktionalität: Wissenstest** | ✅ **ERFÜLLT** | MC-Fragen & Lückentext (`QuestionType`), Testdurchführung (`TestRunner`), Bewertung (`Attempt`). |
| **Admin-Funktionen** | ✅ **ERFÜLLT** | CRUD für Fragen (`AdminPanel`, `AdminService`), Benutzerverwaltung. |

---

## 2. Technologie-Scan

### Erlaubte Technologien (Whitelist Check)
*   **Java (JDK 17):** Im Einsatz.
*   **Servlet API:** Im Einsatz (`web.xml`, Klassen erben von `HttpServlet`).
*   **JDBC (PostgreSQL):** Im Einsatz (kein Hibernate gefunden -> **Positiv**, da oft "Low-Level" gefordert).
*   **Maven:** Build-Tool im Einsatz.
*   **JUnit 5:** Für Unit-Tests im Einsatz.
*   **HTML/CSS/JS:** Im Frontend im Einsatz.

### "Grauzonen"-Technologien (Diskussionsbedarf)
*   **AJAX/Fetch:** Wird für dynamische Inhalte genutzt (zulässig als optionale Technologie).

### Verbotene Technologien (Blacklist Check)
*   **Spring Boot / Frameworks:** *NICHT GEFUNDEN.* (Sehr gut! Wir nutzen reines Servlet API).
*   **ORM (Hibernate/JPA):** *NICHT GEFUNDEN.* (Sehr gut! Wir nutzen reines JDBC/DAOs).
*   **NoSQL:** *NICHT GEFUNDEN.* (Datenbank ist relational).

---

## 3. Backend-Logik Validierung
Der Kern der Logik liegt **vollständig in Java**:
*   **Validierung:** Findet in Services statt (`AuthService` prüft Passwort, `TestService` berechnet Punkte).
*   **Datenzugriff:** Findet in DAOs statt (SQL Queries).
*   **Steuerung:** Findet in Servlets statt (HTTP Request Handling).

Das Frontend (JSP + Vanilla JS) ist leichtgewichtig und dient primär der Darstellung/Interaktion. Die Geschäftslogik (z.B. "Ist die Antwort richtig?", "Wie viele Punkte?", "Darf User X das?") liegt im Java‑Backend.

---

## 4. Fazit
Das Projekt hält sich strikt an die typischen Vorgaben (Java, Servlets, JSP, JDBC, relationale DB) und nutzt optionale Web‑Techniken nur ergänzend.
