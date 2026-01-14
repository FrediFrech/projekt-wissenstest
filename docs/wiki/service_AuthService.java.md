# service/AuthService.java

Einfache Erklärung: Diese Klasse kümmert sich um Registrierung und Login. Sie prüft Passwörter und erstellt neue Benutzer.

## Zweck
Bündelt Registrierung und Login in einer testbaren Service‑Schicht.

## Inhalt & Verantwortung
- Prüft Duplikate beim Registrieren.
- Erzeugt Salt + Hash (SHA‑256, iteriert).
- Validiert Login‑Credentials.

## Verbindungen
- Nutzt `UserDao` und `PasswordUtils`.
- Wird von `AuthServlet` aufgerufen.
