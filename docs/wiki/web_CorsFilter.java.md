# web/CorsFilter.java

Einfache Erklärung: Dieser Filter erlaubt dem Frontend, das Backend aufzurufen, auch wenn die Herkunft (Origin) abweicht.

## Zweck
Erlaubt Cross‑Origin Requests für das Web‑Frontend.

## Inhalt & Verantwortung
- Setzt Header: Origin, Methods, Headers, Credentials.
- Behandelt OPTIONS‑Preflight mit 200 OK.

## Verbindungen
- Registriert in `web.xml` für `/api/*`.
