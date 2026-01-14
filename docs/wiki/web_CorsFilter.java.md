# web/CorsFilter.java

Einfache Erklärung: Dieser Filter erlaubt dem Frontend, das Backend aufzurufen, obwohl beide auf verschiedenen Ports laufen.

## Zweck
Erlaubt Cross‑Origin Requests für das React‑Frontend.

## Inhalt & Verantwortung
- Setzt Header: Origin, Methods, Headers, Credentials.
- Behandelt OPTIONS‑Preflight mit 200 OK.

## Verbindungen
- Registriert in `web.xml` für `/api/*`.
