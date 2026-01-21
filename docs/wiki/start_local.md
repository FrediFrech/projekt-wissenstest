# Lokales Starten (Backend + JSP Frontend)

Einfache Erklärung: Diese Anleitung zeigt Schritt für Schritt, wie du die App mit JSP Frontend auf deinem Rechner startest.

## Kurzüberblick
Diese Anleitung erklärt Schritt für Schritt, wie du die Anwendung lokal startest – zuerst die Datenbank, dann das Java‑Backend mit JSP‑Frontend (Tomcat).

---

## Voraussetzungen (Programme & Tools)
1. **Java 17 JDK** (für Maven‑Build und Tomcat)
2. **Maven 3.8+** (zum Bauen des Backends)
3. **PostgreSQL 15** (lokale Datenbank)
4. **Tomcat 8.5 oder 11** (für die WAR‑Datei mit JSP)

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

## 2) Backend mit JSP bauen (WAR)
1. In den Ordner `mainlogik, backend` wechseln.
2. Maven Build ausführen:
   - `mvn clean package`
3. Ergebnis:
   - Die WAR‑Datei liegt dann unter `mainlogik, backend/target/wissentest.war`.
   - Die WAR enthält bereits alle JSP-Dateien aus `src/main/webapp/`.

---

## 3) Tomcat starten & WAR deployen
1. Tomcat starten (Port 8080 oder 8082).
2. WAR‑Datei deployen:
   - Entweder in `webapps/` kopieren oder über den Tomcat Manager hochladen.
3. Teste den Health‑Check:
   - `http://localhost:8080/wissentest/health`

---

## 4) JSP Frontend öffnen
1. Öffne im Browser:
   - **`http://localhost:8080/wissentest/`**
2. Du solltest die Startseite (Landing Page) sehen.
3. Funktionen:
   - **Login/Registrierung** – Benutzer-Verwaltung
   - **Test-Seite** – Quiz durchführen
   - **Admin-Panel** – Fragen verwalten
   - **Lernmodus** – Flip-Cards üben

---

## Struktur der JSP-Dateien

Die JSP-Dateien befinden sich im Backend-Projekt:

```
mainlogik, backend/src/main/webapp/
├── index.jsp                    # Routing-Hauptseite
├── native.jsp                   # Navigation
└── jsp_native/                  # JSP-Komponenten
    ├── LandingPage.jsp          # Startseite
    ├── Login.jsp                # Login-Formular
    ├── Register.jsp             # Registrierungsformular
    ├── TestList.jsp             # Test-Übersicht
    ├── TestRunner.jsp           # Quiz-Durchführung
    ├── Result.jsp               # Ergebnis-Anzeige
    ├── AdminPanel.jsp           # Admin-Dashboard
    ├── LearnMode.jsp            # Lernmodus
    └── FlipCard.jsp             # Flip-Card Fragment
```

Außerdem CSS und JS:
```
src/main/webapp/
├── css/
│   ├── main.css                 # Globale Styles
│   ├── components.css           # Komponenten-Styles
│   └── animations.css           # Animationen
└── js/
    ├── app.js                   # Business Logic
    ├── apiClient.js             # REST-API Kommunikation
    └── utils.js                 # Utility-Funktionen
```

---

## Typische Probleme
- **DB‑Verbindung fehlgeschlagen:** Prüfe `db.properties` im Backend (URL, User, Passwort).
- **JSP‑Seiten werden nicht angezeigt:** Stelle sicher, dass Tomcat läuft und die WAR korrekt deployed ist.
- **API‑Fehler:** Backend muss laufen und Servlets unter `/api/*` erreichbar sein.
- **401 beim Test‑Submit:** Login muss vorher erfolgen (Session).

---

## Was du lokal sehen solltest
- ✅ JSP-Startseite unter `http://localhost:8080/wissentest/`
- ✅ Login/Registrierung/Test/Admin funktional
- ✅ Health‑Check liefert `{ "status": "ok" }`
- ✅ Admin kann Fragen sehen und anlegen
- ✅ Alle Seiten server-seitig gerendert (JSP)

---

## Schnellstart-Befehl

```bash
# Terminal 1: Backend bauen & deployen
cd "mainlogik, backend"
mvn clean package
# WAR-Datei nach Tomcat webapps/ kopieren
# Tomcat starten

# Terminal 2: Im Browser öffnen
# http://localhost:8080/wissentest/
```

---

**Hinweis:** Die alte React-Version ist archiviert unter `alte_react_version/`. Das aktuelle Projekt verwendet nur noch JSP als Frontend!