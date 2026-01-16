# Testing Guide mit JUnit 5

## 1. Einführung
Laut Anforderungskatalog ist mindestens **ein automatisierter, funktionaler Test** erforderlich. Wir nutzen **JUnit 5 (Jupiter)** für unsere Tests.

Tests befinden sich im Ordner: `mainlogik, backend/src/test/java/`.

## 2. Test-Strategie
Da wir keine komplexen Frameworks wie Spring nutzen, müssen wir unsere Testumgebung selbst verwalten. Wir unterscheiden zwei Arten von Tests:

### A. Unit Tests (Logik-Tests)
Testen einzelne Klassen/Methoden **ohne Datenbank**.
*   **Beispiel:** Testen der `ResultService` Berechnung.
*   **Vorteil:** Schnell, keine Abhängigkeiten.
*   **Wann nutzen?** Für reine Logik, z.B. Punkterechnung.

### B. Integration Tests (Funktionale Tests)
Testen das Zusammenspiel mit der **echten Datenbank**.
*   **Beispiel:** User registrieren -> Login prüfen -> Löschen.
*   **Voraussetzung:** Die Postgres-Datenbank muss laufen!
*   **Wichtig:** Testdaten müssen nach dem Test bereinigt werden, damit der nächste Test nicht fehlschlägt.

---

## 3. Hilfsmittel für einfaches Testen

Wir haben zwei Hilfsklassen erstellt, um euch das Leben leichter zu machen:

1.  **`TestBase`**: Eine Basisklasse, von der eure Tests erben können. Sie kümmert sich um:
    *   Verbindung zur Datenbank.
    *   Starten/Stoppen von Transaktionen (Auto-Rollback wäre ideal, ist aber mit reinem JDBC schwerer, daher setzen wir auf Clean-Up-Methoden).
2.  **`TestUtils`**: Statische Methoden zum Generieren von Zufallsdaten.

---

## 4. Schritt-für-Schritt: Einen neuen Test schreiben

### Beispiel: Teste, ob ein neuer User angelegt werden kann

**Schritt 1:** Erstelle eine neue Klasse in `src/test/java/de/dhsn/wissentest/feature/`.
**Schritt 2:** Erbe von `TestBase` (optional, oder nutze einfach DAOs direkt).
**Schritt 3:** Schreibe den Test mit `@Test`.

```java
package de.dhsn.wissentest.feature;

import de.dhsn.wissentest.dao.UserDao;
import de.dhsn.wissentest.model.User;
import de.dhsn.wissentest.util.TestUtils;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;

public class UserRegistrationTest {

    private final UserDao userDao = new UserDao();
    private String createdUsername;

    @Test
    public void testUserCanRegisterAndLogin() throws SQLException {
        // 1. Arrange (Vorbereiten)
        String username = TestUtils.randomUsername();
        String password = "testPassword123";
        
        // 2. Act (Ausführen)
        boolean success = userDao.registerUser(username, password, "student");
        this.createdUsername = username; // Merken für Cleanup

        // 3. Assert (Prüfen)
        Assertions.assertTrue(success, "User sollte erfolgreich registriert werden");
        
        // Prüfen ob Login geht
        User user = userDao.login(username, password);
        Assertions.assertNotNull(user, "Login sollte User-Objekt zurückgeben");
        Assertions.assertEquals("student", user.getRole(), "Rolle sollte korrekt sein");
    }

    @AfterEach
    public void cleanup() throws SQLException {
        // Aufräumen nach jedem Test!
        if (createdUsername != null) {
            userDao.deleteUserByUsername(createdUsername);
        }
    }
}
```

---

## 5. JUnit 5 Assertions Cheatsheet

| Methode | Bedeutung |
| :--- | :--- |
| `assertEquals(expected, actual)` | Prüft ob zwei Werte gleich sind. |
| `assertTrue(condition)` | Prüft ob Bedingung wahr ist. |
| `assertNotNull(object)` | Prüft ob Objekt existiert (nicht null ist). |
| `assertThrows(Class, () -> ...)` | Prüft ob eine bestimmte Exception fliegt. |

## 6. Tests ausführen
**Via Terminal:**
```bash
cd "mainlogik, backend"
mvn test
```

**Via VS Code:**
Öffne die Test-Datei und klicke auf den kleinen "Play"-Button neben der Klassendefinition oder Methode.
