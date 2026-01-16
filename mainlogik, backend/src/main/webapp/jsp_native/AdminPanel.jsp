<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
   /* 
    * Component: AdminPanel.jsp
    * Counterpart: AdminPanel.jsx
    * Description: Administration dashboard for managing questions and users.
    */
%>
<div class="glass-card animate-fade-in" style="max-width: 1000px; margin: 2rem auto;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2 style="background: linear-gradient(to right, #ef4444, #b91c1c); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Admin Panel 🔒</h2>
        <div style="font-size: 0.9rem; color: var(--text-muted);">Verwaltungsoberfläche</div>
    </div>

    <!-- Stats Row -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-bottom: 3rem;">
        <div class="glass-card" style="background: white; border-left: 4px solid #ef4444;">
            <h3>Total Users</h3>
            <div id="statUsers" style="font-size: 2rem; color: #1f2937;">-</div>
        </div>
        <div class="glass-card" style="background: white; border-left: 4px solid #f59e0b;">
            <h3>Total Questions</h3>
            <div id="statQuestions" style="font-size: 2rem; color: #1f2937;">-</div>
        </div>
        <div class="glass-card" style="background: white; border-left: 4px solid #3b82f6;">
            <h3>Completed Tests</h3>
            <div id="statTests" style="font-size: 2rem; color: #1f2937;">-</div>
        </div>
    </div>

    <!-- Actions -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
        <!-- Question Management -->
        <div>
            <h3>Frage hinzufügen</h3>
            <form id="addQuestionForm" onsubmit="handleAddQuestion(event)" style="background: rgba(255,255,255,0.5); padding: 1.5rem; border-radius: 1rem;">
                <div class="form-group">
                    <label>Fragetext</label>
                    <input type="text" name="text" class="form-input" required>
                </div>
                <div class="form-group">
                    <label>Typ</label>
                    <select name="type" class="form-input">
                        <option value="MULTIPLE_CHOICE">Multiple Choice</option>
                        <option value="CLOZE_TEXT">Lückentext</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary" style="background: #ef4444;">Speichern</button>
            </form>
        </div>

        <!-- User Management List -->
        <div>
            <h3>Letzte Aktivitäten</h3>
            <ul id="activityLog" style="list-style: none; padding: 0;">
                <li style="padding: 0.5rem; border-bottom: 1px solid #eee;">Lädt...</li>
            </ul>
        </div>
    </div>
</div>

<script>
    // Admin Logic
    document.addEventListener('DOMContentLoaded', () => {
        loadAdminStats();
    });

    async function loadAdminStats() {
        try {
            const stats = await apiCall('/admin/stats');
            document.getElementById('statUsers').innerText = stats.users || 0;
            document.getElementById('statQuestions').innerText = stats.questions || 0;
            document.getElementById('statTests').innerText = stats.attempts || 0;
        } catch(e) {
            console.log("Admin API not reachable in Demo Mode");
            // Mock data for display
            document.getElementById('statUsers').innerText = "3";
            document.getElementById('statQuestions').innerText = "15";
            document.getElementById('statTests').innerText = "8";
        }
    }

    async function handleAddQuestion(e) {
        e.preventDefault();
        alert("Frage gespeichert (Demo)");
        e.target.reset();
    }
</script>
