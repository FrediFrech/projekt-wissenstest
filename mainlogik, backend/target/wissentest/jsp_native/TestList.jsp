<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="glass-card animate-fade-in" style="max-width: 800px; margin: 2rem auto;">
    <h2 style="margin-bottom: 2rem;">Dein Dashboard</h2>
    
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-bottom: 3rem;">
        <div class="glass-card" style="background: white;">
            <h3>Dein Rang</h3>
            <div id="dashboardRank" style="font-size: 2rem; color: var(--primary); text-transform: capitalize;">Student</div>
        </div>
        <div class="glass-card" style="background: white;">
            <h3>Tests bestanden</h3>
            <div style="font-size: 2rem; color: var(--secondary);">0</div>
        </div>
    </div>

    <h3>Verfügbare Tests</h3>
    <div id="testList" class="animate-fade-in delay-100">
        <!-- Dynamically loaded via JS -->
        <div class="loading-spinner">Lade Tests...</div>
    </div>
</div>

<script>
    // Inline JS for specific page logic (or move to app.js)
    document.addEventListener('DOMContentLoaded', () => {
        loadTests();
    });
</script>
