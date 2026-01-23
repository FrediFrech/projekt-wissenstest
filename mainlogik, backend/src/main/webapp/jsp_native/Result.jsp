<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
   /*
    * Component: Result.jsp
    * Counterpart: Result.jsx
    * Description: Displays test results and score with German Grade (1-6).
    */
%>
<div class="glass-card animate-fade-in" style="max-width: 600px; margin: 4rem auto; text-align: center;">
    
    <h2 style="font-size: 2.5rem; margin-bottom: 2rem; color: var(--text-main);">Dein Ergebnis</h2>

    <div style="margin-bottom: 2rem;">
        <h2 id="resultScore" style="font-size: 2rem; color: var(--text-muted); margin: 0.5rem 0;">- / - Punkte</h2>
        
        <div class="glass-card" style="display:inline-block; padding: 2rem 3rem; margin-top: 1rem; border: 2px solid var(--border);">
             <div style="font-size:1rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 1px;">Note</div>
             <div id="resultGrade" style="font-size: 5rem; font-weight: 800; line-height: 1; margin: 0.5rem 0;">-</div>
             <div id="gradeInfo" style="font-size: 1.1rem; font-style:italic; color: var(--text-muted);">...</div>
        </div>
    </div>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; max-width: 400px; margin: 0 auto 2rem auto;">
        <a href="?page=testList" class="btn btn-ghost" style="border: 1px solid var(--border);">Dashboard</a>
        <a href="?page=testRunner" class="btn btn-primary">Nochmal</a>
    </div>

    <!-- Details Toggle -->
    <div style="margin-top: 2rem; border-top: 1px solid var(--border); padding-top: 1rem;">
        <button onclick="toggleDetails()" class="btn btn-ghost" style="font-size: 0.9rem;">Details anzeigen </button>
        <div id="detailsContainer" class="hidden" style="text-align: left; margin-top: 1rem; padding: 1rem; background: rgba(0,0,0,0.02); border-radius: 8px;">
             <!-- Details dynamically populated? For now simplistic -->
             <p style="text-align:center; color: var(--text-muted);">Detaillierte Auswertung folgt.</p>
        </div>
    </div>
</div>

<script>
    function getPassConfig() {
        try {
            const storedConfig = localStorage.getItem('testConfig');
            if (!storedConfig) return null;
            const config = JSON.parse(storedConfig);
            if (!config || !config.passThresholdType) return null;
            return config;
        } catch (e) {
            return null;
        }
    }

    function evaluatePass(attempt, config) {
        if (!attempt || !config) return null;
        const type = config.passThresholdType;
        const value = Number(config.passThresholdValue);
        if (!Number.isFinite(value)) return null;

        const total = Number.isFinite(Number(attempt.totalPoints)) ? Number(attempt.totalPoints) : 0;
        const max = Number.isFinite(Number(attempt.maxPoints)) ? Number(attempt.maxPoints) : 0;

        if (type === 'points') {
            return {
                passed: total >= value,
                label: `${value} Punkte`
            };
        }

        if (max <= 0) return null;
        const pct = (total / max) * 100;
        return {
            passed: pct >= value,
            label: `${value}%`
        };
    }

    document.addEventListener('DOMContentLoaded', () => {
        const stored = sessionStorage.getItem('lastTestResult');
        if (stored) {
            const resultObj = JSON.parse(stored);
            
            // Identify if it is the new AttemptResult structure or old Attempt structure
            let attempt = resultObj;
            let details = [];
            
            // Check if resultObj has "attempt" and "details" properties (the new wrappers)
            if (resultObj.attempt && Array.isArray(resultObj.details)) {
                attempt = resultObj.attempt;
                details = resultObj.details;
            } else {
                 // Fallback: If resultObj is the attempt itself (old versions)
                 attempt = resultObj;
                 details = []; 
            }

            // Populate Score
            const total = attempt.totalPoints !== undefined ? Math.round(attempt.totalPoints * 100) / 100 : (attempt.scoreText || 0);
            const max = attempt.maxPoints !== undefined ? attempt.maxPoints : "?";
            document.getElementById('resultScore').innerText = total + " / " + max + " Punkte";

            // Populate Grade
            const gradeEl = document.getElementById('resultGrade');
            const gradeVal = attempt.grade || "-";
            gradeEl.innerText = gradeVal;

            const passConfig = getPassConfig();
            const passInfo = evaluatePass(attempt, passConfig);

            if (passInfo) {
                gradeEl.style.color = passInfo.passed ? "#10b981" : "#ef4444";
                document.getElementById('gradeInfo').innerText = passInfo.passed
                    ? `Bestanden (ab ${passInfo.label}).`
                    : `Leider nicht bestanden (ab ${passInfo.label}).`;
            } else {
                // Colorize Grade (fallback)
                const gradeNum = parseInt(gradeVal);
                if(!isNaN(gradeNum)) {
                    if(gradeNum <= 2) {
                        gradeEl.style.color = "#10b981"; // Green
                        document.getElementById('gradeInfo').innerText = "Exzellent!";
                    } else if(gradeNum <= 4) {
                        gradeEl.style.color = "#f59e0b"; // Orange
                        document.getElementById('gradeInfo').innerText = "Bestanden.";
                    } else {
                         gradeEl.style.color = "#ef4444"; // Red
                         document.getElementById('gradeInfo').innerText = "Leider nicht bestanden.";
                    }
                } else {
                     gradeEl.style.color = "var(--text-main)";
                     document.getElementById('gradeInfo').innerText = "";
                }
            }

            // Populate Details
            const detailsContainer = document.getElementById('detailsContainer');
            if (details.length > 0) {
                let html = "";
                details.forEach((d, index) => {
                    const isCorrect = d.isCorrect;
                    const color = isCorrect ? "#10b981" : "#ef4444";
                    const symbol = isCorrect ? "✓" : "✗";
                    
                    html += `
                    <div style="margin-bottom: 1.5rem; padding-bottom: 1rem; border-bottom: 1px solid rgba(0,0,0,0.1);">
                        <div style="font-weight: bold; margin-bottom: 0.5rem; color: var(--text-main); display:flex; justify-content:space-between;">
                            <span>#\${index+1} \${d.prompt}</span>
                            <span style="color: \${color}">\${Math.round(d.pointsObtained*100)/100} / \${d.maxPoints} Pt.</span>
                        </div>
                        \${d.imageUrl ? `<img src="\${d.imageUrl}" style="max-width:100%; height:auto; border-radius:8px; margin-bottom:0.8rem; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">` : ''}
                        
                        <div style="font-size: 0.9rem; margin-bottom: 0.2rem;">
                            <span style="color: var(--text-muted); width: 100px; display:inline-block;">Deine Antwort:</span> 
                            <span style="color: \${color}; font-weight: bold;">\${d.userAnswer || '(Keine)'} \${symbol}</span>
                        </div>
                        
                        \${!isCorrect ? `
                        <div style="font-size: 0.9rem;">
                            <span style="color: var(--text-muted); width: 100px; display:inline-block;">Lösung:</span> 
                            <span style="color: #10b981;">\${d.correctAnswer || '-'}</span>
                        </div>
                        ` : ''}
                    </div>
                    `;
                });
                detailsContainer.innerHTML = html;
            } else {
                detailsContainer.innerHTML = '<p style="text-align:center; color: var(--text-muted);">Für diesen Test ist keine detaillierte Auswertung verfügbar.</p>';
            }

        } else {
            document.getElementById('resultScore').innerText = "- / -";
        }
    });

    function toggleDetails() {
        const el = document.getElementById('detailsContainer');
        el.classList.toggle('hidden');
    }
</script>
