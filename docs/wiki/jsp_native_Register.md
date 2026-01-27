# jsp_native/Register.jsp

## Einfache Erklärung
Das Registrierungs-Formular für neue Benutzer. Der User gibt seinen gewünschten Benutzernamen, Email und Passwort ein. Das Formular schickt diese Daten ans Backend, das prüft auf Duplikate und speichert den neuen Benutzer. Danach kann der Benutzer sich einloggen.

## Zweck
**Benutzer-Registrierung:** Formular zur Kontoerstellung mit Validierung.

## Technologie
- **JSP:** Server-Side Form-Template
- **HTML5:** Semantisches Formular mit Input-Types
- **Vanilla JS:** Form-Submit & AJAX zum Backend

## Inhalt & Verantwortung
### Struktur
- **Titel:** "Registrieren"
- **Username Input:** Text-Eingabe (unique)
- **Email Input:** Email-Feld (HTML5 validation)
- **Password Input:** Passwort-Feld (masked)
- **Confirm Password:** Wiederholung zur Sicherheit
- **Submit Button:** "Registrieren"
- **Error Message (versteckt):** Zeigt Fehler (z.B. Username existiert bereits)
- **Login Link:** "Bereits registriert? Jetzt anmelden"

### Logik (Pseudo-Code)
```javascript
handleRegister(event) {
  event.preventDefault();
  
  const form = event.target;
  const username = form.username.value;
  const email = form.email.value;
  const password = form.password.value;
  const confirmPassword = form.confirmPassword.value;
  
  // Client-Side Validierung
  if (password !== confirmPassword) {
    showError('Passwörter stimmen nicht überein');
    return;
  }
  
  // POST an Backend
  apiCall('/auth/register', 'POST', {
    username, email, password
  })
    .then(result => {
      // Erfolg → Redirect zu Login
      window.location.href = '?page=login';
    })
    .catch(error => {
      // Fehler (z.B. Username existiert)
      showError(error.message);
    });
}
```

## Verbindungen
- **Router:** In `native.jsp` über `?page=register` eingebunden
- **Styling:** `css_native/style.css`
- **Logik:** `js_native/app_main.js` (Funktion: `handleRegister()`)
- **Backend:** POST zu `/api/auth/register`

## Wichtige Entscheidungen
- ✅ Client-Side Validierung (Passwort-Bestätigung)
- ✅ Server-Side Validierung (Duplikat-Check, Email-Format)
- ✅ Vanilla JS Form-Handling
- ✅ Redirect zu Login nach Erfolg (nicht direkt einloggen)

## Security-Notes
- ✅ Passwort wird nie im Frontend geloggt
- ✅ Backend hasht & saltet Passwort mit iteriertem SHA‑256
- ✅ Email-Duplikate werden geprüft
- ✅ Username-Format wird validiert
