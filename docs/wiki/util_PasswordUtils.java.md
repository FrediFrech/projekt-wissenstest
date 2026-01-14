# util/PasswordUtils.java

Einfache Erklärung: Diese Datei erzeugt sichere Passwort‑Hashes und prüft sie beim Login.

## Zweck
Erzeugt Salt, hash't Passwörter mit SHA‑256 und prüft Hashes.

## Inhalt & Verantwortung
- `generateSaltHex()` erzeugt zufälligen Salt.
- `hashPassword(...)` iteriert SHA‑256 (Default 10.000 Iterationen).
- `verifyPassword(...)` vergleicht Hashes.

## Verbindungen
- `AuthService` nutzt diese Methoden bei Registrierung und Login.
- Hash/Salt werden in der `users`‑Tabelle gespeichert.
