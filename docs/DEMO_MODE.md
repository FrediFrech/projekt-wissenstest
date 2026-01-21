# 🎬 Demo‑Guide (Schnellstart)

**Wichtig:** Ein echter DB‑freier Demo‑Modus ist **nicht implementiert**. Für eine schnelle Demo wird die DB automatisch per Skript gestartet.

---

## ✅ Schnellstart (empfohlen)
1. `startup/start_project.ps1` ausführen.
2. Warten bis Tomcat läuft.
3. Öffnen: `http://localhost:8080/wissentest/`

**Login‑Daten:**
- `student` / `student`
- `lehrer` / `student`

---

## Warum ist das trotzdem „Demo‑tauglich“?
- Das Skript startet eine **portable PostgreSQL** (Port 5433).
- Seeds werden automatisch geladen. Wenn PostgreSQL bereits läuft, erkennt `start_project.ps1` das und **wendet die Seed‑Updates non‑destructively an** (die `db/seeds.sql` wird erneut ausgeführt, ohne vorhandene Daten zu löschen).
- Die `db/seeds.sql`-Datei wurde idempotent gestaltet (z. B. mit `ON CONFLICT` und `WHERE NOT EXISTS`), sodass erneutes Ausführen keine Duplikate erzeugt — ideal zum Einpflegen neuer Beispiel‑Daten.
- Du bekommst sofort echte Daten (keine Mock‑API).

Hinweis: Manuelles Nachladen der Seeds ist jederzeit möglich:
```bash
psql -p 5433 -U student -d wissentest -f db/seeds.sql
```

---

## Wenn du manuell starten willst
Siehe:
- [JSP_STARTUP_GUIDE.md](JSP_STARTUP_GUIDE.md)
- [POSTGRES_SETUP.md](POSTGRES_SETUP.md)
- [wiki/start_local.md](wiki/start_local.md)

---

VALIDIERUNG: Diese Seite und das Start‑Skript wurden aktualisiert, damit Seed‑Änderungen sicher eingespielt werden können, auch wenn PostgreSQL bereits läuft. Bestätigt durch: manuelles Ausführen von `psql -p 5433 -U student -d wissentest -f db/seeds.sql`, Startskriptlauf und Sichtprüfung im Lernmodus (neue Seed‑Frage sichtbar).
