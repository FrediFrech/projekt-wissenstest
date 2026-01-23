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
        const container = document.getElementById('cardsGrid');
        container.innerHTML = '<p>Lade Fragen...</p>';
        try {
            // Using existing Test Service Endpoint
            const questions = await apiCall('/test/questions/all');
            container.innerHTML = '';
            
            if(!questions || questions.length === 0) {
                 container.innerHTML = '<p>Keine Fragen verfügbar.</p>';
                 return;
            }

            questions.forEach(item => {
                // Reusing the CSS Structure of FlipCard
                const cardHtml = `
                <div class="flip-card-container" onclick="this.classList.toggle('flipped')" style="height: 250px;">
                    <div class="flip-card-inner">
                        <div class="flip-card-front">
                            <div>
                                <div style="font-size: 2rem; margin-bottom: 1rem;">❓</div>
                                <h3 style="padding: 0 1rem; max-height: 120px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 4; -webkit-box-orient: vertical; word-break: break-word;">\${item.q}</h3>
                            </div>
                        </div>
                        <div class="flip-card-back">
                            <div>
                                <div style="font-size: 2rem; margin-bottom: 1rem;">💡</div>
                                <h3 style="padding: 0 1rem; max-height: 120px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 4; -webkit-box-orient: vertical; word-break: break-word;">\${item.a}</h3>
                            </div>
                        </div>
                    </div>
                </div>
                `;
                container.innerHTML += cardHtml;
            });
        } catch (e) {
            console.error(e);
            container.innerHTML = '<p>Fehler beim Laden der Karten. Bitte anmelden.</p>';
        }
    }
</script>
