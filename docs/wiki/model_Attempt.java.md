# model/Attempt.java

Einfache Erklärung: Dieses Objekt speichert das Ergebnis eines Tests (Punkte, Schwierigkeit, Zeitpunkt).

## Zweck
Repräsentiert einen Testversuch eines Users.

## Inhalt & Verantwortung
- Hält Punkte, max. Punkte, Schwierigkeit, Note, Dauer und Timestamp.

## Verbindungen
- Persistiert via `AttemptDao`.
- Wird von `TestService` erstellt und vom Frontend im Ergebnis genutzt.
