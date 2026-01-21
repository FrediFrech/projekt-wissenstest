# frondend/src/components/TestRunner.jsx

Einfache Erklärung: Hier wird der Test gestartet, Fragen werden angezeigt und am Ende abgeschickt.

## Zweck
Startet Tests, zeigt Fragenliste und sendet Submit.

## Inhalt & Verantwortung
- `POST /api/test/start` lädt Fragen.
- `POST /api/test/submit` sendet Antworten.
- Client‑Timer (2 Minuten) und einfache Antworterfassung.

## Verbindungen
- Backend: `TestServlet` + `TestService`.
- Nutzt `apiClient.js`.
