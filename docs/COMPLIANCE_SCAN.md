# Konformitäts- und Technologie-Scan

## 1. Compliance-Analyse basierend auf Systementwurf

### Anforderungen vs. Implementierung

| Anforderung (aus Systementwurf) | Status | Implementierung im Projekt |
| :--- | :--- | :--- |
| **Backend: Java Webtechnologie** | ✅ **ERFÜLLT** | Nutzung von Java 17, `javax.servlet` API, Tomcat Wart-Deployment Package (`maven-war-plugin`). |
| **Frontend: Dynamische Webseiten** | ⚠️ **GRAUZONE** | Gefordert sind oft JSPs oder Ähnliches. Wir nutzen **React** (SPA). Das ist eine moderne Interpretation ("Webtechnologie"), könnte aber von strengen Dozenten als Abweichung gesehen werden. *Empfehlung: Argumentation vorbereiten (saubere API-Trennung).* |
| **Datenbank: Relational (SQL)** | ✅ **ERFÜLLT** | PostgreSQL (Ver. 15), Schema (`schema.sql`) vorhanden, JDBC Zugriff. |
| **Schichtenarchitektur** | ✅ **ERFÜLLT** | Klare Trennung: `src/main/java/.../web` (Controller), `service` (Business Logic), `dao` (Data Access), `model` (Entities). |
| **Benutzerverwaltung** | ✅ **ERFÜLLT** | Tabelle `users`, Login/Register Formulare, Passwort-Hashing (PBKDF2 in `PasswordUtils`). |
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
*   **React + Vite:** Diese sind nicht explizit "verboten", aber der Entwurf spricht meist von "Java Webtechnologie" für die *Erzeugung* der Seiten.
    *   *Risiko:* Gering bis Mittel (abhängig vom Dozenten).
    *   *Mitigation:* Das Backend liefert keine statischen HTML-Seiten, sondern Daten (JSON). Das ist eine validere Architektur als JSPs.

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

Das Frontend (React) ist "dumm" und dient nur zur Darstellung und Benutzereingabe. Die Geschäftslogik (z.B. "Ist die Antwort richtig?", "Wie viele Punkte?", "Darf User X das?") liegt sicher im Java-Backend.

---

## 4. Fazit
Das Projekt hält sich strikt an die typischen Vorgaben für ein "Softwareprojekt"-Modul (Java, Servlets, JDBC, Relationele DB). Die Modernisierung durch React im Frontend ist eine architekturelle Verbesserung, die aber als solche dokumentiert werden muss.
