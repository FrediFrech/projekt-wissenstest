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
    if (!response.ok) throw new Error('API Error');
    return response.json();
}

// Auth Logic
async function handleLogin(event) {
    event.preventDefault();
    const form = event.target;
    const username = form.username.value;
    const password = form.password.value;

    try {
        const user = await apiCall('/auth/login', 'POST', { username, password });
        // JSP Session handling is separate, but we simulate SPA feel here
        // Reload to let JSP check session
        window.location.href = '?page=testList';
    } catch (error) {
        document.getElementById('loginError').classList.remove('hidden');
    }
}

function logout() {
    apiCall('/auth/logout').then(() => {
        window.location.href = '?page=landingPage';
    });
}

// Dashboard Logic
async function loadTests() {
    const container = document.getElementById('testList');
    if (!container) return;

    try {
        const questions = await apiCall('/test/list'); // Reuse existing endpoint logic if possible or Mock
        // Since original API returns questions directly for simplicity in prototype:
        
        container.innerHTML = `
            <div class="glass-card" style="background: white; border-left: 5px solid var(--primary);">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h3>Allgemeiner Wissenstest</h3>
                        <p style="color: grey;">10 Fragen • Gemischt</p>
                    </div>
                    <a href="?page=testRunner" class="btn btn-primary">Starten ▶</a>
                </div>
            </div>
        `;
    } catch (e) {
        container.innerHTML = '<p>Konnte Tests nicht laden.</p>';
    }
}

// Test Runner Logic (The complex part)
function initTest() {
    if(!document.getElementById('questionContainer')) return;
    
    // Simulate fetching questions
    apiCall('/test/start').then(questions => {
        currentQuestions = questions;
        currentQuestionIndex = 0;
        userAnswers = {};
        renderQuestion();
    }).catch(e => {
        console.error(e);
        document.getElementById('questionContainer').innerHTML = "<p>Fehler beim Starten.</p>";
    });
}

function renderQuestion() {
    const q = currentQuestions[currentQuestionIndex];
    if (!q) {
        finishTest();
        return;
    }

    // Update Progress
    const progress = ((currentQuestionIndex) / currentQuestions.length) * 100;
    document.getElementById('progressBar').style.width = `${progress}%`;
    document.getElementById('questionText').innerText = q.questionText;

    const answersContainer = document.getElementById('answersContainer');
    answersContainer.innerHTML = ''; // Clear

    // Render Answers with Animation
    q.answerOptions.forEach((opt, idx) => {
        const btn = document.createElement('div');
        btn.className = 'glass-card animate-fade-in';
        btn.style.padding = '1rem';
        btn.style.cursor = 'pointer';
        btn.style.animationDelay = `${idx * 0.1}s`;
        btn.innerHTML = `<span style="font-weight:bold; margin-right:10px;">${String.fromCharCode(65+idx)}</span> ${opt.optionText}`;
        
        btn.onclick = () => selectAnswer(q.id, opt.optionText, btn);
        answersContainer.appendChild(btn);
    });
}

function selectAnswer(questionId, answer, element) {
    // Visual feedback
    document.querySelectorAll('#answersContainer .glass-card').forEach(el => el.style.borderColor = 'transparent');
    element.style.borderColor = 'var(--primary)';
    element.style.borderWidth = '2px';
    
    userAnswers[questionId] = answer;
}

function nextQuestion() {
    const currentQ = currentQuestions[currentQuestionIndex];
    if (!userAnswers[currentQ.id]) {
        alert("Bitte wähle eine Antwort!");
        return;
    }
    
    currentQuestionIndex++;
    if (currentQuestionIndex < currentQuestions.length) {
        renderQuestion();
    } else {
        finishTest();
    }
}

async function finishTest() {
    // Show Loading
    document.getElementById('questionContainer').classList.add('hidden');
    
    // Format answers for Backend
    // Backend expects: Map<Integer, String> or similar.
    
    // Simulate score calculation
    let correct = 0;
    currentQuestions.forEach(q => {
        // Simplified check (assuming optionText matching)
        // In real backend, we'd send IDs.
        if (userAnswers[q.id]) {
             correct++; // Just for demo, every answer is "correct" or random in this mock
        }
    });

    // Randomize result for demo purposes if no real backend validation
    const mockCorrect = Math.floor(Math.random() * currentQuestions.length);
    
    // Save to Session Storage for Result.jsp
    const resultData = {
        correct: mockCorrect,
        total: currentQuestions.length
    };
    sessionStorage.setItem('lastTestResult', JSON.stringify(resultData));

    // Navigate to Result Page
    window.location.href = '?page=result';
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
