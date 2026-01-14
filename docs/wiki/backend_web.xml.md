# backend/src/main/webapp/WEB-INF/web.xml

Einfache Erklärung: Diese Datei verbindet URLs mit den Java‑Servlets. Sie ist der "Router" des Backends, damit z. B. /api/auth/login beim richtigen Servlet landet.

## Zweck
Zentrale Servlet‑Konfiguration (Routing) und Filter‑Registrierung.

## Inhalt & Verantwortung
- CORS‑Filter für `/api/*`.
- Servlet‑Mapping für:
  - `/api/auth/*` → `AuthServlet`
  - `/api/admin/*` → `AdminServlet`
  - `/api/test/*` → `TestServlet`
  - `/health` → `HealthServlet`

## Verbindungen
- Verknüpft HTTP‑Routen mit den Servlet‑Klassen.
- Aktiviert `CorsFilter`, damit React‑Frontend gegen das Backend kommunizieren kann.
