<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
   /* 
    * Component: ExamMode.jsp
    * Counterpart: ExamMode.jsx (New Feature)
    * Description: Strict "Exam" mode with fixed parameters and higher stakes.
    */
%>
<div class="glass-card animate-fade-in" style="max-width: 800px; margin: 0 auto;">
    <div style="text-align: center; margin-bottom: 3rem;">
        <h2 style="font-size: 2.5rem; background: linear-gradient(to right, #dc2626, #991b1b); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Prüfungsmodus 🎓</h2>
        <p style="color: var(--text-muted);">Hier wird es ernst. Simuliere eine echte Prüfungssituation.</p>
    </div>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem;">
        <!-- Exam Info -->
        <div class="glass-card" style="background: white;">
            <h3>Regeln</h3>
            <ul style="color: var(--text-muted); line-height: 1.8; margin-top: 1rem;">
                <li>⏱ <b>Zeitlimit:</b> 20 Minuten strikt.</li>
                <li>📝 <b>Umfang:</b> 20 Fragen aus allen Gebieten.</li>
                <li>🚫 <b>Hilfe:</b> Keine Tipps, kein Zurück.</li>
                <li>⚖️ <b>Bewertung:</b> Strenge Notenskala (IHK-Standard).</li>
            </ul>
        </div>

        <!-- Start Action -->
        <div class="glass-card" style="background: white; border-left: 5px solid #dc2626; display: flex; flex-direction: column; justify-content: center;">
            <h3 style="margin-bottom: 1rem;">Bereit?</h3>
            <p style="font-size: 0.9rem; color: #666; margin-bottom: 1.5rem;">
                Das Ergebnis wird in deiner permanenten Akte gespeichert. Viel Erfolg!
            </p>
            <button onclick="startExam()" class="btn btn-primary" style="background: linear-gradient(to right, #dc2626, #b91c1c); width: 100%; font-size: 1.1rem; padding: 1rem;">
                Prüfung starten
            </button>
        </div>
    </div>
    
    <div style="text-align: center; margin-top: 2rem;">
        <p style="font-size: 0.8rem; color: #aaa;">Hinweis: Stelle sicher, dass du eine stabile Internetverbindung hast.</p>
    </div>
</div>

<script>
    function startExam() {
        if(!confirm("Bist du sicher? Die Zeit läuft sofort nach dem Start.")) return;
        
        // Configuration for Exam Mode
        const examConfig = {
            category: "All", // All categories
            limit: 20,       // 20 Questions
            difficulty: 2    // Mixed/Medium (Internal Logic in Service handles this usually via presets, but 2 is fine)
        };
        
        // Store config and redirect
        localStorage.setItem('testConfig', JSON.stringify(examConfig));
        
        // Use a flag to indicate Exam Mode (for UI changes in runner if needed)
        sessionStorage.setItem('isExamMode', 'true');
        
        window.location.href = '?page=testRunner';
    }
</script>
