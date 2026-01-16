# JSP Native Frontend - Komponenten-Übersicht

Diese Dokumentation beschreibt alle Komponenten der **JSP-Native Variante** – die sichere, vollständig JSP-konforme Alternative zur React-Version.

---

## 📋 Komponenten-Verzeichnis

| Komponente | Typ | Beschreibung | Wiki-Link |
|-----------|-----|-------------|-----------|
| **native.jsp** | Router | Haupt-Einstiegspunkt, JSP-basiertes Routing | [native.jsp](native_jsp.md) |
| **LandingPage.jsp** | Page | Startseite mit Willkommen & Navigation | [LandingPage.jsp](jsp_native_LandingPage.md) |
| **Login.jsp** | Form | Authentifizierung (Benutzer einloggen) | [Login.jsp](jsp_native_Login.md) |
| **Register.jsp** | Form | Benutzer-Registrierung | [Register.jsp](jsp_native_Register.md) |
| **TestList.jsp** | Page | Dashboard: Übersicht aller Tests | [TestList.jsp](jsp_native_TestList.md) |
| **TestRunner.jsp** | Page | Quiz-Interface: Fragen + Antworten | [TestRunner.jsp](jsp_native_TestRunner.md) |
| **Result.jsp** | Page | Ergebnisanzeige nach Test | [Result.jsp](jsp_native_Result.md) |
| **AdminPanel.jsp** | Page | Admin-Dashboard: Statistiken & Frage-Management | [AdminPanel.jsp](jsp_native_AdminPanel.md) |
| **LearnMode.jsp** | Page | Lernmodus mit Flip-Cards | [LearnMode.jsp](jsp_native_LearnMode.md) |
| **FlipCard.jsp** | Fragment | Wiederverwendbare Karteikarten-Komponente | [FlipCard.jsp](jsp_native_FlipCard.md) |

---

## 🔧 JavaScript & CSS

| Datei | Zweck | Wiki-Link |
|------|-------|-----------|
| **js_native/app.js** | Business-Logic: Auth, Tests, AJAX-Calls | [app.js](jsp_native_app.md) |
| **css_native/style.css** | Global Styling: Glasmorphism, Animations, Layout | [style.css](css_native.md) |

---

## 🏗️ Architektur-Übersicht

```
native.jsp (Main Router)
│
├─ Router Logic: Page-Parameter (?page=...)
│
├─ Includes JSP Pages:
│  ├─ LandingPage.jsp
│  ├─ Login.jsp  
│  ├─ Register.jsp
│  ├─ TestList.jsp
│  ├─ TestRunner.jsp
│  ├─ Result.jsp
│  ├─ AdminPanel.jsp
│  ├─ LearnMode.jsp
│  └─ FlipCard.jsp
│
└─ Loads JavaScript & CSS:
   ├─ js_native/app.js (Business Logic)
   └─ css_native/style.css (Styling)

Backend (Java Servlets)
│
├─ /api/auth/login → AuthServlet
├─ /api/auth/register → AuthServlet
├─ /api/test/start → TestServlet
├─ /api/test/list → TestServlet
├─ /api/admin/* → AdminServlet
└─ /health → HealthServlet
```

---

## 🚀 Navigation Flow

```
Landing Page
├─ "Jetzt Starten" → Login
│  └─ Erfolg → TestList
│
└─ "Registrieren" → Register
   └─ Erfolg → Login
      └─ Erfolg → TestList

TestList
├─ "Test Starten" → TestRunner
│  └─ "Test Abschließen" → Result
│     └─ "Zurück" → TestList
│
└─ "Lernen" → LearnMode
   └─ Back → TestList

Navigation Bar
├─ TestList
├─ LearnMode
├─ Admin Panel (nur für Admins)
└─ Logout → Landing
```

---

## 🔐 Sicherheit

### Session-Handling
- **Server-Side Sessions** in JSP (nicht localStorage)
- Session-Check vor Admin-Seiten
- Passwort-Hashing im Backend (PBKDF2/SHA-256)

### AJAX-Security
- CORS-Filter im Backend erlaubt Cross-Origin Requests
- POST für sensitive Daten (nicht GET)
- JSON-Payload statt Query-Strings

### Input-Validierung
- Client-Side: HTML5 Input-Types, Regex
- Server-Side: Backend validiert alle Eingaben

---

## 📱 Responsive Design

Alle Komponenten sind **Mobile-First** designt:
- CSS Grid/Flexbox für responsive Layouts
- Meta-Viewport in `native.jsp`
- Breakpoints für Tablet & Desktop

---

## ✨ Features & Highlights

### 🎨 Design
- **Glasmorphism:** Durchscheinende Cards mit Blur-Effekt
- **Gradients:** Farbübergänge (Blau → Lila)
- **Animationen:** CSS3 Transitions & Keyframes (keine JS-Libraries)
- **Icons:** Emojis für Schnelligkeit

### ⚡ Performance
- **Vanilla JS:** Minimal Overhead (keine Framework-Größe)
- **CSS3 Native:** Hardwarebeschleunigung
- **AJAX:** Nur Daten-Transfer, keine Page-Reloads
- **sessionStorage:** Lokale State-Verwaltung

### 🔄 Interaktivität
- **3D-Flip-Cards:** CSS perspective + rotateY
- **Progress-Bar:** Animierte Breiten-Änderung
- **Form-Feedback:** Inline Error-Messages
- **Loading-States:** Visuelle Feedback beim AJAX

---

## 🧪 Testing

### Manuelles Testing
```bash
# Backend starten
cd mainlogik,\ backend
mvn tomcat7:run

# Browser öffnen
http://localhost:8080/wissenstest/native.jsp

# Test durchlaufen:
1. Registrieren
2. Login
3. Test starten
4. Alle Fragen beantworten
5. Ergebnis anschauen
```

### Unit-Tests
- Java Tests im `src/test/java` (JUnit 5)
- JSP-spezifische Tests: Manuell im Browser

---

## 📝 Best Practices

### Code-Stil
- **JSP:** Klare Kommentare, minimale Java-Logik
- **JavaScript:** ES6 Standard, aussagekräftige Variablennamen
- **CSS:** Scoped Styles, Variablen nutzen (`:root { --primary: ... }`)

### Fehlerbehandlung
- Try-Catch in JavaScript um API-Calls
- Error-Messages für Benutzer (nicht Technical Jargon)
- Logging zum Browser-Console für Debugging

### Wartbarkeit
- 1:1 Datei-Mapping zu React-Komponenten (leicht zu verstehen)
- Zentrale Config in `app.js` (API_BASE, State)
- Wiederverwendbare Komponenten (FlipCard.jsp)

---

## 🔗 Verbindung zur React-Version

Diese JSP-Variante ist ein **exaktes architektonisches Pendant** zur React-Version:

| Aspekt | React (frondend/) | JSP Native (webapp/) |
|--------|------------------|---------------------|
| **Router** | React Router | native.jsp `?page=` Parameter |
| **State** | React useState | JS Variablen + sessionStorage |
| **Komponenten** | JSX + JS | JSP + HTML + Vanilla JS |
| **Styling** | CSS Modules | css_native/style.css |
| **API** | Fetch + apiClient.js | Fetch + apiCall() in app.js |

Beide nutzen die **gleiche Backend-API**, unterscheiden sich nur in Frontend-Technologie.

---

## 💡 Häufig Gestellte Fragen

**F: Warum JSP statt React?**  
A: JSP ist "klassischer" und konformer mit älteren Anforderungen. Diese Variante ist der "sichere Weg" für konservative Dozenten.

**F: Ist Vanilla JS schneller als React?**  
A: Ja, weniger Code = schneller. Aber für komplexe Apps kann React besser sein.

**F: Kann ich Components zwischen React & JSP teilen?**  
A: Nein, aber die **Struktur & Logik sind identisch**, also einfach zu portieren.

**F: Wo starte ich die JSP-Version?**  
A: `http://localhost:8080/wissenstest/native.jsp` (Backend muss laufen)

---

## 📚 Weitere Ressourcen

- [JSP Native Guide](JSP_NATIVE_GUIDE.md) – Quick-Start & Architektur
- [Komponenten-Connections](verbindungen_uebersicht.md) – Wie alles zusammenhängt
- [Backend Dokumentation](backend_web.xml.md) – API-Endpoints
