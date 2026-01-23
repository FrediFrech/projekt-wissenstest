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

    <div style="display: flex; justify-content: center; margin-bottom: 2rem;">
        <div class="glass-card" style="background: white; border-left: 5px solid #dc2626; max-width: 480px; width: 100%; text-align: center;">
            <h3 style="margin-bottom: 0.5rem;">Pr&uuml;fung konfigurieren</h3>
            <p style="font-size: 0.9rem; color: #666; margin-bottom: 1.25rem;">
                Stelle dir deinen Pr&uuml;fungsmodus individuell zusammen.
            </p>
            <button onclick="openExamModal()" class="btn btn-primary" style="background: linear-gradient(to right, #dc2626, #b91c1c); width: 100%; font-size: 1.1rem; padding: 1rem;">
                Optionen w&auml;hlen
            </button>
        </div>
    </div>
</div>

<!-- Exam Config Modal -->
<div id="examModal" onclick="if(event.target === this) closeExamModal()" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center; overflow-y:auto;">
    <div style="background:white; padding:2rem; border-radius:8px; width:520px; margin: 2rem 0; position:relative;">
        <h3>Pr&uuml;fungsmodus Einstellungen</h3>
        <button onclick="closeExamModal()" aria-label="Modal schlie&szlig;en" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer; font-size:1.4rem;">&times;</button>
        <form id="examConfigForm" onsubmit="startExam(event)" style="display: grid; gap: 0.75rem; margin-top:1rem;">
            <div class="form-group">
                <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Kategorien (Mehrfachauswahl)</label>
                <select id="examCategory" multiple class="form-input" style="width: 100%; min-height: 120px; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px;">
                    <option value="All">Alle Kategorien</option>
                </select>
            </div>
            <div class="form-group">
                <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Schwierigkeit</label>
                <select id="examDifficulty" class="form-input" style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px;">
                    <option value="1">Leicht</option>
                    <option value="2" selected>Mittel</option>
                    <option value="3">Schwer</option>
                </select>
            </div>
            <div class="form-group">
                <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Anzahl Fragen</label>
                <select id="examLimit" class="form-input" style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px;">
                    <option value="10">10 Fragen</option>
                    <option value="20" selected>20 Fragen</option>
                    <option value="30">30 Fragen</option>
                </select>
            </div>
            <div class="form-group">
                <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Zeit (Minuten)</label>
                <select id="examMinutes" class="form-input" style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px;">
                    <option value="10">10 Minuten</option>
                    <option value="15">15 Minuten</option>
                    <option value="20" selected>20 Minuten</option>
                    <option value="30">30 Minuten</option>
                </select>
            </div>
            <div class="form-group">
                <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Bestehen ab</label>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:0.75rem;">
                    <select id="examPassType" class="form-input">
                        <option value="percent" selected>Prozent</option>
                        <option value="points">Punkte</option>
                    </select>
                    <input id="examPassValue" type="number" class="form-input" min="1" max="100" step="1" value="50">
                </div>
                <small style="display:block; color:#6b7280; margin-top:0.35rem;">Beispiel: 60 % oder 12 Punkte</small>
            </div>
            <button type="submit" class="btn btn-primary" style="background: linear-gradient(to right, #dc2626, #b91c1c); width: 100%; font-size: 1.1rem; padding: 1rem;">
                Pr&uuml;fung starten
            </button>
        </form>
    </div>
</div>

<script>
    async function loadExamCategories() {
        const select = document.getElementById('examCategory');
        if (!select) return;
        try {
            let categories = [];
            if (typeof apiCall === 'function') {
                categories = await apiCall('/test/categories');
            } else {
                const resp = await fetch('api/test/categories');
                if (!resp.ok) throw new Error('Failed to load categories');
                categories = await resp.json();
            }
            const options = categories.map(c => '<option value="' + c + '">' + c + '</option>').join('');
            select.insertAdjacentHTML('beforeend', options);
        } catch (e) {
            console.error('Could not fetch categories', e);
        }
    }

    function openExamModal() {
        document.getElementById('examModal').style.display = 'flex';
    }

    function closeExamModal() {
        document.getElementById('examModal').style.display = 'none';
    }

    function startExam(event) {
        event.preventDefault();
        if(!confirm("Bist du sicher? Die Zeit läuft sofort nach dem Start.")) return;

        const categorySelect = document.getElementById('examCategory');
        const selected = categorySelect ? Array.from(categorySelect.selectedOptions).map(o => o.value) : [];
        const categories = selected.filter(v => v && v !== 'All');
        const limit = parseInt(document.getElementById('examLimit')?.value || '20', 10);
        const durationMinutes = parseInt(document.getElementById('examMinutes')?.value || '20', 10);
        const difficulty = parseInt(document.getElementById('examDifficulty')?.value || '2', 10);
        const passType = document.getElementById('examPassType')?.value || 'percent';
        let passValue = parseFloat(document.getElementById('examPassValue')?.value || '50');
        if (!Number.isFinite(passValue)) {
            passValue = passType === 'points' ? Math.ceil((limit || 20) * 0.5) : 50;
        }
        if (passType === 'percent') {
            passValue = Math.min(Math.max(passValue, 1), 100);
        } else {
            passValue = Math.max(passValue, 1);
        }

        const examConfig = {
            category: categories.length > 0 ? null : 'All',
            categories: categories.length > 0 ? categories : null,
            limit: Number.isFinite(limit) && limit > 0 ? limit : 20,
            difficulty: Number.isFinite(difficulty) ? difficulty : 2,
            durationMinutes: Number.isFinite(durationMinutes) && durationMinutes > 0 ? durationMinutes : 20,
            passThresholdType: passType,
            passThresholdValue: passValue
        };

        localStorage.setItem('testConfig', JSON.stringify(examConfig));
        sessionStorage.setItem('isExamMode', 'true');
        closeExamModal();
        window.location.href = '?page=testRunner';
    }

    document.addEventListener('DOMContentLoaded', () => {
        loadExamCategories();
    });
</script>
