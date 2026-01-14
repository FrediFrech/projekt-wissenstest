# dao/AttemptDao.java

Einfache Erklärung: Dieses Interface beschreibt, wie Testversuche gespeichert werden. Es trennt die Logik von der Datenbank.

## Zweck
Schnittstelle für Testversuche und Antworten.

## Inhalt & Verantwortung
- Speichert Versuche und dazugehörige Antworten.

## Verbindungen
- Implementiert durch `JdbcAttemptDao`.
- Genutzt von `TestService`.
