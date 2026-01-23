# jsp_native/ExamMode.jsp

## Einfache Erklärung
Der Prüfungsmodus ist die "ernste" Variante des Tests. Hier wählt der Nutzer Kategorien, Schwierigkeit, Anzahl Fragen, Zeitlimit **und** die Bestehensgrenze (Prozent oder Punkte).

## Zweck
Konfigurierbarer Prüfungsmodus mit festen Parametern und klarer Bestehensgrenze.

## Inhalt & Features
- **Kategorien**: Mehrfachauswahl (optional alle).
- **Schwierigkeit**: 1–3.
- **Anzahl Fragen**: 10/20/30.
- **Zeitlimit**: in Minuten.
- **Bestehensgrenze**:
  - **Prozent** (z. B. 60 %)
  - **Punkte** (z. B. 12 Punkte)

## Datenfluss
1. Nutzer wählt Optionen im Modal.
2. Konfiguration wird in `localStorage.testConfig` gespeichert.
3. `testRunner` startet mit diesen Parametern.
4. Die Ergebnis-Seite nutzt die Bestehensgrenze für die Pass/Fail-Anzeige.

## Verbindungen
- **Start:** `?page=examMode`
- **TestRunner:** `?page=testRunner`
- **API:** `GET /api/test/categories`

## Hinweise
- Die Bestehensgrenze beeinflusst nur die **Pass/Fail-Anzeige** im Ergebnis.
- Die Note (1–6) wird weiterhin serverseitig berechnet.
