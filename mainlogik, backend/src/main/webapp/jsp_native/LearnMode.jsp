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
<style>
    /* LearnMode-only tweaks (avoid touching global css_native/style.css) */
    .learn-badges {
        display: flex;
        gap: 0.4rem;
        flex-wrap: wrap;
        justify-content: center;
        margin-bottom: 0.5rem;
    }
    .learn-badge {
        padding: 2px 8px;
        border-radius: 999px;
        font-size: 0.75rem;
        line-height: 1.2;
        white-space: nowrap;
    }
    .learn-badge--type { background:#eef2ff; color:#3730a3; }
    .learn-badge--cat { background:#ecfeff; color:#155e75; }
    .learn-badge--diff { background:#fef3c7; color:#92400e; }

    .learn-card-actions {
        display: flex;
        justify-content: center;
        gap: 0.5rem;
        margin-top: 0.6rem;
    }
    .learn-mini-btn {
        border: 1px solid rgba(255,255,255,0.45);
        background: rgba(255,255,255,0.12);
        color: inherit;
        padding: 0.35rem 0.65rem;
        border-radius: 10px;
        cursor: pointer;
        font-size: 0.8rem;
    }
    .learn-mini-btn:hover { background: rgba(255,255,255,0.22); }

    .learn-modal-overlay {
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.55);
        z-index: 2000;
        display: none;
        align-items: center;
        justify-content: center;
        padding: 1rem;
    }
    .learn-modal {
        /* Smaller, centered modal */
        width: min(90vw, 550px) !important;
        height: min(80vh, 700px) !important;
        max-width: none !important;
        max-height: none !important;
        overflow: hidden;
        border-radius: 16px;
        background: #ffffff;
        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.4);
        border: none;
        display: flex;
        flex-direction: column;
        z-index: 2010;
        animation: modalPop 0.25s ease-out;
    }
    @keyframes modalPop {
        0% { transform: scale(0.95); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
    }
    .learn-modal-header {
        padding: 0.75rem 1.25rem;
        border-bottom: 1px solid #e5e7eb;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 1rem;
        flex-shrink: 0;
        min-height: 60px;
        background: #fff;
    }
    .learn-modal-body {
        padding: 0;
        flex: 1;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #f1f5f9;
        position: relative;
    }
    .learn-modal-close {
        border: none;
        background: transparent;
        font-size: 1.6rem;
        cursor: pointer;
        color: #111827;
        line-height: 1;
    }
    .learn-modal-split {
        /* Legacy / Fallback */
        display: none; 
    }
    .learn-modal-card-container {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 1.5rem;
    }
    .learn-modal-flip {
        width: 100%;
        height: 100%;
    }
</style>

<div class="container animate-fade-in">
    <div style="text-align: center; margin-bottom: 3rem;">
        <h2 style="font-size: 2.5rem; background: linear-gradient(to right, var(--primary), var(--secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Lernmodus 🧠</h2>
        <p style="color: var(--text-muted);">Tippe auf eine Karte, um die Lösung zu sehen.</p>
    </div>

    <div class="glass-card" style="max-width: 980px; margin: 0 auto 2rem auto; background:#ffffff;">
        <div style="display:flex; flex-wrap:wrap; gap: 1rem; align-items:flex-end;">
            <div class="form-group" style="flex: 2; min-width: 250px;">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Suche</label>
                <input id="learnSearch" class="form-input" placeholder="Frage, Antwort oder Kategorie" style="width:100%;" />
            </div>
            <div class="form-group" style="flex: 1; min-width: 120px;">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Typ</label>
                <select id="learnTypeFilter" class="form-input" style="width:100%;">
                    <option value="All">Alle</option>
                </select>
            </div>
            <div class="form-group" style="flex: 1; min-width: 150px;">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Kategorie</label>
                <select id="learnCategoryFilter" class="form-input" style="width:100%;">
                    <option value="All">Alle</option>
                </select>
            </div>
            <div class="form-group" style="flex: 1; min-width: 100px;">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Schwierigkeit</label>
                <select id="learnDifficultyFilter" class="form-input" style="width:100%;">
                    <option value="All">Alle</option>
                    <option value="1">Leicht</option>
                    <option value="2">Mittel</option>
                    <option value="3">Schwer</option>
                </select>
            </div>
            <div class="form-group" style="flex: 1; min-width: 120px;">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Sortieren</label>
                <select id="learnSortBy" class="form-input" style="width:100%;">
                    <option value="category">Kategorie</option>
                    <option value="type">Typ</option>
                    <option value="difficulty">Schwierigkeit</option>
                    <option value="question">Frage (A–Z)</option>
                    <option value="answer">Antwort (A–Z)</option>
                    <option value="random">Zufällig</option>
                </select>
            </div>
            <div class="form-group" style="flex: 1; min-width: 120px;">
                <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.4rem;">Gruppieren</label>
                <select id="learnGroupBy" class="form-input" style="width:100%;">
                    <option value="none">Keine</option>
                    <option value="category" selected>Kategorie</option>
                    <option value="type">Typ</option>
                    <option value="difficulty">Schwierigkeit</option>
                </select>
            </div>
        </div>
        <div style="display:flex; gap:1rem; flex-wrap:wrap; margin-top:1rem;">
            <label style="display:flex; gap:0.5rem; align-items:center; cursor:pointer; user-select:none;">
                <input id="learnOnlyWithImage" type="checkbox" />
                <span>Nur Fragen mit Bild</span>
            </label>
            <button id="learnShuffle" type="button" class="btn btn-ghost" style="font-size:0.85rem;">Mischen</button>
        </div>
        <div id="learnStats" style="margin-top:0.75rem; color:var(--text-muted); font-size:0.9rem;"></div>
    </div>

    <div id="cardsGrid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 4rem; align-items: stretch;">
        <!-- Cards will be injected here using FlipCard.jsp structure via JS -->
    </div>

    <!-- Enlarge / Modal view -->
    <div id="learnModalOverlay" class="learn-modal-overlay" onclick="if(event.target === this) closeLearnModal()">
        <div class="learn-modal" role="dialog" aria-modal="true" aria-labelledby="learnModalTitle" onclick="event.stopPropagation()">
            <div class="learn-modal-header">
                <div>
                    <div id="learnModalBadges" class="learn-badges" style="justify-content:flex-start; margin-bottom:0.35rem;"></div>
                    <div id="learnModalTitle" style="font-weight:800; font-size:1.05rem; color:#111827;">Karteikarte</div>
                </div>
                <button class="learn-modal-close" type="button" aria-label="Schließen" onclick="closeLearnModal()">&times;</button>
            </div>
            <div class="learn-modal-body">
                <div id="learnModalCardContainer" class="learn-modal-card-container"></div>
            </div>
        </div>
    </div>
</div>

<script>
    let learnQuestions = [];

    document.addEventListener('DOMContentLoaded', () => {
        // Move modal overlay to body to prevent stacking context issues due to transforms on parent
        const overlay = document.getElementById('learnModalOverlay');
        if (overlay && overlay.parentNode !== document.body) {
            document.body.appendChild(overlay);
        }

        const controls = [
            'learnSearch',
            'learnTypeFilter',
            'learnCategoryFilter',
            'learnDifficultyFilter',
            'learnSortBy',
            'learnGroupBy',
            'learnOnlyWithImage'
        ];

        controls.forEach(id => {
            const el = document.getElementById(id);
            if (!el) return;
            const evt = el.tagName === 'INPUT' ? 'input' : 'change';
            el.addEventListener(evt, renderLearnCards);
        });

        const shuffleBtn = document.getElementById('learnShuffle');
        if (shuffleBtn) {
            shuffleBtn.addEventListener('click', () => {
                const sort = document.getElementById('learnSortBy');
                if (sort) sort.value = 'random';
                renderLearnCards();
            });
        }

        loadLearnCards();
    });

    function escapeHtml(value) {
        const str = (value ?? '').toString();
        return str
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    async function loadLearnCards() {
        const container = document.getElementById('cardsGrid');
        container.innerHTML = '<p>Lade Fragen...</p>';
        try {
            // Using existing Test Service Endpoint
            const questions = await apiCall('/test/questions/all');
            learnQuestions = Array.isArray(questions) ? questions : [];

            if (!learnQuestions || learnQuestions.length === 0) {
                container.innerHTML = '<p>Keine Fragen verfügbar.</p>';
                return;
            }

            initFilterOptions(learnQuestions);
            renderLearnCards();
        } catch (e) {
            console.error(e);
            container.innerHTML = '<p>Fehler beim Laden der Karten. Bitte anmelden.</p>';
        }
    }

    function initFilterOptions(items) {
        const typeSelect = document.getElementById('learnTypeFilter');
        const categorySelect = document.getElementById('learnCategoryFilter');

        if (typeSelect) {
            const current = typeSelect.value || 'All';
            const types = Array.from(new Set(items.map(i => i?.type).filter(Boolean)))
                .map(t => String(t))
                .sort();
            // Use formatType for display but keep original value
            typeSelect.innerHTML = '';
            const optionAll = document.createElement('option');
            optionAll.value = 'All';
            optionAll.textContent = 'Alle';
            typeSelect.appendChild(optionAll);
            types.forEach(val => {
                const opt = document.createElement('option');
                opt.value = val;
                opt.textContent = formatType(val);
                typeSelect.appendChild(opt);
            });
            typeSelect.value = valuesMatches(types, current) ? current : 'All';
        }

        if (categorySelect) {
            const current = categorySelect.value || 'All';
            const categories = Array.from(new Set(items.map(i => i?.category).filter(Boolean)))
                .map(c => String(c))
                .sort((a, b) => a.localeCompare(b, 'de'));
            setSelectOptions(categorySelect, categories, current);
        }
    }

    function valuesMatches(list, val) { return list.includes(val); }

    function setSelectOptions(select, values, current) {
        select.innerHTML = '';
        const optionAll = document.createElement('option');
        optionAll.value = 'All';
        optionAll.textContent = 'Alle';
        select.appendChild(optionAll);
        values.forEach(val => {
            const opt = document.createElement('option');
            opt.value = val;
            opt.textContent = val;
            select.appendChild(opt);
        });
        select.value = values.includes(current) ? current : 'All';
    }

    function formatDifficulty(value) {
        if (Number(value) === 1) return 'Leicht';
        if (Number(value) === 2) return 'Mittel';
        if (Number(value) === 3) return 'Schwer';
        return 'Unbekannt';
    }

    function formatType(type) {
        if (!type) return '';
        if (type === 'MC') return 'Multiple Choice';
        if (type === 'CLOZE') return 'Lückentext';
        if (type === 'FREE') return 'Freitext';
        if (type === 'IMAGE') return 'Bild-Frage';
        return type;
    }

    function normalizeText(value) {
        return (value ?? '').toString().toLowerCase();
    }

    function shuffleArray(arr) {
        const copy = [...arr];
        for (let i = copy.length - 1; i > 0; i -= 1) {
            const j = Math.floor(Math.random() * (i + 1));
            [copy[i], copy[j]] = [copy[j], copy[i]];
        }
        return copy;
    }

    function renderLearnCards() {
        const container = document.getElementById('cardsGrid');
        if (!container) return;
        container.innerHTML = '';

        const search = normalizeText(document.getElementById('learnSearch')?.value);
        const typeFilter = document.getElementById('learnTypeFilter')?.value || 'All';
        const categoryFilter = document.getElementById('learnCategoryFilter')?.value || 'All';
        const difficultyFilter = document.getElementById('learnDifficultyFilter')?.value || 'All';
        const sortBy = document.getElementById('learnSortBy')?.value || 'category';
        const groupBy = document.getElementById('learnGroupBy')?.value || 'none';
        const onlyWithImage = document.getElementById('learnOnlyWithImage')?.checked === true;
        let items = Array.isArray(learnQuestions) ? [...learnQuestions] : [];

        items = items.filter(item => {
            if (!item) return false;
            if (typeFilter !== 'All' && String(item.type) !== typeFilter) return false;
            if (categoryFilter !== 'All' && String(item.category) !== categoryFilter) return false;
            if (difficultyFilter !== 'All' && String(item.difficulty) !== difficultyFilter) return false;
            if (onlyWithImage && !(item.imageUrl && String(item.imageUrl).trim() !== '')) return false;
            if (search) {
                const hay = normalizeText(item.q) + ' ' + normalizeText(item.a) + ' ' + normalizeText(item.category) + ' ' + normalizeText(item.type);
                if (!hay.includes(search)) return false;
            }
            return true;
        });

        items = dedupeItems(items);

        if (sortBy === 'random') {
            items = shuffleArray(items);
        } else {
            items.sort((a, b) => {
                const av = sortValue(a, sortBy);
                const bv = sortValue(b, sortBy);
                if (typeof av === 'number' && typeof bv === 'number') return av - bv;
                return String(av).localeCompare(String(bv), 'de');
            });
        }

        const totalUnique = dedupeItems(Array.isArray(learnQuestions) ? [...learnQuestions] : []).length;
        updateStats(items, totalUnique, Array.isArray(learnQuestions) ? learnQuestions.length : 0);

        if (items.length === 0) {
            container.innerHTML = '<p>Keine passenden Fragen gefunden.</p>';
            return;
        }

        const grouped = groupItems(items, groupBy);
        Object.entries(grouped).forEach(([group, groupItems]) => {
            if (groupBy !== 'none') {
                const header = '<div style="grid-column: 1 / -1; padding: 0.6rem 1rem; border-radius: 12px; background: #f1f5f9; border: 1px solid #e2e8f0;">'
                    + '<strong>' + escapeHtml(group) + '</strong>'
                    + '<span style="color: var(--text-muted); font-size: 0.85rem;">(' + groupItems.length + ')</span>'
                    + '</div>';
                container.innerHTML += header;
            }
            groupItems.forEach(item => {
                const qText = escapeHtml(item.q);
                const aText = escapeHtml(item.a);
                const typeLabel = escapeHtml(formatType(item.type) || '');
                const categoryLabel = escapeHtml(item.category || 'Ohne Kategorie');
                const diffLabel = escapeHtml(formatDifficulty(item.difficulty));
                const hasImage = item.imageUrl && String(item.imageUrl).trim() !== '';

                // Requirement: category badges above the question mark
                const badges = '<div class="learn-badges">'
                    + '<span class="learn-badge learn-badge--cat">' + categoryLabel + '</span>'
                    + '<span class="learn-badge learn-badge--type">' + typeLabel + '</span>'
                    + '<span class="learn-badge learn-badge--diff">' + diffLabel + '</span>'
                    + '</div>';

                const frontTitle = '<div style="padding: 0 0.5rem; font-weight:800; font-size:1.05rem; line-height:1.25; max-height: 140px; overflow:auto; word-break: break-word;">' + qText + '</div>';

                const frontImage = hasImage
                    ? '<img src="' + escapeHtml(item.imageUrl) + '" loading="lazy" alt="Fragebild" style="width: 100%; max-height: 150px; object-fit: contain; margin-top: 0.75rem; border-radius: 10px; box-shadow: 0 8px 22px rgba(0,0,0,0.15);" onclick="event.stopPropagation(); openLearnModalById(' + item.id + ')" />'
                    : '';

                const actions = '<div class="learn-card-actions">'
                    + '<button type="button" class="learn-mini-btn" onclick="event.stopPropagation(); openLearnModalById(' + item.id + ')">Vergrößern</button>'
                    + '</div>';

                // Override global flip-card CSS size to prevent clipping and allow responsive width
                const cardHtml = '<div class="flip-card-container" onclick="this.classList.toggle(\'flipped\')" style="width:100%; height: 340px;">'
                    + '<div class="flip-card-inner">'
                    + '<div class="flip-card-front" style="align-items:stretch; justify-content:flex-start; overflow:hidden;">'
                    + '<div style="display:flex; flex-direction:column; height:100%; width:100%; text-align:center;">'
                    + badges
                    + '<div style="font-size: 2rem; margin-bottom: 0.55rem;">❓</div>'
                    + '<div style="flex: 1 1 auto; overflow:hidden; padding:0 0.4rem;">'
                    + frontTitle
                    + frontImage
                    + '</div>'
                    + actions
                    + '</div>'
                    + '</div>'
                    + '<div class="flip-card-back" style="align-items:stretch; justify-content:flex-start; overflow:hidden;">'
                    + '<div style="display:flex; flex-direction:column; height:100%; width:100%; text-align:center;">'
                    + badges
                    + '<div style="font-size: 2rem; margin-bottom: 0.55rem;">💡</div>'
                    + '<div style="flex: 1 1 auto; overflow:hidden; padding:0 0.4rem;">'
                    + '<div style="padding: 0 0.5rem; font-weight:800; font-size:1.05rem; line-height:1.25; max-height: 200px; overflow:auto; word-break: break-word;">' + aText + '</div>'
                    + '</div>'
                    + actions
                    + '</div>'
                    + '</div>'
                    + '</div>'
                    + '</div>';

                container.innerHTML += cardHtml;
            });
        });
    }

    function sortValue(item, sortBy) {
        if (!item) return '';
        switch (sortBy) {
            case 'type':
                return item.type || '';
            case 'difficulty':
                return Number(item.difficulty) || 0;
            case 'question':
                return item.q || '';
            case 'answer':
                return item.a || '';
            case 'category':
            default:
                return item.category || '';
        }
    }

    function groupItems(items, groupBy) {
        if (groupBy === 'none') {
            return { '': items };
        }
        const groups = {};
        items.forEach(item => {
            let key = '';
            if (groupBy === 'type') key = item.type || 'Unbekannt';
            else if (groupBy === 'difficulty') key = formatDifficulty(item.difficulty);
            else key = item.category || 'Ohne Kategorie';
            if (!groups[key]) groups[key] = [];
            groups[key].push(item);
        });
        return groups;
    }

    function updateStats(items, totalUnique, totalRaw) {
        const stats = document.getElementById('learnStats');
        if (!stats) return;
        const shown = items.length;
        const typeCounts = countBy(items, i => i?.type || 'Unbekannt');
        const summary = Object.entries(typeCounts)
            .map(([k, v]) => escapeHtml(formatType(k)) + ': ' + v)
            .join(' · ');
        const totalLabel = Number.isFinite(totalUnique) && totalUnique > 0 ? totalUnique : totalRaw;
        const dupNote = totalRaw > totalUnique ? ' · Duplikate ausgeblendet: <strong>' + (totalRaw - totalUnique) + '</strong>' : '';
        stats.innerHTML = 'Zeige <strong>' + shown + '</strong> von <strong>' + totalLabel + '</strong> Fragen' + dupNote + (summary ? ' · ' + summary : '');
    }

    function dedupeItems(items) {
        const seen = new Set();
        const result = [];
        items.forEach(item => {
            if (!item) return;
            const key = buildDedupKey(item);
            if (seen.has(key)) return;
            seen.add(key);
            result.push(item);
        });
        return result;
    }

    function buildDedupKey(item) {
        const parts = [
            item?.type ?? '',
            item?.q ?? '',
            item?.a ?? '',
            item?.category ?? '',
            item?.difficulty ?? '',
            item?.imageUrl ?? ''
        ];
        return parts.map(p => String(p).trim().toLowerCase()).join('|');
    }

    function countBy(items, keyFn) {
        const result = {};
        items.forEach(item => {
            const key = keyFn(item);
            if (!key) return;
            result[key] = (result[key] || 0) + 1;
        });
        return result;
    }

    function openLearnModalById(id) {
        const item = (Array.isArray(learnQuestions) ? learnQuestions : []).find(q => Number(q?.id) === Number(id));
        if (!item) return;
        openLearnModal(item);
    }

    function openLearnModal(item) {
        const overlay = document.getElementById('learnModalOverlay');
        if (!overlay) return;

        const badges = document.getElementById('learnModalBadges');
        const title = document.getElementById('learnModalTitle');
        const cardContainer = document.getElementById('learnModalCardContainer');

        const typeLabel = escapeHtml(formatType(item.type));
        const categoryLabel = escapeHtml(item.category || 'Ohne Kategorie');
        const diffLabel = escapeHtml(formatDifficulty(item.difficulty));

        badges.innerHTML = ''
            + '<span class="learn-badge learn-badge--cat">' + categoryLabel + '</span>'
            + '<span class="learn-badge learn-badge--type">' + typeLabel + '</span>'
            + '<span class="learn-badge learn-badge--diff">' + diffLabel + '</span>';

        title.textContent = 'Karteikarte #' + item.id;
        const qText = escapeHtml(item.q ?? '');
        const aText = escapeHtml(item.a ?? '');
        const hasImage = item.imageUrl && String(item.imageUrl).trim() !== '';
        // Dynamic image container that flexes to fill space
        const frontImage = hasImage
            ? '<div style="flex:1; min-height:0; display:flex; align-items:center; justify-content:center; margin-top:2vh;">'
            + '<img src="' + escapeHtml(item.imageUrl) + '" loading="lazy" alt="Fragebild" style="max-width:100%; max-height:100%; border-radius:8px; box-shadow:0 0.5vh 2vh rgba(0,0,0,0.15); object-fit:contain;" />'
            + '</div>'
            : '';

        // Dynamic badges - simpler sizing
        const modalBadges = '<div class="learn-badges" style="margin-bottom:1rem;">'
            + '<span class="learn-badge learn-badge--cat" style="font-size:0.85rem;">' + categoryLabel + '</span>'
            + '<span class="learn-badge learn-badge--type" style="font-size:0.85rem;">' + typeLabel + '</span>'
            + '<span class="learn-badge learn-badge--diff" style="font-size:0.85rem;">' + diffLabel + '</span>'
            + '</div>';

        // Dynamic Card HTML - Standardized sizing
        const modalCardHtml = '<div class="flip-card-container learn-modal-flip" onclick="this.classList.toggle(\'flipped\')">'
            + '<div class="flip-card-inner">'
            // Front Side
            + '<div class="flip-card-front" style="align-items:stretch; justify-content:flex-start; overflow:hidden; padding:2rem;">'
            + '<div style="display:flex; flex-direction:column; height:100%; width:100%; text-align:center;">'
            + modalBadges
            + '<div style="font-size: 3.5rem; margin-bottom: 1rem;">❓</div>'
            + '<div style="flex: 1 1 auto; overflow:hidden; display:flex; flex-direction:column; justify-content:center;">'
            + '<div style="padding:0 0.5rem; font-weight:800; font-size:1.5rem; line-height:1.4; overflow:auto; max-height:100%; word-break: break-word;">' + qText + '</div>'
            + frontImage
            + '</div>'
            + '</div>'
            + '</div>'
            // Back Side
            + '<div class="flip-card-back" style="align-items:stretch; justify-content:flex-start; overflow:hidden; padding:2rem;">'
            + '<div style="display:flex; flex-direction:column; height:100%; width:100%; text-align:center;">'
            + modalBadges
            + '<div style="font-size: 3.5rem; margin-bottom: 1rem;">💡</div>'
            + '<div style="flex: 1 1 auto; overflow:auto; padding:0 0.5rem; display:flex; flex-direction:column; justify-content:center;">'
            + '<div style="font-weight:800; font-size:1.5rem; line-height:1.4; word-break: break-word;">' + aText + '</div>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '</div>';

        if (cardContainer) cardContainer.innerHTML = modalCardHtml;

        overlay.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeLearnModal() {
        const overlay = document.getElementById('learnModalOverlay');
        if (!overlay) return;
        overlay.style.display = 'none';
        document.body.style.overflow = '';
    }

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            const overlay = document.getElementById('learnModalOverlay');
            if (overlay && overlay.style.display === 'flex') {
                closeLearnModal();
            }
        }
    });
</script>
