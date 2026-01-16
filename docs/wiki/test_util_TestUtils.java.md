# TestUtils.java

## Beschreibung
Die Klasse `TestUtils` stellt statische Hilfsmethoden für JUnit-Tests bereit. Sie dient dazu, Testdaten dynamisch zu generieren (z.B. eindeutige Benutzernamen oder E-Mails), um Datenbank-Konflikte (Unique Constraints) bei wiederholten Testausführungen zu vermeiden.

## Package
`de.dhsn.wissentest.util` (im Test-Scope)

## Methoden

### `randomUsername()`
- **Rückgabetyp:** `String`
- **Funktion:** Generiert einen zufälligen Benutzernamen basierend auf eine gekürzten UUID.
- **Format:** `TestUser_<8-chars-hex>`
- **Verwendung:** Erstellung von Dummy-Usern in Integrationstests.

### `randomEmail()`
- **Rückgabetyp:** `String`
- **Funktion:** Generiert eine zufällige E-Mail-Adresse basierend auf `randomUsername()`.
- **Format:** `TestUser_<hash>@example.com`

### `randomInt(int min, int max)`
- **Rückgabetyp:** `int`
- **Funktion:** Liefert eine pseudozufällige Ganzzahl im Bereich `[min, max]`.

## Verwendung im Test
```java
// Beispiel in einer @Test Methode
@Test
void testRegistration() {
    String newUser = TestUtils.randomUsername();
    String newMail = TestUtils.randomEmail();
    
    // ... teste Registrierung mit diesen Daten ...
}
```
