<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="hero-section" style="text-align: center; padding: 4rem 0;">
    <h1 class="animate-fade-in" style="font-size: 3.5rem; font-weight: 800; margin-bottom: 1rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
        Meistere dein Wissen
    </h1>
    <p class="animate-fade-in delay-100" style="font-size: 1.25rem; color: var(--text-muted); margin-bottom: 2rem;">
        Die moderne Lernplattform für UML, Softwaretechnik und mehr.<br>
        Adaptiv, schnell und effektiv.
    </p>
    
    <div class="animate-fade-in delay-200">
        <a href="?page=register" class="btn btn-primary" style="font-size: 1.1rem; padding: 1rem 2rem;">Jetzt starten 🚀</a>
    </div>

    <!-- Feature Grid -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 2rem; margin-top: 4rem;">
        <!-- Feature 1 -->
        <div class="glass-card animate-fade-in delay-300">
            <div style="font-size: 2.5rem; margin-bottom: 1rem;">🎯</div>
            <h3 style="margin-bottom: 0.5rem;">Adaptives Lernen</h3>
            <p style="color: var(--text-muted);">Passt sich deinem Niveau an für maximalen Lernerfolg.</p>
        </div>

        <!-- Feature 2: Interactive Flip Card Demo -->
        <div class="flip-card-container animate-fade-in delay-300" onclick="this.classList.toggle('flipped')" style="margin: 0 auto;">
            <div class="flip-card-inner">
                <div class="flip-card-front">
                    <div>
                        <div style="font-size: 2rem; margin-bottom: 0.5rem;">❓</div>
                        <h3>Klick mich!</h3>
                        <p>(Lern-Modus Demo)</p>
                    </div>
                </div>
                <div class="flip-card-back">
                    <div>
                        <h3>✅ Richtig!</h3>
                        <p>Interaktive Karten helfen beim Merken.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Feature 3 -->
        <div class="glass-card animate-fade-in delay-300">
            <div style="font-size: 2.5rem; margin-bottom: 1rem;">📊</div>
            <h3 style="margin-bottom: 0.5rem;">Live Analytics</h3>
            <p style="color: var(--text-muted);">Sieh deine Noten und Fortschritte in Echtzeit.</p>
        </div>
    </div>
</div>
