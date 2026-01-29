# JUnit-Tests – ausführliche Erklärung

## Überblick
Diese Tests prüfen zentrale Logikbausteine der Anwendung im Backend. Sie laufen über Maven Surefire (JUnit 5) und liegen unter `mainlogik, backend/src/test/java/...`.

Wichtig: Die Tests verwenden **In‑Memory‑DAOs** (Test‑Doubles) statt echter Datenbankzugriffe. Dadurch bleiben sie schnell, deterministisch und isolieren die Geschäftslogik.

Getestete Bereiche:
- Authentifizierung (`AuthService`)
- Testauswahl & Bewertung (`TestService`)
- Progressionslogik (`ProgressionService`)
- Passwort-Hashing (`PasswordUtils`)
- Bild-Upload & Content-Type-Logik (`AdminServlet` Helper)

---

## Wie JUnit‑Tests funktionieren (ausführlich & studentisch)
JUnit ist das Standard‑Framework für Unit‑Tests in Java. Es prüft kleine, klare Einheiten wie Methoden oder Klassen – damit Fehler früh auffallen.

### 1) Wo JUnit Tests findet
- Alle Tests liegen in `src/test/java`.
- Maven (Plugin **Surefire**) sucht dort automatisch nach Klassen mit `@Test`.
- Es ist egal, wie die Klasse heißt – wichtig ist, dass die Methoden mit `@Test` markiert sind.

### 2) Was bei einem Testlauf passiert
1. Maven startet Surefire (`mvn test`).
2. Surefire lädt die Testklassen.
3. **Für jede @Test‑Methode** wird eine neue Instanz der Testklasse erzeugt.
4. Die Methode läuft. Wenn eine **Assertion** fehlschlägt, ist der Test rot.
5. Am Ende wird ein Bericht erzeugt (`target/surefire-reports`).

**Wichtig:** Eine @Test‑Methode ist **isoliert**. Kein Test soll von einem anderen abhängen.

### 3) Assertions (die eigentliche Prüfung)
Assertions sind die „Regeln“, die stimmen müssen:
- `assertEquals(...)` → Werte müssen gleich sein
- `assertTrue(...)` / `assertFalse(...)` → Bedingung muss stimmen
- `assertThrows(...)` → Fehler muss geworfen werden

Wenn eine Assertion fehlschlägt, ist der Test falsch – egal wie viele Zeilen vorher richtig waren.

### 4) Test‑Doubles statt echter Infrastruktur
Unsere Tests nutzen **In‑Memory‑DAOs**. Das bedeutet:
- Keine echte Datenbank
- Keine Servlet‑Container
- Keine Netzwerk‑Abhängigkeiten

Vorteile:
- Tests laufen **sehr schnell**
- Ergebnisse sind **deterministisch** (kein Zufall, kein externer Zustand)
- Fehler lassen sich leichter finden

### 5) Warum es 9 Tests sind
JUnit zählt **Test‑Methoden**, nicht Klassen.
Beispiel:
- `AuthServiceTest` hat 3 @Test‑Methoden
- `ProgressionServiceTest` hat 1 @Test‑Methode
- `TestServiceTest` hat 3 @Test‑Methoden
- `PasswordUtilsTest` hat 2 @Test‑Methoden
➡️ Summe = **9 Tests**

---

## 1) `ProgressionServiceTest`
Datei: `src/test/java/de/dhsn/wissentest/service/ProgressionServiceTest.java`

### Test: `promotionAndDemotionThresholds()`
**Ziel:** Prüft, dass die Schwellenwerte für Hoch- und Herabstufung korrekt und **inklusive** ausgewertet werden.

**Setup:**
- `ProgressionService` wird mit festen Schwellenwerten instanziiert: Promote `0.7`, Demote `0.4`, Window `3`.

**Ablauf & Assertions:**
- `shouldPromote(0.7)` → **true** (Grenzwert wird akzeptiert)
- `shouldPromote(0.9)` → **true** (oberhalb der Schwelle)
- `shouldPromote(0.69)` → **false** (knapp darunter)
- `shouldDemote(0.4)` → **true** (Grenzwert wird akzeptiert)
- `shouldDemote(0.2)` → **true** (deutlich darunter)
- `shouldDemote(0.41)` → **false** (knapp darüber)
- `getWindowSize()` → **3** (Konfiguration wird korrekt gehalten)

**Warum wichtig:**
- Absicherung der Grenzbedingungen: `>=` für Promote und `<=` für Demote.
- Verhindert spätere Logikfehler beim Auf-/Abstufen.

---

## 2) `AuthServiceTest`
Datei: `src/test/java/de/dhsn/wissentest/service/AuthServiceTest.java`

### Test: `registerCreatesUserAndHashesPassword()`
**Ziel:** Registrierung erzeugt Benutzer korrekt und speichert **keinen Klartext**, sondern Hash + Salt.

**Setup:**
- `InMemoryUserDao` als Speicher.
- `AuthService` mit diesem DAO.

**Ablauf & Assertions:**
- Aufruf `register("alice", "alice@example.com", "S3cret!pw")`.
- Prüft:
  - `id > 0` (Benutzer wurde gespeichert)
  - `passwordSalt` & `passwordHash` sind gesetzt
  - Hash ist **nicht** gleich dem Klartext-Passwort
  - Salt ist 32 Zeichen lang (16 Byte in Hex)
  - Benutzer ist im DAO gespeichert
  - `PasswordUtils.verifyPassword(...)` bestätigt den Hash

**Warum wichtig:**
- Stellt sicher, dass die Kernanforderung „Passwörter nicht im Klartext“ erfüllt ist.
- Prüft die DAO‑Interaktion (Speicherung und Rücklesen).

### Test: `loginRejectsInvalidPassword()`
**Ziel:** Login mit falschem Passwort muss blockiert werden.

**Setup:**
- Nutzer „bob“ wird mit bekanntem Hash/Salt im DAO gespeichert.

**Ablauf & Assertions:**
- `login("bob", "wrongPass")` muss eine `IllegalArgumentException` werfen.

**Warum wichtig:**
- Verhindert unberechtigte Zugriffe.
- Validiert die Passwortprüfung im Auth‑Flow.

### Test: `requestPasswordResetFlagsUser()`
**Ziel:** Passwort‑Reset markiert den Benutzer korrekt.

**Setup:**
- Nutzer „carla“ im DAO.

**Ablauf & Assertions:**
- `requestPasswordReset("carla")` setzt `resetRequested` auf **true**.

**Warum wichtig:**
- Stellt sicher, dass der Reset‑Prozess zuverlässig im Datenmodell erfasst wird.

---

## 3) `PasswordUtilsTest`
Datei: `src/test/java/de/dhsn/wissentest/util/PasswordUtilsTest.java`

### Test: `generateSaltHexProducesExpectedLengthAndDifferentValues()`
**Ziel:** Salt‑Generierung liefert gültige Hex‑Strings und ist nicht konstant.

**Ablauf & Assertions:**
- Zwei Salts werden erzeugt.
- Beide sind nicht `null`, **32 Zeichen** lang.
- Beide Salts sind **verschieden**.

**Warum wichtig:**
- Salt muss zufällig und korrekt formatiert sein, sonst leidet Sicherheit.

### Test: `hashPasswordIsDeterministicAndVerifiable()`
**Ziel:** Hashing ist deterministisch und `verifyPassword` funktioniert korrekt.

**Ablauf & Assertions:**
- Gleiche Eingabe (`Password`, `Salt`) → **gleicher Hash**.
- `verifyPassword` akzeptiert das richtige Passwort.
- `verifyPassword` lehnt ein falsches Passwort ab.

**Warum wichtig:**
- Kernfunktion für Login‑Sicherheit.

---

## 4) `TestServiceTest`
Datei: `src/test/java/de/dhsn/wissentest/service/TestServiceTest.java`

### Test: `startTestWithCategoryListFiltersByDifficultyAndCategory()`
**Ziel:** Filterlogik für Kategorienliste + Schwierigkeitsgrad funktioniert korrekt.

**Setup:**
- 4 Fragen mit gemischten Kategorien und Schwierigkeiten.
- Aufruf: `startTest(difficulty=2, limit=2, category="All", categories=["Math"])`.

**Ablauf & Assertions:**
- Ergebnisgröße = 2
- Jede Frage hat `difficulty=2` und `category="Math"`
- IDs entsprechen `{1,4}` (genau die passenden Fragen)

**Warum wichtig:**
- Validiert die Kernlogik, wie Fragen für einen Test ausgewählt werden.
- Verhindert falsche Kategorien/Schwierigkeiten im Test.

### Test: `submitAttemptMultipleChoiceCorrectScoresFullPoints()`
**Ziel:** Richtige MC‑Antwort gibt volle Punkte und korrekte Note.

**Setup:**
- MC‑Frage mit 10 Punkten.
- Antwortoptionen: eine korrekt (partialValue=1.0), eine falsch.

**Ablauf & Assertions:**
- Nutzer wählt die korrekte Option.
- `totalPoints = 10.0`, `maxPoints = 10.0`
- Note bei Difficulty 1: **"1"**
- Attempt‑Antworten wurden gespeichert (`size == 1`)

**Warum wichtig:**
- Stellt korrekte Punktevergabe, Notenberechnung und Speichern sicher.

### Test: `submitAttemptMultipleChoiceWrongScoresZero()`
**Ziel:** Falsche MC‑Antwort führt zu **0 Punkten** und schlechter Note.

**Setup:**
- MC‑Frage wie oben.
- Nutzer wählt die falsche Option.

**Ablauf & Assertions:**
- `totalPoints = 0.0`
- Note wird zu **"6"** (bei Difficulty 1)

**Warum wichtig:**
- Sicherstellt, dass falsche Antworten nicht versehentlich Punkte erhalten.

---

## 5) `AdminServletImageUtilsTest`
Datei: `src/test/java/de/dhsn/wissentest/web/AdminServletImageUtilsTest.java`

Diese Tests prüfen `ImageUploadUtils`, also die **Upload‑/Leselogik** für Bilder, die im `AdminServlet` verwendet wird.
Das Ziel: Bilddateien korrekt erkennen und den passenden MIME‑Typ bestimmen, damit Upload und späteres Ausliefern (lesen) sauber funktionieren.

### Test: `isImageFileRecognizesCommonExtensions()`
**Ziel:** Prüft, ob typische Bild‑Endungen akzeptiert werden.

**Ablauf & Assertions:**
- `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`, `.bmp`, `.svg` → **true**
- `.txt` → **false**

**Warum wichtig:**
- Upload soll nur echte Bilddateien erlauben.

### Test: `guessContentTypeFallsBackToExtension()`
**Ziel:** Prüft die Content‑Type‑Erkennung.

**Ablauf & Assertions:**
- `.png` → `image/png`
- `.svg` → `image/svg+xml`
- `.txt` → **null**

**Warum wichtig:**
- Beim Upload/Lesen wird der korrekte MIME‑Typ gebraucht (Browser zeigt Bild richtig an).

**Hinweis zur „Lesen“-Seite:**
Das eigentliche Ausliefern der Bilddaten passiert im `ImageServlet` (DB‑Zugriff). Ein echter End‑to‑End‑Test würde dafür eine Test‑DB benötigen.
Mit dem Unit‑Test decken wir trotzdem den kritischen Teil ab: **richtige Erkennung und Content‑Type**.

---

## Ausführung der Tests
Voraussetzungen:
- JDK 17
- Maven

Befehl (im Ordner `mainlogik, backend`):
- `mvn test`

---

## Fazit
Die Tests decken die wichtigsten Logik‑Pfadentscheidungen ab: Authentifizierung, sichere Passwortverarbeitung, Progressionsregeln sowie Testauswahl und Scoring. Dadurch werden zentrale Anforderungen der Anwendung zuverlässig abgesichert.