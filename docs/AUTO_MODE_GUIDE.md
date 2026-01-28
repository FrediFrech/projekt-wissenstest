# Auto-Modus und Progression Logik Dokumentation

Diese Dokumentation beschreibt die Funktionsweise, Architektur und Konfiguration des **Auto-Modus** (Adaptive Difficulty) im Wissenstest-Projekt.

## Übersicht

Der Auto-Modus analysiert die Leistung eines Nutzers basierend auf seinen letzten Testergebnissen und passt den Schwierigkeitsgrad für den nächsten Test automatisch an. Ziel ist es, den Nutzer im optimalen Lernbereich zu halten („Flow“), indem Unter- oder Überforderung vermieden wird.

## Architektur

Die Implementierung folgt dem klassischen Schichtenmodell der Anwendung (MVC-ähnlich).

### Komponenten

1.  **Frontend (`app_main.js`, `TestList.jsp`, `Result.jsp`)**:
    *   Bietet "Auto" als Auswahloption an.
    *   Zeigt die empfohlene Schwierigkeit auf dem Dashboard und der Ergebnisseite an.
    *   Kommuniziert mit dem Backend via REST-ähnlichen Endpoints (`/test/recommend`, `/start`).

2.  **Backend Controller (`TestServlet`)**:
    *   Verarbeitet API-Anfragen.
    *   Delegiert die Schwierigkeitsberechnung an den `TestService`.
    *   Erzwingt eine aktive Session für den Auto-Modus.

3.  **Business Logic (`TestService`, `ProgressionService`)**:
    *   `TestService`: Orchestriert den Datenabruf und die Testgenerierung.
    *   `ProgressionService`: Kapselt die mathematische Logik für Auf- und Abstufung (Promote/Demote).

4.  **Data Access (`AttemptDao`, `ConfigDao`)**:
    *   `AttemptDao`: Lädt die Historie des Nutzers (z.B. die letzten 3 Versuche).
    *   `ConfigDao`: Lädt dynamische Schwellenwerte aus der Datenbanktabelle `config`.

### Architektur-Diagramm

```text
      [Benutzer]
           |
     (Wählt Auto-Modus)
           |
           v
   [Frontend (JSP/JS)]
           |
   (POST /start autoMode=true)
   (GET /test/recommend)
           |
           v
     [TestServlet]
           |
 (resolveAutoDifficulty)
           |
           v
      [TestService] <------------> [ProgressionService]
       /         \                  (Berechnungslogik)
      /           \
 [ConfigDao]   [AttemptDao]
      \           /
       \         /
        \       /
       [PostgreSQL]
```

## Logik und Algorithmus

Die Anpassung des Schwierigkeitsgrades basiert auf zwei Faktoren: der Leistung im **letzten Versuch** (für schnellen Aufstieg) und der durchschnittlichen Leistung der **letzten N Versuche** (für stabilen Abstieg).

### 1. Datenbasis
Das System lädt die letzten `N` Versuche des Nutzers.
*   Standard: `N = 3` (konfigurierbar via `progress.window_size`).
*   Sortierung: Neueste zuerst.

### 2. Berechnung
Der Algorithmus prüft zwei Bedingungen in folgender Reihenfolge:

1.  **Aufstieg (Promotion)**:
    *   Bedingung: Hat der Nutzer im **allerletzten Versuch** außergewöhnlich gut abgeschnitten?
    *   Logik: `Letzter_Score_Ratio > Promote_Threshold` (Standard: > 70%)
    *   Aktion: Schwierigkeit wird um **+1** erhöht.

2.  **Abstieg (Demotion)**:
    *   Bedingung: Nur wenn *kein* Aufstieg stattgefunden hat. Ist der Nutzer über die **letzten N Versuche** durchschnittlich zu schlecht?
    *   Logik: `Durchschnitt_Score_Ratio < Demote_Threshold` (Standard: < 40%)
    *   Aktion: Schwierigkeit wird um **-1** verringert.

3.  **Stagnation (Keep)**:
    *   Wenn keine der obigen Bedingungen zutrifft, bleibt die Schwierigkeit gleich der des letzten Versuchs.

### 3. Grenzwerte (Clamping)
Der berechnete Schwierigkeitsgrad wird auf den Bereich [1, 3] begrenzt.
*   1 = Leicht
*   2 = Mittel
*   3 = Schwer

### 4. Sonderfall: Keine Historie
Hat der Nutzer noch keine Tests absolviert, wählt das System einen **zufälligen Schwierigkeitsgrad** zwischen 1 und 3, um initiale Daten zu sammeln.

### Flussdiagramm

```text
(Start Auto-Modus)
      |
      v
[Lade letzte N=3 Versuche]
      |
      v
<Versuche vorhanden?> -- Nein --> [Wähle Zufall (1-3)] ----------------------+
      |                                                                      |
     Ja                                                                      |
      |                                                                      |
      v                                                                      |
[Analysiere Historie]                                                        |
      |                                                                      |
      v                                                                      |
[Basis = Schwierigkeit des letzten Versuchs]                                 |
      |                                                                      |
      v                                                                      |
<Letzter Score > 70%?> -- Ja --> [Schwierigkeit + 1] --+                     |
      |                                                |                     |
     Nein                                              |                     |
      |                                                v                     v
      v                                          [Begrenze auf 1-3] --> (Test generieren)
<Durchschnitt (N=3) < 40%?> -- Ja --> [Schwierigkeit - 1] --^
      |                                                |
     Nein                                              |
      |                                                |
      v                                                |
[Schwierigkeit beibehalten] ---------------------------+
```

## Konfiguration

Die Schwellenwerte können in der Datenbanktabelle `config` angepasst werden, ohne den Code neu zu kompilieren. Werden keine Werte gefunden, greift das System auf Hardcoded-Defaults zurück.

| Config Key | Beschreibung | Standard (Fallback) | SQL Typ |
| :--- | :--- | :--- | :--- |
| `progress.promote_threshold` | Schwellenwert für Aufstieg (0.0 - 1.0) | `0.70` (70%) | TEXT (parseable as double) |
| `progress.demote_threshold` | Schwellenwert für Abstieg (0.0 - 1.0) | `0.40` (40%) | TEXT (parseable as double) |
| `progress.window_size` | Anzahl der berücksichtigten letzten Versuche | `3` | TEXT (parseable as int) |

### SQL zum Anpassen der Werte

```sql
-- Beispiel: Strengere Aufstiegsregeln (erst ab 85%)
INSERT INTO config (key, value) VALUES ('progress.promote_threshold', '0.85')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- Beispiel: Schnellerer Abstieg (schon unter 50%)
INSERT INTO config (key, value) VALUES ('progress.demote_threshold', '0.50')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- Beispiel: Längeres "Gedächtnis" (letzte 5 Tests)
INSERT INTO config (key, value) VALUES ('progress.window_size', '5')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;
```

## Erweiterungsmöglichkeiten

Das System ist modular aufgebaut und kann erweitert werden:

*   **Elo-Rating**: Statt starrer Stufen könnte ein Elo-Rating für Nutzer und Fragen eingeführt werden.
*   **Kategorie-spezifisch**: Die Progression könnte pro Kategorie (z.B. "Datenbanken" vs. "Programmierung") getrennt gespeichert werden.
*   **Benutzer-Präferenz**: Speichern der explizit gewählten Schwierigkeit als "Wunsch-Niveau" in der `users` Tabelle.
