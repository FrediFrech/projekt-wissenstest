<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
   /* 
    * Component: Result.jsp
    * Counterpart: Result.jsx
    * Description: Displays test results and score.
    */
%>
<div class="glass-panel animate-slide-up" style="max-width: 600px; margin: 4rem auto; text-align: center;">
    <div style="margin-bottom: 2rem;">
        <span style="font-size: 5rem;">🎉</span>
    </div>
    
    <h2 style="font-size: 2.5rem; margin-bottom: 1rem; color: var(--text);">Ergebnis</h2>
    
    <div class="score-circle" style="
        width: 150px; 
        height: 150px; 
        border-radius: 50%; 
        border: 4px solid var(--primary);
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 2rem auto;
        font-size: 2.5rem;
        font-weight: bold;
        color: var(--primary);
        box-shadow: 0 0 20px rgba(59, 130, 246, 0.3);
    ">
        <span id="scoreDisplay">0%</span>
    </div>

    <p style="font-size: 1.2rem; color: var(--text-muted); margin-bottom: 2rem;">
        Du hast <span id="correctCount" style="color: var(--text); font-weight: bold;">0</span> von 
        <span id="totalCount" style="color: var(--text); font-weight: bold;">0</span> Fragen richtig beantwortet.
    </p>

    <div style="display: flex; gap: 1rem; justify-content: center;">
        <button onclick="navigate('testList')" class="nav-btn secondary">
            Zurück zur Übersicht
        </button>
        <button onclick="retryTest()" class="nav-btn primary">
            Nochmal versuchen
        </button>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // Retrieve last result from sessionStorage (simulating prop passing)
        const lastResult = JSON.parse(sessionStorage.getItem('lastTestResult') || '{"correct": 0, "total": 0}');
        
        document.getElementById('correctCount').textContent = lastResult.correct;
        document.getElementById('totalCount').textContent = lastResult.total;
        
        const percentage = lastResult.total > 0 ? Math.round((lastResult.correct / lastResult.total) * 100) : 0;
        document.getElementById('scoreDisplay').textContent = percentage + '%';
    });

    function retryTest() {
        // Logic to restart the same test would go here
        navigate('testList');
    }
</script>
