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
    <div style="background:white; padding:2rem; border-radius:8px; width:650px; max-width:95vw; margin: 2rem 0; position:relative;">
        <h3 style="margin-bottom: 0.5rem;" id="modalTitle">Pr&uuml;fungskonfigurator</h3>
        <p style="color:gray; font-size:0.9rem; margin-bottom:1.5rem;">Erstelle deine individuelle Pr&uuml;fung.</p>
        
        <button onclick="closeExamModal()" aria-label="Modal schlie&szlig;en" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer; font-size:1.4rem;">&times;</button>
        
        <form id="examConfigForm" onsubmit="startExam(event)">
            <!-- General Settings -->
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.5rem; background: #f9fafb; padding: 1rem; border-radius: 8px;">
                <div class="form-group">
                    <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Anzahl Fragen (5-200)</label>
                    <input type="number" id="examLimit" class="form-input" min="5" max="200" value="20" style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px;">
                </div>
                <div class="form-group">
                    <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Zeit (Minuten, 1-180)</label>
                    <input type="number" id="examMinutes" class="form-input" min="1" max="180" value="20" style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px;">
                </div>
            </div>

            <!-- Segment Builder -->
            <div style="margin-bottom: 1.5rem;">
                <label style="font-size: 0.9rem; font-weight: bold; display: block; margin-bottom: 0.5rem;">Prüfungs-Zusammensetzung</label>
                <div style="background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 8px; padding: 1rem;">
                    <div style="display:flex; gap:0.75rem; row-gap:0.75rem; margin-bottom:1rem; align-items:flex-end; flex-wrap:wrap;">
                        <div style="flex:1; min-width: 120px;">
                            <label style="font-size:0.75rem;">Kategorie</label>
                            <select id="segCat" class="form-input" style="width:100%;"><option value="All">Alle</option></select>
                        </div>
                        <div style="flex:1; min-width: 100px;">
                             <label style="font-size:0.75rem;">Typ</label>
                             <select id="segType" class="form-input" style="width:100%;">
                                 <option value="All">Alle</option>
                                 <option value="MC">Multiple Choice</option>
                                 <option value="CLOZE">Lückentext</option>
                                 <option value="IMAGE">Bild</option>
                                 <option value="FREE">Freitext</option>
                             </select>
                        </div>
                        <div style="flex:1; min-width: 80px;">
                             <label style="font-size:0.75rem;">Stufe</label>
                             <select id="segDiff" class="form-input" style="width:100%;">
                                 <option value="0">Alle</option>
                                 <option value="1">Leicht</option>
                                 <option value="2">Mittel</option>
                                 <option value="3">Schwer</option>
                             </select>
                        </div>
                        <div style="width: 80px;">
                             <label style="font-size:0.75rem;">Anteil %</label>
                             <input type="number" id="segPercent" value="100" min="1" max="100" class="form-input" style="width:100%;">
                        </div>
                        <div style="display:flex; align-items:flex-end;">
                            <button type="button" onclick="addSegment()" class="btn btn-primary" style="height: 38px; min-width: 40px; padding: 0 0.9rem; font-weight:bold; line-height:1; box-sizing:border-box;">+</button>
                        </div>
                    </div>
                    
                    <ul id="segmentList" style="list-style:none; padding:0; margin:0; max-height:150px; overflow-y:auto; background:white; border:1px solid #e5e7eb; border-radius:4px;">
                        <!-- Segments go here -->
                        <li id="emptySegMsg" style="padding:0.75rem; text-align:center; color:gray; font-size:0.9rem;">Noch keine Regeln definiert (Standard: Alles zufällig).</li>
                    </ul>
                    <div style="text-align:right; margin-top:0.5rem; font-size:0.85rem; color:#64748b;">
                        Summe: <span id="totalPercent" style="font-weight:bold;">0</span>%
                    </div>
                </div>
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
            </div>
            
            <button type="submit" class="btn btn-primary" style="background: linear-gradient(to right, #dc2626, #b91c1c); width: 100%; font-size: 1.1rem; padding: 1rem; margin-top:1rem;">
                Pr&uuml;fung starten
            </button>
        </form>
    </div>
</div>

<script>
    let segments = [];

    async function loadExamCategories() {
        const select = document.getElementById('segCat');
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

    function addSegment() {
        const cat = document.getElementById('segCat').value;
        const type = document.getElementById('segType').value;
        const diff = document.getElementById('segDiff').value;
        const pct = parseInt(document.getElementById('segPercent').value) || 0;

        if (pct <= 0) return;
        
        segments.push({
            category: cat,
            type: type,
            difficulty: parseInt(diff),
            percent: pct,
            id: Date.now()
        });
        renderSegments();
    }

    function removeSegment(id) {
        segments = segments.filter(s => s.id !== id);
        renderSegments();
    }

    function renderSegments() {
        const list = document.getElementById('segmentList');
        const empty = document.getElementById('emptySegMsg');
        const totalEl = document.getElementById('totalPercent');
        
        // Clear list but keep empty msg logic
        list.innerHTML = '';
        
        if (segments.length === 0) {
           list.appendChild(empty);
           empty.style.display = 'block';
           totalEl.innerText = '0';
           return;
        }
        
        let sum = 0;
        segments.forEach(s => {
            sum += s.percent;
            const li = document.createElement('li');
            li.style.padding = '0.5rem';
            li.style.borderBottom = '1px solid #f3f4f6';
            li.style.display = 'flex';
            li.style.justifyContent = 'space-between';
            li.style.alignItems = 'center';
            li.style.fontSize = '0.9rem';
            
            const diffLabel = s.difficulty === 0 ? 'Alle Stufen' : (s.difficulty === 1 ? 'Leicht' : (s.difficulty === 2 ? 'Mittel' : 'Schwer'));
            const typeLabel = s.type === 'All' ? 'Alle Typen' : (s.type === 'CLOZE' ? 'Lückentext' : (s.type === 'MC' ? 'Multiple Choice' : s.type));
            
            li.innerHTML = `
                <span>
                    <strong>\${s.percent}%</strong>
                    <span style="color:gray"> | </span> 
                    \${s.category} 
                    <span style="color:gray"> · </span> 
                    \${typeLabel}
                    <span style="color:gray"> · </span> 
                    \${diffLabel}
                </span>
                <button type="button" onclick="removeSegment(\${s.id})" style="color:#ef4444; background:none; border:none; cursor:pointer;">&times;</button>
            `;
            list.appendChild(li);
        });
        
        // Visual warning if > 100
        totalEl.innerText = sum;
        totalEl.style.color = sum > 100 ? 'red' : (sum === 100 ? 'green' : 'black');
    }

    function openExamModal() {
        document.getElementById('examModal').style.display = 'flex';
        // Reset segments if empty
        if(segments.length === 0) {
            renderSegments();
        }
    }

    function closeExamModal() {
        document.getElementById('examModal').style.display = 'none';
    }

    function startExam(event) {
        event.preventDefault();
        
        // Basic Config
        const limit = parseInt(document.getElementById('examLimit')?.value || '20', 10);
        const durationMinutes = parseInt(document.getElementById('examMinutes')?.value || '20', 10);
        const passType = document.getElementById('examPassType')?.value || 'percent';
        let passValue = parseFloat(document.getElementById('examPassValue')?.value || '50');

        // Validation
        const currentSum = segments.reduce((sum, s) => sum + s.percent, 0);
        
        if (segments.length > 0 && Math.abs(currentSum - 100) > 5) {
             if(!confirm("Die Summe der Anteile ist " + currentSum + "%. Möchtest du trotzdem starten? (Fehlende % werden zufällig aufgefüllt)")) {
                 return;
             }
        }
        
        if(!confirm("Prüfung mit " + limit + " Fragen starten? Zeit: " + durationMinutes + " Min.")) return;

        // Build Config Object
        const examConfig = {
            limit: limit,
            durationMinutes: durationMinutes,
            // If no segments defined, fallback to simple random (handled by backend or we can create a wildcard segment)
            segments: segments.length > 0 ? segments : null,
            // Fallback params for standard startTest if segments null
            difficulty: 2, 
            category: 'All',
            
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
