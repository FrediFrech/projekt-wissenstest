// Native JS Logic for High-End JSP Frontend

// State
let currentUser = null;
let currentQuestions = [];
let currentQuestionIndex = 0;
let userAnswers = {};

// API Helpers
const API_BASE = 'api';

async function apiCall(endpoint, method = 'GET', body = null) {
    const options = {
        method,
        headers: {
            'Content-Type': 'application/json'
        }
    };
    if (body) options.body = JSON.stringify(body);
    
    const response = await fetch(`${API_BASE}${endpoint}`, options);
    const contentType = response.headers.get('content-type') || '';
    if (!response.ok) {
        let message = 'API Error';
        try {
            if (contentType.includes('application/json')) {
                const err = await response.json();
                if (err && err.error) message = err.error;
            } else {
                const text = await response.text();
                if (text) message = text;
            }
        } catch (e) {
            // keep default message
        }
        throw new Error(message);
    }
    if (contentType.includes('application/json')) {
        return response.json();
    }
    return response.text();
}

function normalizeText(value) {
    if (value === null || value === undefined) return value;
    return String(value)
    .replace(/ÃƒÂ¤|Ã¤/g, 'ä')
    .replace(/ÃƒÂ¶|Ã¶/g, 'ö')
    .replace(/ÃƒÂ¼|Ã¼/g, 'ü')
    .replace(/ÃƒÂŸ|ÃŸ/g, 'ß')
    .replace(/ÃƒÂ„|Ã„/g, 'Ä')
    .replace(/ÃƒÂ–|Ã–/g, 'Ö')
    .replace(/ÃƒÂœ|Ãœ/g, 'Ü')
    .replace(/Ã¢â‚¬â€œ/g, '–')
    .replace(/Ã¢â‚¬â€/g, '”')
    .replace(/Ã¢â‚¬â€ž/g, '„')
    .replace(/Ã¢â‚¬â€˜/g, '‘')
    .replace(/Ã¢â‚¬â€™/g, '’');
}

if (typeof window !== 'undefined') {
    window.normalizeText = normalizeText;
}

function normalizeCategories(categories) {
    const map = new Map();
    (categories || []).forEach(c => {
        const normalized = normalizeText(c);
        if (!map.has(normalized)) {
            map.set(normalized, normalized);
        }
    });
    return Array.from(map.entries()).map(([label, value]) => ({ label, value }));
}

function isAttemptPassed(attempt) {
    if (!attempt) return false;
    const rawGrade = attempt.grade;
    if (rawGrade !== null && rawGrade !== undefined) {
        const normalized = String(rawGrade).trim().replace(',', '.');
        const gradeValue = parseFloat(normalized);
        if (!Number.isNaN(gradeValue)) {
            return gradeValue <= 4;
        }
    }
    if (attempt.maxPoints > 0) {
        const pct = (attempt.totalPoints / attempt.maxPoints) * 100;
        return pct >= 50;
    }
    return false;
}

function difficultyLabel(difficulty) {
    switch (Number(difficulty)) {
        case 1:
            return 'Leicht';
        case 2:
            return 'Mittel';
        case 3:
            return 'Schwer';
        default:
            return 'Unbekannt';
    }
}

// Auth Logic
async function handleLogin(event) {
    event.preventDefault();
    const form = event.target;
    const username = form.username.value;
    const password = form.password.value;

    try {
        await apiCall('/auth/login', 'POST', { username, password });
        // JSP Session handling is separate, but we simulate SPA feel here
        // Reload to let JSP check session
        window.location.href = '?page=testList';
    } catch (error) {
        document.getElementById('loginError').classList.remove('hidden');
    }
}

function logout() {
    apiCall('/auth/logout', 'POST').then(() => {
        window.location.href = '?page=landingPage';
    });
}

// Dashboard Logic
async function loadTests() {
    const container = document.getElementById('testList');
    if (!container) return;

    const passedCountEl = document.getElementById('dashboardPassedCount');
    const recommendedEl = document.getElementById('dashboardRecommendedDifficulty');

    // Update Rank
    if(document.getElementById('dashboardRank') && window.USER_ROLE) {
        document.getElementById('dashboardRank').innerText = window.USER_ROLE;
    }

    // Admin Card
    let adminHtml = '';
    if (window.USER_ROLE === 'admin') {
         adminHtml = `
            <div class="glass-card" style="background: white; border-left: 5px solid #ef4444; margin-bottom: 2rem;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h3>Admin Panel &#128274;</h3>
                        <p style="color: grey;">Verwaltung von Usern & Fragen</p>
                    </div>
                    <a href="?page=adminPanel" class="btn btn-primary" style="background: #ef4444; border:none;">\u00d6ffnen</a>
                </div>
            </div>
         `;
    }

        // Load available test (static for now)
        let categories = [];
    try {
         categories = await apiCall('/test/categories');
    } catch(e) { console.error("Could not fetch categories", e); categories = ['Allgemein']; }
        const categoryOptions = normalizeCategories(categories);
    
    // Create a configuration card
    const testHtml = `
            <div class="glass-card" style="background: white; border-left: 5px solid var(--primary); margin-bottom: 2rem;">
                <div style="display: flex; flex-direction: column; gap: 1rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                         <div>
                            <h3>Allgemeiner Wissenstest</h3>
                            <p style="color: grey;">Konfiguriere deinen Test</p>
                        </div>
                    </div>
                    
                    <form onsubmit="startConfiguredTest(event)" style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 1rem; align-items: end;">
                        <div class="form-group">
                            <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Kategorie</label>
                            <select name="category" class="form-input" style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px;">
                                <option value="All">Alle Kategorien</option>
                                ${categoryOptions.map(c => `<option value="${c.value}">${c.label}</option>`).join('')}
                            </select>
                        </div>
                         <div class="form-group">
                            <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Anzahl Fragen</label>
                            <select name="limit" class="form-input" style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px;">
                                <option value="5">5 Fragen</option>
                                <option value="10" selected>10 Fragen</option>
                                <option value="20">20 Fragen</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label style="font-size: 0.8rem; font-weight: bold; display: block; margin-bottom: 0.4rem;">Modus</label>
                            <select name="difficulty" class="form-input" style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 4px;">
                                <option value="auto">Auto (Empfohlen)</option>
                                <option value="1">Leicht (Training)</option>
                                <option value="2">Mittel (Pr\u00fcfung)</option>
                                <option value="3">Schwer (Experte)</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Starten &#x25B6;</button>
                    </form>
                    <div style="display:flex; justify-content:flex-end;">
                        <button type="button" class="btn btn-ghost" onclick="openCustomTestModal()">Benutzerdefinierter Test</button>
                    </div>
                </div>
            </div>
    `;

    // Load History
    let historyHtml = '<div class="glass-card" style="background: white;"><h3>Deine letzten Ergebnisse</h3><p>Keine Ergebnisse vorhanden.</p></div>';
    try {
        const history = await apiCall('/test/history');
        if (passedCountEl) {
            const passedCount = Array.isArray(history) ? history.filter(isAttemptPassed).length : 0;
            passedCountEl.innerText = passedCount;
        }
        if (history && history.length > 0) {
            const rows = history.map(h => {
                const pct = h.maxPoints > 0 ? Math.round((h.totalPoints / h.maxPoints) * 100) : 0;
                let badgeColor = pct >= 80 ? '#10b981' : (pct < 50 ? '#ef4444' : '#f59e0b');
                return `
                    <div style="display: flex; justify-content: space-between; padding: 0.5rem 0; border-bottom: 1px solid #eee;">
                        <span>Test (Schwierigkeit ${h.difficulty})</span>
                        <span style="font-weight: bold; color: ${badgeColor};">${pct}% (${h.totalPoints}/${h.maxPoints})</span>
                    </div>
                `;
            }).join('');
            
            historyHtml = `
                <div class="glass-card" style="background: white;">
                    <h3 style="margin-bottom: 1rem;">Deine letzten Ergebnisse</h3>
                    <div style="max-height: 200px; overflow-y: auto;">
                        ${rows}
                    </div>
                </div>
            `;
        }
    } catch (e) {
        console.error("Failed to load history", e);
        if (passedCountEl) passedCountEl.innerText = '0';
    }

    if (recommendedEl) {
        recommendedEl.innerText = '...';
        try {
            const rec = await apiCall('/test/recommend');
            recommendedEl.innerText = difficultyLabel(rec && rec.recommendedDifficulty);
        } catch (e) {
            console.error('Failed to load recommended difficulty', e);
            recommendedEl.innerText = '-';
        }
    }
    
    container.innerHTML = adminHtml + testHtml + historyHtml;

    const customSelect = document.getElementById('customCategories');
    if (customSelect) {
        customSelect.innerHTML = '<option value="All">Alle Kategorien</option>' +
            categoryOptions.map(c => `<option value="${c.value}">${c.label}</option>`).join('');
    }
}

function startConfiguredTest(event) {
    event.preventDefault();
    const formData = new FormData(event.target);
    const difficultyRaw = formData.get('difficulty');
    const autoMode = difficultyRaw === 'auto';
    const difficulty = autoMode ? 2 : parseInt(difficultyRaw, 10);
    const config = {
        category: formData.get('category'),
        limit: parseInt(formData.get('limit')),
        difficulty: Number.isFinite(difficulty) ? difficulty : 2,
        autoMode
    };
    // Store config in localStorage to pass it to the TestRunner page
    localStorage.setItem('testConfig', JSON.stringify(config));
    window.location.href = '?page=testRunner';
}

function openCustomTestModal() {
    const modal = document.getElementById('customTestModal');
    if (modal) modal.style.display = 'flex';
}

function closeCustomTestModal() {
    const modal = document.getElementById('customTestModal');
    if (modal) modal.style.display = 'none';
}

function startCustomTest(event) {
    event.preventDefault();
    const categorySelect = document.getElementById('customCategories');
    const selected = categorySelect ? Array.from(categorySelect.selectedOptions).map(o => o.value) : [];
    const categories = selected.filter(v => v && v !== 'All');
    const limit = parseInt(document.getElementById('customLimit')?.value || '10', 10);
    const difficultyRaw = document.getElementById('customDifficulty')?.value || '2';
    const autoMode = difficultyRaw === 'auto';
    const difficulty = autoMode ? 2 : parseInt(difficultyRaw, 10);
    const durationMinutes = parseInt(document.getElementById('customMinutes')?.value || '10', 10);

    const config = {
        category: categories.length > 0 ? null : 'All',
        categories: categories.length > 0 ? categories : null,
        limit: Number.isFinite(limit) ? limit : 10,
        difficulty: Number.isFinite(difficulty) ? difficulty : 2,
        autoMode,
        durationMinutes: Number.isFinite(durationMinutes) ? durationMinutes : 10
    };

    localStorage.setItem('testConfig', JSON.stringify(config));
    closeCustomTestModal();
    window.location.href = '?page=testRunner';
}

// Test Runner Logic (The complex part)
let testTimer = null; // Global timer ID
let testStartTime = null;

function initTest() {
    if(!document.getElementById('questionContainer')) return;
    
    // Retrieve config
    let config = { difficulty: 1, limit: 10, category: "All" };
    try {
        const stored = localStorage.getItem('testConfig');
        if (stored) config = JSON.parse(stored);
    } catch(e) { console.warn("Invalid config, using defaults"); }

    const isExamMode = sessionStorage.getItem('isExamMode') === 'true';
    const titleEl = document.getElementById('testTitle');
    const modeLabel = isExamMode ? 'Pr\u00fcfungsmodus' : 'Wissenstest';
    if (titleEl) {
        titleEl.textContent = `${modeLabel} (${config.limit} Fragen)`;
    }

    // Fetch questions from Backend
    apiCall('/test/start', 'POST', config).then(questions => {
        currentQuestions = Array.isArray(questions) ? questions : [];
        currentQuestionIndex = 0;
        userAnswers = {};
        testStartTime = Date.now();
        if (titleEl) {
            const loadedCount = currentQuestions.length;
            const titleSuffix = loadedCount && loadedCount < config.limit
                ? `${loadedCount}/${config.limit} Fragen verf\u00fcgbar`
                : `${loadedCount || config.limit} Fragen`;
            titleEl.textContent = `${modeLabel} (${titleSuffix})`;
        }
        renderQuestion();
        const baseCount = currentQuestions.length > 0 ? currentQuestions.length : config.limit;
        const durationMinutes = Number.isFinite(config.durationMinutes) && config.durationMinutes > 0
            ? config.durationMinutes
            : baseCount;
        startTimer(durationMinutes * 60); // 1 minute per question default
    }).catch(e => {
        console.error(e);
        document.getElementById('questionContainer').innerHTML = "<p>Fehler beim Starten des Tests. Bitte erneut versuchen.</p>";
    });
}

function startTimer(durationSeconds) {
    let timer = durationSeconds, minutes, seconds;
    const display = document.getElementById('timer');
    
    if (testTimer) clearInterval(testTimer);

    testTimer = setInterval(function () {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        if (display) {
            display.textContent = minutes + ":" + seconds;
            
            // Visual warning
            if (timer < 60) {
                display.style.color = "red";
                display.style.fontWeight = "bold";
            }
        }

        if (--timer < 0) {
            clearInterval(testTimer);
            alert("Die Zeit ist abgelaufen! Der Test wird automatisch abgegeben.");
            finishTest();
        }
    }, 1000);
}

function renderQuestion() {
    const q = currentQuestions[currentQuestionIndex];
    
    // Update Progress Bar
    const progressBar = document.getElementById('progressBar');
    if (progressBar && currentQuestions.length > 0) {
        const percentage = ((currentQuestionIndex + 1) / currentQuestions.length) * 100;
        progressBar.style.width = percentage + '%';
    }

    if (!q) {
        finishTest();
        return;
    }

    const questionText = document.getElementById('questionText');
    if (questionText) {
        questionText.textContent = normalizeText(q.prompt || '');
        if (q.imageUrl && q.imageUrl.trim() !== "") {
            const img = document.createElement('img');
            img.src = q.imageUrl;
            img.alt = 'Fragebild';
            img.style.maxWidth = '100%';
            img.style.maxHeight = '300px';
            img.style.marginTop = '1rem';
            img.style.borderRadius = '8px';
            questionText.appendChild(document.createElement('br'));
            questionText.appendChild(img);
        }
    }

    const answersContainer = document.getElementById('answersContainer');
    answersContainer.innerHTML = ''; // Clear

    if (q.type === 'FREE') {
        // Free Text Input
        const inputDiv = document.createElement('div');
        inputDiv.style.marginTop = '1rem';
        inputDiv.innerHTML = `
            <textarea id="freeTextInput" class="form-input" rows="4" placeholder="Deine Antwort hier eingeben..." style="width:100%; padding: 1rem; border: 1px solid #ccc; border-radius: 8px; font-family: inherit; font-size: 1rem;"></textarea>
        `;
        answersContainer.appendChild(inputDiv);
        
        const textArea = inputDiv.querySelector('textarea');
        if (userAnswers[q.id]) {
            textArea.value = userAnswers[q.id];
        }
        textArea.oninput = (e) => {
            userAnswers[q.id] = e.target.value;
        };
    } else if (q.type === 'CLOZE') {
        // Cloze Text logic (simplified: text with input fields)
        // Since backend sends tokens, we should render them. 
        // For now, simpler fallback if Token list is available
        if (q.tokens && q.tokens.length > 0) {
             const container = document.createElement('div');
             // This is a naive implementation; normally prompt should have placeholders
             // We'll just list inputs matching the tokens
             q.tokens.sort((a,b) => a.tokenIndex - b.tokenIndex).forEach((token, idx) => {
                const row = document.createElement('div');
                row.style.marginBottom = '0.5rem';
                const displayIndex = Number.isFinite(token.tokenIndex) ? token.tokenIndex : (idx + 1);
                     row.innerHTML = `<label>L\u00fccke ${displayIndex}:</label> <input type="text" class="form-input" data-index="${Number.isFinite(token.tokenIndex) ? token.tokenIndex : idx}">`;
                container.appendChild(row);
             });
             // Listen to changes
             container.addEventListener('input', () => {
                 const inputs = Array.from(container.querySelectorAll('input'));
                 const values = inputs.map(i => i.value);
                 userAnswers[q.id] = values;
             });
             answersContainer.appendChild(container);
        } else {
             answersContainer.innerHTML = '<p>L\u00fcckentext Fehler: Keine Tokens.</p>';
        }

    } else if (q.options && q.options.length > 0) {
        // Multi Choice / Image Choice
        q.options.forEach((opt, idx) => {
            const btn = document.createElement('div');
            btn.className = 'glass-card animate-fade-in';
            btn.style.padding = '1rem';
            btn.style.cursor = 'pointer';
            btn.style.marginTop = '0.5rem'; // Add spacing
            btn.style.animationDelay = `${idx * 0.1}s`;
            const label = document.createElement('span');
            label.style.fontWeight = 'bold';
            label.style.marginRight = '10px';
            label.textContent = String.fromCharCode(65 + idx);
            const text = document.createElement('span');
            text.textContent = normalizeText(opt.answerText);
            btn.appendChild(label);
            btn.appendChild(text);
            
            // Check if selected
            if(userAnswers[q.id] === opt.id) {
               btn.style.borderColor = 'var(--primary)';
               btn.style.borderWidth = '2px';
            }

            btn.onclick = () => selectAnswer(q.id, opt.id, btn);
            answersContainer.appendChild(btn);
        });
    } else {
         answersContainer.innerHTML = '<p>Keine Antwortm\u00f6glichkeiten geladen.</p>';
    }
}

function selectAnswer(questionId, answerId, element) {
    // Visual feedback - Single Choice Logic
    document.querySelectorAll('#answersContainer .glass-card').forEach(el => el.style.borderColor = 'transparent');
    element.style.borderColor = 'var(--primary)';
    element.style.borderWidth = '2px';
    
    userAnswers[questionId] = answerId;
}

function nextQuestion() {
    const currentQ = currentQuestions[currentQuestionIndex];
    if (!userAnswers[currentQ.id]) {
        alert("Bitte w\u00e4hle eine Antwort!");
        return;
    }
    
    currentQuestionIndex++;
    if (currentQuestionIndex < currentQuestions.length) {
        renderQuestion();
    } else {
        finishTest();
    }
}

function cancelTest() {
    if(confirm("M\u00f6chtest du den Test wirklich abbrechen? Dein Fortschritt geht verloren.")) {
        if(testTimer) clearInterval(testTimer);
        sessionStorage.removeItem('isExamMode');
        window.location.href = '?page=testList';
    }
}

async function finishTest() {
    // Show Loading
    if(testTimer) clearInterval(testTimer); // Stop timer immediately
    sessionStorage.removeItem('isExamMode');
    
    // Config
    let config = { difficulty: 1 };
    try {
        const stored = localStorage.getItem('testConfig');
        if (stored) config = JSON.parse(stored);
    } catch(e) {}

    document.getElementById('questionContainer').innerHTML = `
        <div style="text-align: center; padding: 2rem;">
            <h3>Ergebnisse werden gespeichert...</h3>
            <div class="loading-spinner"></div>
        </div>
    `;
    
    if (!currentQuestions || currentQuestions.length === 0) {
         window.location.href = '?page=testList';
         return;
    }
    
    try {
        const result = await apiCall('/test/submit', 'POST', {
            difficulty: config.difficulty,
            questionIds: currentQuestions.map(q => q.id),
            answers: userAnswers,
            durationSeconds: testStartTime ? Math.floor((Date.now() - testStartTime) / 1000) : 0
        });

        // Store full result object so Result.jsp can render details (AttemptResult structure)
        sessionStorage.setItem('lastTestResult', JSON.stringify(result));
        
        window.location.href = '?page=result';

    } catch (e) {
        console.error(e);
        alert("Fehler beim Abgeben des Tests! " + e.message);
        window.location.href = '?page=testList';
    }
}

// Auto-Init logic based on page
document.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const page = urlParams.get('page');
    
    if (page === 'testRunner') {
        initTest();
    } else if (page === 'testList') {
        loadTests();
    }
});
