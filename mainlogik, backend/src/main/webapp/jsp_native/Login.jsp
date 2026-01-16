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

    <!-- Error Message Area -->
    <div id="loginError" class="animate-fade-in hidden" style="background: #fee2e2; color: #991b1b; padding: 1rem; border-radius: 0.5rem; margin-top: 1rem; text-align: center;">
        Login fehlgeschlagen. Bitte prüfen!
    </div>
</div>
