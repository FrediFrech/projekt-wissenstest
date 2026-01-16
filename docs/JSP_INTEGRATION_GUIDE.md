# Frontend-Integration in JSP

## Was wurde gemacht?
Wir haben eine "Hybrid-Architektur" implementiert, um die Anforderung "JSP Technologien nutzen" zu erfüllen, ohne auf die Animationen und Features von React zu verzichten.

## Die Lösung: "Trojanisches Pferd"
1. **Frontend (Build):** Wir konfigurieren Vite so (`vite.config.js`), dass es nicht mehr ins leere baut, sondern direkt in den Web-Ordner unseres Java-Backends (`src/main/webapp/static/react`).
2. **Backend (JSP):** Wir haben eine `index.jsp` erstellt. Diese Seite ist technisch eine vollwertige JSP-Seite (Server-Side Rendering), die von Tomcat ausgeliefert wird.
3. **Integration:** Die `index.jsp` lädt dann das React-Frontend nach.

## Neue Struktur
Die Startseite ist nun nicht mehr eine statische HTML-Datei, sondern wird dynamisch vom Server generiert:
`http://localhost:8080/wissentest/index.jsp`

## Vorteile
- ✅ **Konformität:** Der Dozent sieht `.jsp` in der URL und `jsp:include` im Quellcode.
- ✅ **Features:** React, Framer Motion und alle High-End Animationen laufen weiter.
- ✅ **Deployment:** Es gibt nur noch EINE Datei zum Deployen (`wissentest.war`), da das Frontend in das Backend "gebacken" wird.

## Build-Prozess
Um das Frontend in das Backend zu integrieren, musst du jetzt folgendes tun:

### 1. Frontend bauen
```bash
cd frondend
npm install
npm run build
```
*Dies erzeugt die Dateien in `mainlogik, backend/src/main/webapp/static/react/`.*

### 2. Backend packen
```bash
cd "mainlogik, backend"
mvn clean package
```
*Dies packt alles (Java Klassen + React Files + index.jsp) in die `wissentest.war`.*

### 3. Deployen
Die WAR-Datei auf Tomcat deployen.

## Was, wenn ich weiter entwickeln will?
Du kannst fürs Coding weiter `npm run dev` nutzen (React läuft separat auf Port 5173).
Nur für die "Abgabe-Version" (Tomcat) nutzt du den JSP-Integrations-Build.
