<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
   /*
    * Component: TestList.jsp
    *
    * EINFACHE ERKLÄRUNG FÜR STUDENTEN:
    * Dies ist das "Dashboard". Es zeigt dir deine Statistiken (Rang, bestandene Tests)
    * und eine Liste aller Prüfungen, die du starten kannst.
    * Es ist der Startpunkt für jede "Ernstfall-Prüfung".
    */
%>
<div class="glass-card animate-fade-in" style="max-width: 800px; margin: 2rem auto;">
    <h2 style="margin-bottom: 2rem;">Dein Dashboard</h2>
    
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-bottom: 3rem;">
        <div class="glass-card" style="background: white;">
            <h3>Dein Rang</h3>
            <div id="dashboardRank" style="font-size: 2rem; color: var(--primary); text-transform: capitalize;">Student</div>
        </div>
        <div class="glass-card" style="background: white;">
            <h3>Tests bestanden</h3>
            <div id="dashboardPassedCount" style="font-size: 2rem; color: var(--secondary);">0</div>
        </div>
        <div class="glass-card" style="background: white;">
            <h3>Empfohlene Schwierigkeit</h3>
            <div id="dashboardRecommendedDifficulty" style="font-size: 2rem; color: var(--primary-dark);">-</div>
        </div>
    </div>

    <h3>Verfügbare Tests</h3>
    <div id="testList" class="animate-fade-in delay-100">
        <!-- Dynamically loaded via JS -->
        <div class="loading-spinner">Lade Tests...</div>
    </div>
</div>

<!-- Custom Test Modal -->
<div id="customTestModal" onclick="if(event.target === this) closeCustomTestModal()" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center; overflow-y:auto;">
    <div style="background:white; padding:2rem; border-radius:8px; width:520px; margin: 2rem 0; position:relative;">
        <h3>Benutzerdefinierter Test</h3>
        <button onclick="closeCustomTestModal()" aria-label="Modal schlie&szlig;en" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer; font-size:1.4rem;">&times;</button>
        <form id="customTestForm" onsubmit="startCustomTest(event)" style="display:grid; gap:0.75rem; margin-top:1rem;">
            <div class="form-group">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Kategorien (Mehrfachauswahl)</label>
                <select id="customCategories" multiple class="form-input" style="width:100%; min-height:120px; padding:0.5rem; border:1px solid #ccc; border-radius:4px;">
                    <option value="All">Alle Kategorien</option>
                </select>
            </div>
            <div class="form-group">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Schwierigkeit</label>
                <select id="customDifficulty" class="form-input" style="width:100%; padding:0.5rem; border:1px solid #ccc; border-radius:4px;">
                    <option value="auto">Auto (Empfohlen)</option>
                    <option value="1">Leicht</option>
                    <option value="2" selected>Mittel</option>
                    <option value="3">Schwer</option>
                </select>
            </div>
            <div class="form-group">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Anzahl Fragen</label>
                <select id="customLimit" class="form-input" style="width:100%; padding:0.5rem; border:1px solid #ccc; border-radius:4px;">
                    <option value="5">5 Fragen</option>
                    <option value="10" selected>10 Fragen</option>
                    <option value="20">20 Fragen</option>
                    <option value="30">30 Fragen</option>
                </select>
            </div>
            <div class="form-group">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Zeit (Minuten)</label>
                <select id="customMinutes" class="form-input" style="width:100%; padding:0.5rem; border:1px solid #ccc; border-radius:4px;">
                    <option value="5">5 Minuten</option>
                    <option value="10" selected>10 Minuten</option>
                    <option value="20">20 Minuten</option>
                    <option value="30">30 Minuten</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%; padding:1rem;">Test starten</button>
        </form>
    </div>
</div>

<script>
    // Inline JS for specific page logic (or move to app.js)
    document.addEventListener('DOMContentLoaded', () => {
        loadTests();
    });
</script>
