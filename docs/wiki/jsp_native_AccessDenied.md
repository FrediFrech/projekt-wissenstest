# jsp_native/AccessDenied.jsp

Einfache Erklärung: Diese Seite wird angezeigt, wenn ein Benutzer versucht, auf einen Bereich zuzugreifen, für den er keine Berechtigung hat (z.B. Admin-Panel ohne Admin-Rolle).

## Zweck
Fehlerseite für HTTP 403 (Forbidden) Situationen. Informiert den Benutzer freundlich über fehlende Berechtigungen.

## Wann wird sie angezeigt?
- Student versucht, auf `/admin/*` Endpunkte zuzugreifen.
- Session abgelaufen und geschützter Bereich wird aufgerufen.
- Manipulation von URLs zu geschützten Ressourcen.

## Inhalt
- Fehlermeldung: "Zugriff verweigert"
- Erklärung: Warum der Zugriff nicht möglich ist.
- Navigation: Link zurück zur Startseite oder Login.

## Verbindungen
- Aufgerufen von `native.jsp` wenn Rollenprüfung fehlschlägt.
- Kann auch als `error-page` in `web.xml` konfiguriert werden.

## Typische Darstellung
```
🚫 Zugriff verweigert

Sie haben keine Berechtigung, diese Seite anzuzeigen.
Bitte melden Sie sich mit einem Admin-Konto an.

[Zurück zur Startseite]  [Zum Login]
```
