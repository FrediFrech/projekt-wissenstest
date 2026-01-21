<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
   /* 
    * Component: FlipCard.jsp
    * Counterpart: FlipCard.jsx
    * Description: Shared markup structure for flip cards.
    * Note: This file is primarily for structural parity. 
    * In a dynamic list context (like LearnMode), this structure is often generated via JS.
    * If used server-side, it expects request attributes for 'question' and 'answer'.
    */
   
   String question = (String) request.getAttribute("cardQuestion");
   String answer = (String) request.getAttribute("cardAnswer");
   
   if (question == null) question = "Frage?";
   if (answer == null) answer = "Antwort!";
%>

<!-- Flip Card Component -->
<div class="flip-card-container" onclick="this.classList.toggle('flipped')">
    <div class="flip-card-inner">
        <!-- Front Side -->
        <div class="flip-card-front">
            <div>
                <div style="font-size: 2rem; margin-bottom: 1rem;">❓</div>
                <h3 style="padding: 0 1rem;"><%= question %></h3>
            </div>
        </div>
        
        <!-- Back Side -->
        <div class="flip-card-back">
            <div>
                <div style="font-size: 2rem; margin-bottom: 1rem;">💡</div>
                <h3 style="padding: 0 1rem;"><%= answer %></h3>
            </div>
        </div>
    </div>
</div>

<style>
    /* Scoped styles/Critical CSS for FlipCard if referenced standalone */
    .flip-card-container {
        background-color: transparent;
        perspective: 1000px;
        cursor: pointer;
        min-height: 200px;
    }

    .flip-card-inner {
        position: relative;
        width: 100%;
        height: 100%;
        text-align: center;
        transition: transform 0.6s;
        transform-style: preserve-3d;
        box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
        border-radius: 1rem;
    }

    .flip-card-container.flipped .flip-card-inner {
        transform: rotateY(180deg);
    }

    .flip-card-front, .flip-card-back {
        position: absolute;
        width: 100%;
        height: 100%;
        -webkit-backface-visibility: hidden;
        backface-visibility: hidden;
        border-radius: 1rem;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        padding: 1rem;
    }

    .flip-card-front {
        background: rgba(255, 255, 255, 0.05);
        color: var(--text);
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .flip-card-back {
        background: linear-gradient(135deg, var(--primary), var(--secondary));
        color: white;
        transform: rotateY(180deg);
    }
</style>
