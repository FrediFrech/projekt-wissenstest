# jsp_native/Login.jsp

## Einfache Erklärung
Das Login-Formular. Der Benutzer gibt seinen Benutzernamen und sein Passwort ein. Das Formular schickt diese Daten ans Backend, das prüft, ob sie korrekt sind. Wenn ja, wird eine Session erstellt und der Benutzer zum Dashboard weitergeleitet. Falls nicht, erscheint eine Fehlermeldung.

## Zweck
**Authentifizierung:** Login-Formular mit Validierung und Session-Handling.

## Technologie
- **JSP:** Server-Side Form-Handling mit Fehlermeldung
- **HTML5:** Semantisches Formular
- **Vanilla JS:** Form-Submit & AJAX zum Backend

## Inhalt & Verantwortung
### Struktur
- **Titel:** "Login"
- **Username Input:** Text-Eingabe für Benutzername
- **Password Input:** Passwort-Feld (masked)
- **Submit Button:** "Login" 
- **Error Message (versteckt):** Wird angezeigt, falls Login fehlschlägt
- **Register Link:** "Noch kein Konto? Jetzt registrieren"

### Logik
```javascript
handleLogin(event) {
  event.preventDefault();
  
  // Daten aus Form lesen
  const username = form.username.value;
  const password = form.password.value;
  
  // POST an Backend /api/auth/login
  apiCall('/auth/login', 'POST', { username, password })
    .then(user => {
      // Session gespeichert → Redirect zu Dashboard
      window.location.href = '?page=testList';
    })
    .catch(error => {
      // Fehler anzeigen
      document.getElementById('loginError').classList.remove('hidden');
    });
}
```

## Verbindungen
- **Router:** In `native.jsp` über `?page=login` eingebunden
- **Styling:** `css_native/style.css`
- **Logik:** `js_native/app.js` (Funktion: `handleLogin()`)
- **Backend:** POST zu `/api/auth/login`
- **Frontend-Pendant:** `frondend/src/components/Login.jsx`

## Wichtige Entscheidungen
- ✅ Server-Side Session bei Success (nicht nur localStorage)
- ✅ Vanilla JS Form-Handling
- ✅ HTTPS-ready (Passwörter über POST, nicht GET)
- ✅ Fehlerbehandlung mit sichtbarer Meldung

## Security-Notes
- ✅ Passwort wird nie gelesen oder geloggt
- ✅ Backend validiert und hasht Passwort
- ✅ CSRF-Protection durch Same-Site Cookies (Backend-Konfiguration)
