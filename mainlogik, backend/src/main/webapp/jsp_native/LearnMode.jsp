<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
   /* 
    * Component: LearnMode.jsp
    * Counterpart: LearnMode.jsx (React Version)
    * 
    * EINFACHE ERKLÄRUNG FÜR STUDENTEN:
    * Das ist der "Lernmodus" - eine Seite mit Karteikarten, auf denen Fragen und Antworten stehen.
    * Der Student kann auf jede Karte klicken, um die Antwort zu sehen - 3D-Dreheffekt inklusive!
    * 
    * Technologie: Pure HTML + CSS3 (für den 3D-Effekt) + Vanilla JavaScript (zum Laden der Daten)
    * Backend-Verbindung: Die Fragen kommen über AJAX vom Java Backend
    */
%>
<div class="container animate-fade-in">
    <div style="text-align: center; margin-bottom: 3rem;">
        <h2 style="font-size: 2.5rem; background: linear-gradient(to right, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Lernmodus 🧠</h2>
        <p style="color: var(--text-muted);">Tippe auf eine Karte, um die Lösung zu sehen.</p>
    </div>

    <div id="cardsGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 2rem;">
        <!-- Cards will be injected here using FlipCard.jsp structure via JS -->
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        loadLearnCards();
    });

    async function loadLearnCards() {
        // Simulate API call to get questions for learning
        const questions = [
            { id: 1, q: "Was ist Polymorphie?", a: "Vielgestaltigkeit in der OOP." },
            { id: 2, q: "Wofür steht SQL?", a: "Structured Query Language" },
            { id: 3, q: "Was ist ein Servlet?", a: "Java Klasse zur HTTP-Verarbeitung" },
            { id: 4, q: "HTTP Status 404?", a: "Not Found" },
            { id: 5, q: "HTTP Status 500?", a: "Internal Server Error" },
            { id: 6, q: "Was ist React?", a: "JS Library für UIs" }
        ];

        const container = document.getElementById('cardsGrid');
        container.innerHTML = '';

        questions.forEach(item => {
            // Reusing the CSS Structure of FlipCard
            const cardHtml = `
            <div class="flip-card-container" onclick="this.classList.toggle('flipped')" style="height: 250px;">
                <div class="flip-card-inner">
                    <div class="flip-card-front">
                        <div>
                            <div style="font-size: 2rem; margin-bottom: 1rem;">❓</div>
                            <h3 style="padding: 0 1rem;">\${item.q}</h3>
                        </div>
                    </div>
                    <div class="flip-card-back">
                        <div>
                            <div style="font-size: 2rem; margin-bottom: 1rem;">💡</div>
                            <h3 style="padding: 0 1rem;">\${item.a}</h3>
                        </div>
                    </div>
                </div>
            </div>
            `;
            container.innerHTML += cardHtml;
        });
    }
</script>
