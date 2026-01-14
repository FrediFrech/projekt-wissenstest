# model/AnswerOption.java

Einfache Erklärung: Dieses Objekt ist eine Antwortmöglichkeit bei Multiple‑Choice, inklusive Teilpunkten.

## Zweck
Modelliert eine Multiple‑Choice‑Antwort mit Teilwertung.

## Inhalt & Verantwortung
- `partialValue` erlaubt Teilpunkte.

## Verbindungen
- Persistiert via `AnswerDao`.
- Genutzt in `AdminService` und `TestService`.
