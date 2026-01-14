# Lokales Starten (Backend + Frontend)

Einfache Erklärung: Diese Anleitung zeigt Schritt für Schritt, wie du die App auf deinem Rechner startest. Sie erklärt die benötigten Programme und die Reihenfolge der Schritte.

## Kurzüberblick
Diese Anleitung erklärt Schritt für Schritt, wie du die Anwendung lokal startest – zuerst die Datenbank, dann das Java‑Backend (WAR/Tomcat) und zuletzt das React‑Frontend.

---

## Voraussetzungen (Programme & Tools)
1. **Java 17 JDK** (für Maven‑Build und Tomcat)
2. **Maven 3.8+** (zum Bauen des Backends)
3. **PostgreSQL 15** (lokale Datenbank)
4. **Node.js 18+** und **npm** (für das React‑Frontend)
5. **Tomcat 8.5 oder 11** (für die WAR‑Datei)

---

## 1) Datenbank vorbereiten (Postgres)
1. Postgres starten.
2. Datenbank `wissentest` anlegen.
3. Schema laden:
   - Öffne die Datei `db/schema.sql` und führe sie in der Datenbank aus.
4. Seeds laden:
   - Öffne die Datei `db/seeds.sql` und führe sie aus.
5. Admin‑User‑Hash setzen:
   - Ersetze in `db/seeds.sql` die Platzhalter für `password_hash` und `password_salt`.
   - Beispiel (Hash per Java oder psql + pgcrypto). Danach erneut ausführen.

---

## 2) Backend bauen (WAR)
1. In den Ordner `mainlogik, backend` wechseln.
2. Maven Build ausführen:
   - `mvn clean package`
3. Ergebnis:
   - Die WAR‑Datei liegt dann unter `mainlogik, backend/target/wissentest.war`.

---

## 3) Tomcat starten & WAR deployen
1. Tomcat starten (Port 8080 oder 8082).
2. WAR‑Datei deployen:
   - Entweder in `webapps/` kopieren oder über den Tomcat Manager hochladen.
3. Teste den Health‑Check:
   - `http://localhost:8080/wissentest/health`

---

## 4) Frontend starten (React)
1. In den Ordner `frondend` wechseln.
2. Abhängigkeiten installieren:
   - `npm install`
3. Dev‑Server starten:
   - `npm run dev`
4. Öffne im Browser:
   - `http://localhost:5173`

---

## Typische Probleme
- **DB‑Verbindung fehlgeschlagen:** Prüfe `db.properties` (URL, User, Passwort).
- **CORS‑Fehler:** Stelle sicher, dass der Backend‑Server läuft und `/api/*` erreichbar ist.
- **401 beim Test‑Submit:** Login muss vorher erfolgen (Session).

---

## Was du lokal sehen solltest
- Frontend zeigt Login/Registrierung/Test/Admin.
- Health‑Check liefert `{ "status": "ok" }`.
- Admin kann Fragen sehen und anlegen.

---

Wenn du möchtest, erstelle ich als nächsten Schritt:
- Eine genaue Setup‑Anleitung für den Uni‑Server (Tomcat + MS SQL).