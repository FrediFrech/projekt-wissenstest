# frondend/src/services/apiClient.js

Einfache Erklärung: Kleine Hilfsfunktionen, damit Komponenten einfacher mit dem Backend sprechen können.

## Zweck
Minimale Fetch‑Wrapper für GET/POST.

## Inhalt & Verantwortung
- `apiGet`, `apiPost`, `apiPut`, `apiDelete` mit JSON‑Handling und Fehlerbehandlung.

## Verbindungen
- Wird von UI‑Komponenten genutzt.
- Kommuniziert mit Servlet‑APIs unter `/api`.
