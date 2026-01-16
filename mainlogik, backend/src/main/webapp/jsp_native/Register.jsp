<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="glass-card animate-fade-in" style="max-width: 400px; margin: 2rem auto;">
    <h2 style="text-align: center; margin-bottom: 2rem;">Konto erstellen ✨</h2>
    
    <form id="registerForm" onsubmit="handleRegister(event)">
        <div class="form-group">
            <label for="username">Benutzername</label>
            <input type="text" id="username" name="username" class="form-input" required>
        </div>
        
        <div class="form-group">
            <label for="email">E-Mail Adresse</label>
            <input type="email" id="email" name="email" class="form-input" required>
        </div>
        
        <div class="form-group">
            <label for="password">Passwort</label>
            <input type="password" id="password" name="password" class="form-input" required>
        </div>

        <button type="submit" class="btn btn-primary" style="width: 100%;">Registrieren</button>
    </form>
    
    <p style="text-align: center; margin-top: 1.5rem; color: var(--text-muted);">
        Bereits ein Konto? <a href="?page=login" style="color: var(--primary);">Zum Login</a>
    </p>
</div>

<script>
    async function handleRegister(event) {
        event.preventDefault();
        const form = event.target;
        const data = {
            username: form.username.value,
            email: form.email.value,
            password: form.password.value
        };

        try {
            await apiCall('/auth/register', 'POST', data);
            alert("Registrierung erfolgreich! Bitte einloggen.");
            window.location.href = '?page=login';
        } catch (error) {
            alert("Registrierung fehlgeschlagen.");
        }
    }
</script>
