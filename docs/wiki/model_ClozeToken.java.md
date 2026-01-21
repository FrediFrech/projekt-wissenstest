# model/ClozeToken.java

Einfache Erklärung: Dieses Objekt steht für ein erwartetes Wort in einer Lückentextfrage.

## Zweck
Definiert erwartete Tokens für Lückentextfragen.

## Inhalt & Verantwortung
- Reihenfolge über `tokenIndex`.
- Erwartetes Wort über `expectedText`.
- Teilwertung über `partialValue`.

## Verbindungen
- Persistiert via `ClozeTokenDao`.
- Verwendet in `TestService` (Scoring) und `AdminService` (Erstellung).
