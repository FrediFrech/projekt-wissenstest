# frondend/package.json

Einfache Erklärung: Diese Datei sagt npm, welche Frontend‑Bibliotheken gebraucht werden und wie man die App startet.

## Zweck
Definiert das React‑Frontend Build‑Setup (Vite) und Scripts.

## Inhalt & Verantwortung
- Scripts: `dev`, `build`, `preview`.
- Dependencies: `react`, `react-dom`.
- DevDependencies: `vite`, `@vitejs/plugin-react`.

## Verbindungen
- Vite nutzt `vite.config.js`.
- Build‑Output kann in das Backend‑WAR integriert werden.
