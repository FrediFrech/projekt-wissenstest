# web/ServletUtils.java

Einfache Erklärung: Diese Hilfsfunktionen sparen Code, z. B. fürs Lesen von JSON‑Requests und Schreiben von Antworten.

## Zweck
Hilfsfunktionen für Request‑Body und JSON‑Antworten.

## Inhalt & Verantwortung
- Liest Request‑Body als String.
- Schreibt JSON‑Antworten inkl. Fehlerformat.

## Verbindungen
- Genutzt von `AuthServlet`, `AdminServlet`, `TestServlet`, `HealthServlet`.
