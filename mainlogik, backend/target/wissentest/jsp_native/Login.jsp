<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="glass-card animate-fade-in" style="max-width: 400px; margin: 2rem auto;">
    <h2 style="text-align: center; margin-bottom: 2rem;">Willkommen zurück 👋</h2>
    
    <form id="loginForm" onsubmit="handleLogin(event)">
        <div class="form-group">
            <label for="username">Benutzername</label>
            <input type="text" id="username" name="username" class="form-input" required placeholder="Dein Username">
        </div>
        
        <div class="form-group">
            <label for="password">Passwort</label>
            <input type="password" id="password" name="password" class="form-input" required placeholder="••••••••">
        </div>

        <button type="submit" class="btn btn-primary" style="width: 100%;">Anmelden</button>
    </form>
    
    <p style="text-align: center; margin-top: 1.5rem; color: var(--text-muted);">
        Noch kein Konto? <a href="?page=register" style="color: var(--primary);">Hier registrieren</a>
    </p>
    
    <p style="text-align: center; margin-top: 0.5rem;">
        <a href="#" onclick="openResetModal()" style="color: var(--text-muted); font-size: 0.9rem;">Passwort vergessen?</a>
    </p>

    <!-- Error Message Area -->
    <div id="loginError" class="animate-fade-in hidden" style="background: #fee2e2; color: #991b1b; padding: 1rem; border-radius: 0.5rem; margin-top: 1rem; text-align: center;">
        Login fehlgeschlagen. Bitte prüfen!
    </div>
</div>

<!-- Reset Modal -->
<div id="resetModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div style="background:white; padding:2rem; border-radius:8px; width:300px; position:relative;">
        <h3 style="margin-top:0;">Passwort zurücksetzen</h3>
        <p style="font-size:0.9rem; color:grey; margin-bottom:1rem;">Gib deinen Nutzernamen ein. Ein Admin wird informiert.</p>
        <button onclick="document.getElementById('resetModal').style.display='none'" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer; font-size:1.2rem;">✖</button>
        <input type="text" id="resetUsername" class="form-input" placeholder="Username" style="width:100%; margin-bottom:1rem;">
        <button onclick="requestReset()" class="btn btn-primary" style="width:100%;">Anfragen</button>
    </div>
</div>

<script>
    function openResetModal() { // Make sure this is globally accessible
        document.getElementById('resetModal').style.display = 'flex';
    }
    async function requestReset() {
        const user = document.getElementById('resetUsername').value;
        if(!user) return;
        try {
            await apiCall('/auth/reset-request', 'POST', {username: user});
            alert('Anfrage gesendet! Ein Admin muss dies bestätigen.');
            document.getElementById('resetModal').style.display='none';
        } catch(e) {
            alert('Fehler: Benutzer nicht gefunden ' + e.message);
        }
    }
</script>
