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
- Seeds werden automatisch geladen.
- Du bekommst sofort echte Daten (keine Mock‑API).

---

## Wenn du manuell starten willst
Siehe:
- [JSP_STARTUP_GUIDE.md](JSP_STARTUP_GUIDE.md)
- [POSTGRES_SETUP.md](POSTGRES_SETUP.md)
- [wiki/start_local.md](wiki/start_local.md)
