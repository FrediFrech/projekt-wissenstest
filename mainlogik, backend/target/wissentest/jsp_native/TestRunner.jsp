<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
   /* 
    * Component: TestRunner.jsp
    * Counterpart: TestRunner.jsx
    * Description: Der Kern-Quiz-Ablauf. Zeigt eine Frage nach der anderen an, speichert Antworten,
    *              und navigiert am Ende zur Result-Seite.
    * Technologie: Pure HTML + CSS3 Animationen + Vanilla JS (kein React)
    */
%>
<div class="glass-card animate-fade-in" style="max-width: 800px; margin: 0 auto;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2 id="testTitle">Wissenstest</h2>
        <div>
            <button onclick="cancelTest()" class="btn" style="background-color: #9ca3af; color: white; margin-right: 1rem; font-size: 0.8rem;">Abbrechen ✕</button>
            <span class="timer" id="timer" style="font-family: monospace; font-size: 1.5rem; color: var(--text-muted);">10:00</span>
        </div>
    </div>

    <!-- Progress Bar -->
    <div style="width: 100%; height: 8px; background: #e5e7eb; border-radius: 4px; margin-bottom: 2rem; overflow: hidden;">
        <div id="progressBar" style="width: 0%; height: 100%; background: linear-gradient(to right, var(--primary), var(--secondary)); transition: width 0.3s ease;"></div>
    </div>

    <!-- Question Container -->
    <div id="questionContainer" style="padding-top: 2rem;">
        <h3 id="questionText" style="font-size: 1.5rem; margin-bottom: 1.5rem;">Frage wird geladen...</h3>
        
        <div id="answersContainer" style="display: grid; gap: 1rem;">
            <!-- Answers injected here -->
        </div>

        <div style="margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem;">
            <button id="finishBtn" onclick="finishTest()" class="btn" style="background-color: #ef4444; color: white; display: none;">Test abgeben</button>
            <button id="nextBtn" onclick="nextQuestion()" class="btn btn-primary">Nächste Frage ➜</button>
        </div>
    </div>

    <!-- Result View (Hidden initially) -->
    <div id="resultView" class="hidden" style="text-align: center;">
        <div style="font-size: 4rem; margin-bottom: 1rem;">🎉</div>
        <h2 id="resultScore">Ergebnis: ...</h2>
        <p id="resultGrade">Note: ...</p>
        <a href="?page=dashboard" class="btn btn-primary" style="margin-top: 2rem;">Zurück zum Dashboard</a>
    </div>
</div>
