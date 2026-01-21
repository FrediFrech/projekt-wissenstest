# jsp_native/FlipCard.jsp

## Einfache Erklärung
Dies ist ein wiederverwendbares Fragment für die Flip-Karteikarten-Komponente. Eine einzelne Karte zeigt auf der Vorderseite eine Frage, auf der Rückseite die Antwort. Mit CSS 3D-Transformationen dreht sich die Karte, wenn man klickt – ganz ohne JavaScript-Framework.

## Zweck
**Reusable UI-Fragment** für interaktive Karteikarten (wird von `LearnMode.jsp` und potenziell anderen Komponenten genutzt).

## Technologie
- **JSP:** Server-Side Template mit Request-Attributen
- **CSS3:** 3D-Perspective, transform: rotateY(), Transitions
- **Vanilla JS:** Click-Event & classList Manipulation

## Inhalt & Verantwortung
### Struktur
```
.flip-card-container (clickable)
  └─ .flip-card-inner (perspective-aware)
      ├─ .flip-card-front (Vorderseite)
      │   └─ Frage mit ❓ Emoji
      └─ .flip-card-back (Rückseite, gedreht)
          └─ Antwort mit 💡 Emoji
```

### Features
- Empfängt Daten via JSP Request-Attributen: `cardQuestion` und `cardAnswer`
- 3D-Flip-Effekt durch CSS `backface-visibility: hidden`
- Styling: Glasmorphism-Optik mit Gradient
- Animierte Transition (0.6s Drehung)

## JSP-Integration
```jsp
<%
  String question = (String) request.getAttribute("cardQuestion");
  String answer = (String) request.getAttribute("cardAnswer");
%>
<!-- Markup wird generiert -->
```

## Verbindungen
- **Genutzt von:** `LearnMode.jsp` (erzeugt Instanzen via JavaScript)
- **Styling:** `css_native/style.css` + interne `<style>`

## Verwendungsbeispiel
### Server-Side (JSP)
```jsp
<%@ include file="FlipCard.jsp" %>
<% request.setAttribute("cardQuestion", "Was ist OOP?"); %>
<% request.setAttribute("cardAnswer", "Objektorientierte Programmierung"); %>
```

### Client-Side (JavaScript/LearnMode)
```javascript
const cardHtml = `
  <div class="flip-card-container" onclick="this.classList.toggle('flipped')">
    <!-- dynamisch generierte Struktur -->
  </div>
`;
```

## Wichtige Entscheidungen
- ✅ Scoped CSS (Styles direkt in der Datei)
- ✅ Pure CSS 3D (keine js-Animation Lib)
- ✅ Onclick-Handler inline (einfach & direkt)
- ✅ Fallback-Werte für JSP-Attribute ("Frage?" / "Antwort!")
