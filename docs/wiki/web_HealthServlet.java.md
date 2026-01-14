# web/HealthServlet.java

Einfache Erklärung: Dieser kleine Endpunkt zeigt nur, ob das Backend läuft (Status "ok").

## Zweck
Einfacher Health‑Check Endpoint.

## Inhalt & Verantwortung
- Liefert `{status: "ok"}`.

## Verbindungen
- Gemappt in `web.xml` auf `/health`.
