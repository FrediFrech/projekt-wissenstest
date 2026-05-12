# css_native/style.css

## Einfache Erklärung
Dies ist das globale CSS für die JSP-Native-Variante. Es ermöglicht ein Glasmorphism-Effekt (durchscheinende Karten), schöne Farbgradienten, Animationen, responsive Layouts auch ohne ein React framework mit MUIv7 mit reinem CSS3, ohne externe Libraries.

## Zweck
**Globales Styling** für alle JSP-Seiten: Layout, Farben, Animationen, Responsivität.

## Technologie
- **CSS3:** Flexbox, Grid, Animations, Transforms, Gradients
- **CSS Variables (Custom Properties):** Zentrale Farbdefinitionen
- **Modern Browser APIs:** `backdrop-filter` für Glasmorphism

## Hauptkomponenten

### 1. **CSS Variables (Design-Tokens)**
```css
:root {
  --primary: #3b82f6;          /* Blau */
  --secondary: #8b5cf6;        /* Lila */
  --text: #1f2937;             /* Dunkelgrau */
  --text-muted: #9ca3af;       /* Hellgrau */
  --background: #f6f7fb;       /* Hellblau */
  --surface: rgba(255, 255, 255, 0.05);  /* Glasmorphism Base */
}
```

### 2. **Basis-Styles**
```css
body {
  font-family: 'Inter', system-ui, sans-serif;
  background: linear-gradient(135deg, #f6f7fb, #ede9fe);
  color: var(--text);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 24px;
}
```

### 3. **Glasmorphism Cards**
```css
.glass-panel {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 1.5rem;
  padding: 2rem;
}
```

### 4. **Animationen (Keyframes)**
```css
@keyframes animate-fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes animate-slide-up {
  from { 
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Verwendung: */
.animate-fade-in {
  animation: animate-fade-in 0.6s ease-out;
}

.animate-slide-up {
  animation: animate-slide-up 0.6s ease-out;
}
```

### 5. **Buttons**
```css
.btn {
  padding: 12px 24px;
  border-radius: 0.75rem;
  border: none;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-primary {
  background: linear-gradient(135deg, var(--primary), var(--secondary));
  color: white;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);
}

.btn-ghost {
  background: transparent;
  color: var(--primary);
  border: 1px solid var(--primary);
}
```

### 6. **Forms**
```css
input, textarea, select {
  width: 100%;
  padding: 12px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 0.75rem;
  background: rgba(255, 255, 255, 0.05);
  color: var(--text);
  font-size: 1rem;
  transition: border 0.3s ease;
}

input:focus, textarea:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}
```

### 7. **Layout (Grid & Flexbox)**
```css
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem 0;
  margin-bottom: 3rem;
}

.nav-links {
  display: flex;
  gap: 1rem;
}

.grid-2 {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 2rem;
}

.grid-auto {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 2rem;
}

@media (max-width: 768px) {
  .grid-2 {
    grid-template-columns: 1fr;
  }
}
```

## Eingebundene Dateien

Diese CSS wird in `native.jsp` mit eingebunden:
```html
<link rel="stylesheet" href="${pageContext.request.contextPath}/css_native/style.css">
```

Oder direkt per `<link>` im Kopf aller JSP-Seiten.

## Farb-Palette

| Name | Wert | Verwendung |
|------|------|-----------|
| Primary | #3b82f6 | Buttons, Links, Highlights |
| Secondary | #8b5cf6 | Gradients, Accents |
| Text | #1f2937 | Normale Textfarbe |
| Text-Muted | #9ca3af | Subtexte, Disabled |
| Background | #f6f7fb | Seiten-Background |
| Surface | rgba(255,255,255,0.05) | Karten & Panels |

## CSS Features (Modern)

✅ **Flexbox** – Für Navigation, Button-Gruppen, Responsive Layouts  
✅ **CSS Grid** – Für Karten-Layouts (Test-Liste, Learning-Cards)  
✅ **CSS Variables** – Zentrale Konfiguration, leicht zu ändern  
✅ **Gradients** – Background & Button Effects  
✅ **Transitions** – Smooth Interaktionen (Hover, Focus)  
✅ **Animations** – Keyframes für Einblendungen  
✅ **Media Queries** – Responsive Design (Mobile, Tablet, Desktop)  
✅ **Backdrop Filter** – Glasmorphism mit `blur()`  

## Browser-Kompatibilität

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 15+
- ✅ Edge 90+
- ⚠️ IE 11: Nicht unterstützt (Variablen, Backdrop-Filter fallen zurück), aber wer benutzt das schon noch?

## Performance-Tipps

- CSS ist inline oder extern (nicht kritisch für First Paint)
- Animationen nutzen `transform` & `opacity` (GPU-beschleunigt)
- Media Queries begrenzen CSS auf benötigte Devices
- Keine unnötigen Keyframe-Definitionen

## Anpassung

### Neue Farbe hinzufügen
```css
:root {
  --success: #10b981;  /* Grün */
}

.btn-success {
  background: var(--success);
}
```

### Neue Animation hinzufügen
```css
@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.bounce {
  animation: bounce 0.6s ease;
}
```

### Breakpoints erweitern
```css
@media (max-width: 1200px) {
  /* Tablet */
}

@media (max-width: 768px) {
  /* Mobile */
}

@media (max-width: 480px) {
  /* Small Mobile */
}
```

## Hinweis
Diese CSS ist eigenständig und benötigt keine Frontend‑Frameworks.
