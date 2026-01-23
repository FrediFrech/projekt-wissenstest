<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
   /* 
    * Component: AdminPanel.jsp
    * Counterpart: AdminPanel.jsx
    * Description: Administration dashboard for managing questions and users.
    */
%>
<div class="glass-card animate-fade-in" style="max-width: 1000px; margin: 2rem auto;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2 style="background: linear-gradient(to right, #ef4444, #b91c1c); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Admin Panel &#128274;</h2>
            <div style="font-size: 0.9rem; color: var(--text-muted);">Verwaltungsoberfl&auml;che</div>
    </div>

    <div class="glass-card" style="background: #fff7ed; border-left: 4px solid #f97316; margin-bottom: 2rem;">
        <h3 style="margin-bottom: 0.5rem;">Kurz-Anleitung f&uuml;r Admins</h3>
        <ul style="color: #7c2d12; line-height: 1.6; padding-left: 1.2rem;">
            <li>Fragen erstellen: Typ w&auml;hlen, Kategorie + Prompt setzen, Antworten konfigurieren.</li>
            <li>MC/IMAGE: * markiert richtige Antworten (z. B. <code>*Richtig, Falsch</code>).</li>
            <li>Freitext: Mehrere L&ouml;sungen per Komma oder neue Zeile (alle gelten als korrekt).</li>
            <li>L&uuml;ckentext: JSON-Array verwenden, z. B. <code>[ ["Sequenz","Sequenzdiagramm"], ["Zeit"] ]</code>.</li>
            <li>Bild-Frage: Datei per Drag & Drop oder Dateiauswahl hochladen.</li>
        </ul>
    </div>

    <!-- Stats Row -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-bottom: 3rem;">
        <div class="glass-card" style="background: white; border-left: 4px solid #ef4444;">
            <h3>Total Users</h3>
            <div id="statUsers" style="font-size: 2rem; color: #1f2937;">-</div>
        </div>
        <div class="glass-card" style="background: white; border-left: 4px solid #f59e0b;">
            <h3>Total Questions</h3>
            <div id="statQuestions" style="font-size: 2rem; color: #1f2937;">-</div>
        </div>
        <div class="glass-card" style="background: white; border-left: 4px solid #3b82f6;">
            <h3>Completed Tests</h3>
            <div id="statTests" style="font-size: 2rem; color: #1f2937;">-</div>
        </div>
    </div>

    <!-- Actions -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
        <!-- Question Management -->
    <!-- Actions -->
    <div style="display: flex; flex-direction: column; gap: 3rem;">
        
        <!-- Password Reset Requests -->
        <div id="pwResetSection" style="display:none;" class="animate-fade-in">
             <div class="glass-card" style="background: #fff1f2; border: 1px solid #fecdd3;">
                <h3 style="color:#be123c; margin-bottom:1rem;"> Passwort-Reset Anfragen</h3>
                <table style="width:100%; text-align:left;">
                    <thead><tr><th>Username</th><th>Email</th><th>Action</th></tr></thead>
                    <tbody id="pwResetBody"></tbody>
                </table>
             </div>
        </div>

        <!-- Question Management -->
        <div>
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
                <h3>Fragenkatalog</h3>
                <button onclick="openQuestionModal()" class="btn btn-primary" style="background:#ef4444;"> Frage erstellen</button>
            </div>
            <div class="glass-card" style="background:#f8fafc; padding:1rem; margin-bottom:1rem;">
                <div style="display:grid; grid-template-columns: 2fr 1fr 1fr 1fr 1fr; gap:0.75rem; align-items:end;">
                    <div>
                        <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.35rem;">Filter (Wildcard *)</label>
                        <input id="questionFilter" class="form-input" placeholder="Prompt/Kategorie z. B. *uml*">
                    </div>
                    <div>
                        <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.35rem;">Typ</label>
                        <select id="questionTypeFilter" class="form-input">
                            <option value="">Alle</option>
                            <option value="MC">MC</option>
                            <option value="CLOZE">CLOZE</option>
                            <option value="FREE">FREE</option>
                            <option value="IMAGE">IMAGE</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.35rem;">Schwierigkeit</label>
                        <select id="questionDiffFilter" class="form-input">
                            <option value="">Alle</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.35rem;">Sortieren nach</label>
                        <select id="questionSort" class="form-input">
                            <option value="id">ID</option>
                            <option value="prompt">Prompt</option>
                            <option value="category">Kategorie</option>
                            <option value="type">Typ</option>
                            <option value="difficulty">Schwierigkeit</option>
                            <option value="options">Optionen</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.35rem;">Richtung</label>
                        <select id="questionSortDir" class="form-input">
                            <option value="asc">Aufsteigend</option>
                            <option value="desc">Absteigend</option>
                        </select>
                    </div>
                </div>
            </div>
            <div style="max-height: 500px; overflow-y: auto; background: white; border-radius: 8px;">
                <table style="width: 100%; border-collapse: collapse; min-width: 600px;">
                    <thead style="background: #f3f4f6; position:sticky; top:0;">
                        <tr>
                            <th style="padding:0.75rem;">ID</th>
                            <th style="padding:0.75rem;">Prompt</th>
                            <th style="padding:0.75rem;">Type</th>
                            <th style="padding:0.75rem;">Diff</th>
                            <th style="padding:0.75rem;">Optionen</th>
                            <th style="padding:0.75rem; text-align:right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="questionTableBody">
                        <tr><td colspan="6" style="text-align:center; padding:1rem;">Lade Fragen...</td></tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- User Management -->
        <div>
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
                 <h3>Benutzerverwaltung</h3>
                 <button onclick="document.getElementById('createUserModal').style.display='flex'" class="btn btn-ghost">Create User</button>
            </div>
            <div class="glass-card" style="background:#f8fafc; padding:1rem; margin-bottom:1rem;">
                <div style="display:grid; grid-template-columns: 2fr 1fr 1fr; gap:0.75rem; align-items:end;">
                    <div>
                        <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.35rem;">User Filter (Wildcard *)</label>
                        <input id="userFilter" class="form-input" placeholder="z. B. *student*">
                    </div>
                    <div>
                        <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.35rem;">Rolle</label>
                        <select id="userRoleFilter" class="form-input">
                            <option value="">Alle</option>
                            <option value="student">student</option>
                            <option value="admin">admin</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-size:0.8rem; font-weight:bold; display:block; margin-bottom:0.35rem;">Sortieren nach</label>
                        <select id="userSort" class="form-input">
                            <option value="username">Username</option>
                            <option value="role">Role</option>
                            <option value="id">ID</option>
                        </select>
                    </div>
                </div>
            </div>
            <div style="max-height: 400px; overflow-y: auto; background: white; border-radius: 8px;">
                 <table style="width: 100%; border-collapse: collapse;">
                    <thead style="background: #f3f4f6; position:sticky; top:0;">
                        <tr>
                            <th style="padding:0.75rem;">User</th>
                            <th style="padding:0.75rem;">Role</th>
                            <th style="padding:0.75rem; text-align:right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="userTableBody"></tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modals -->
<!-- Question Modal -->
<div id="questionModal" onclick="if(event.target === this) closeQuestionModal()" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center; overflow-y:auto;">
    <div style="background:white; padding:2rem; border-radius:8px; width:600px; margin: 2rem 0; position:relative; max-height:90vh; overflow-y:auto;">
        <h3 id="qModalTitle">Frage erstellen</h3>
        <button onclick="closeQuestionModal()" aria-label="Modal schlie&szlig;en" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer; font-size:1.4rem;">&times;</button>
        <form onsubmit="handleSaveQuestion(event)" id="questionForm">
            <input type="hidden" name="id" id="qId">
            <div class="form-group">
                <label>Typ</label>
                <select name="type" id="qType" class="form-input" onchange="toggleQuestionFields(this.value)">
                    <option value="MC">Multiple Choice</option>
                    <option value="CLOZE">Lückentext</option>
                    <option value="FREE">Freitext</option>
                    <option value="IMAGE">Bild-Frage</option>
                </select>
            </div>
            <div class="form-group">
                <label>Kategorie</label>
                <input type="text" name="category" id="qCategory" class="form-input" required>
            </div>
            <div class="form-group">
                <label>Fragetext (Prompt)</label>
                <textarea name="prompt" id="qPrompt" class="form-input" rows="2" required></textarea>
            </div>
            <div class="form-group" id="imageUrlGroup" style="display:none;">
                <label>Bild (Upload oder URL)</label>
                <div id="imageDropZone" style="border:2px dashed #cbd5f5; border-radius:8px; padding:1rem; text-align:center; color:#64748b; margin-bottom:0.75rem;">
                    <strong>Drag & Drop</strong> oder <button type="button" class="btn btn-ghost" onclick="document.getElementById('qImageFile').click()">Datei ausw&auml;hlen</button>
                    <input type="file" id="qImageFile" accept="image/*" style="display:none" onchange="handleImageFileChange(event)">
                </div>
                <input type="text" name="imageUrl" id="qImageUrl" class="form-input" placeholder="Optional: Bild-URL" oninput="previewImage(this.value)">
                <div id="imgPreview" style="margin-top:0.5rem; max-height:140px; overflow:hidden;"></div>
            </div>
            <div class="form-group">
                 <label>Antworten / Config (JSON)</label>
                 <small style="display:block; color:gray;" id="qConfigHelp">Bei MC: Kommagetrennt (Richtig*). Bei Cloze: Tokens.</small>
                 <textarea name="answersRaw" id="qAnswersRaw" class="form-input" rows="3" placeholder="*Richtig, Falsch 1, Falsch 2"></textarea>
            </div>
             <div class="form-group" style="display:grid; grid-template-columns: 1fr 1fr; gap:1rem;">
                <div>
                    <label>Diff (1-3)</label>
                    <input type="number" name="difficulty" id="qDiff" value="1" min="1" max="3" class="form-input">
                </div>
                <div>
                     <label>Punkte</label>
                    <input type="number" name="points" id="qPoints" value="1" min="1" class="form-input">
                </div>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%; margin-top:1rem;">Speichern</button>
        </form>
    </div>
</div>

<!-- Create User Modal -->
<div id="createUserModal" onclick="if(event.target === this) closeCreateUserModal()" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div style="background:white; padding:2rem; border-radius:8px; width:400px; position:relative;">
        <h3>Neuen User anlegen</h3>
        <button onclick="closeCreateUserModal()" aria-label="Modal schlie&szlig;en" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer; font-size:1.4rem;">&times;</button>
        <form onsubmit="handleAddUser(event)">
             <div class="form-group"><label>Username</label><input name="username" class="form-input" required></div>
             <div class="form-group"><label>Passwort</label><input type="password" name="password" class="form-input" required></div>
             <div class="form-group"><label>Role</label><select name="role" class="form-input"><option value="student">Student</option><option value="admin">Admin</option></select></div>
             <button type="submit" class="btn btn-primary" style="width:100%; margin-top:1rem;">Anlegen</button>
        </form>
    </div>
</div>

<!-- Edit User Modal -->
<div id="editUserModal" onclick="if(event.target === this) closeEditUserModal()" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div style="background:white; padding:2rem; border-radius:8px; width:400px; position:relative;">
        <h3 id="editUserTitle">User bearbeiten</h3>
        <button onclick="closeEditUserModal()" aria-label="Modal schlie&szlig;en" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer; font-size:1.4rem;">&times;</button>
        <form onsubmit="handleEditUser(event)">
            <input type="hidden" name="id" id="editUserId">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" id="editUsername" class="form-input">
            </div>
            <div class="form-group">
                <label>Neues Passwort</label>
                <input type="password" name="password" id="editPassword" class="form-input" placeholder="Leer lassen = unverändert">
            </div>
             <div class="form-group">
                <label>Rolle</label>
                <select name="role" id="editUserRole" class="form-input">
                    <option value="student">Student</option>
                    <option value="admin">Admin</option>
                </select>
            </div>
            <div style="margin-top:1rem;">
                <label style="display:flex; align-items:center; gap:0.5rem; cursor:pointer;">
                    <input type="checkbox" name="resetComplete" id="editResetComplete">
                    <span style="font-size:0.9rem;">Passwort-Reset als erledigt markieren</span>
                </label>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%; margin-top:1rem;">Speichern</button>
        </form>
    </div>
</div>

<script>
    let adminUsers = [];
    let adminQuestions = [];

    document.addEventListener('DOMContentLoaded', () => {
        loadAdminStats();
        loadUsers();
        loadQuestions();
        loadResetRequests();
        setupImageDropZone();
        setupAdminFilters();
    });

    function setupAdminFilters() {
        const questionFilter = document.getElementById('questionFilter');
        const questionTypeFilter = document.getElementById('questionTypeFilter');
        const questionDiffFilter = document.getElementById('questionDiffFilter');
        const questionSort = document.getElementById('questionSort');
        const questionSortDir = document.getElementById('questionSortDir');
        const applyQuestionChange = () => renderQuestionTable(applyQuestionFilters(adminQuestions));
        [questionFilter, questionTypeFilter, questionDiffFilter, questionSort, questionSortDir].forEach(el => {
            if (!el) return;
            el.addEventListener('input', applyQuestionChange);
            el.addEventListener('change', applyQuestionChange);
        });

        const userFilter = document.getElementById('userFilter');
        const userRoleFilter = document.getElementById('userRoleFilter');
        const userSort = document.getElementById('userSort');
        const applyUserChange = () => renderUserTable(applyUserFilters(adminUsers));
        [userFilter, userRoleFilter, userSort].forEach(el => {
            if (!el) return;
            el.addEventListener('input', applyUserChange);
            el.addEventListener('change', applyUserChange);
        });
    }

    // --- Stats ---
    async function loadAdminStats() {
        try {
            const stats = await apiCall('/admin/stats');
            if(document.getElementById('statUsers')) {
                document.getElementById('statUsers').innerText = stats.users || 0;
                document.getElementById('statQuestions').innerText = stats.questions || 0;
                document.getElementById('statTests').innerText = stats.attempts || 0;
            }
        } catch(e) {}
    }

    // --- Users ---
    async function loadUsers() {
        const users = await apiCall('/admin/users');
        adminUsers = Array.isArray(users) ? users : [];
        renderUserTable(applyUserFilters(adminUsers));
    }

    async function loadResetRequests() {
        try {
            const reqs = await apiCall('/admin/users/requests');
            const section = document.getElementById('pwResetSection');
            const tbody = document.getElementById('pwResetBody');
            
            if (reqs && reqs.length > 0) {
                section.style.display = 'block';
                tbody.innerHTML = '';
                reqs.forEach(u => {
                     const row = document.createElement('tr');
                     row.style.borderBottom = '1px solid #fecdd3';
                     row.innerHTML = `
                         <td style="padding:0.5rem; font-weight:bold;">\${u.username}</td>
                         <td style="padding:0.5rem;">\${u.email || '-'}</td>
                         <td style="padding:0.5rem;">
                             <button class="btn btn-primary" style="padding:0.2rem 0.6rem; font-size:0.8rem;">Reset</button>
                         </td>
                     `;
                     const resetBtn = row.querySelector('button');
                     resetBtn.onclick = () => openEditUser(u.id, u.username, u.role, true);
                     tbody.appendChild(row);
                });
            } else {
                tbody.innerHTML = '';
                section.style.display = 'none';
            }
        } catch(e) { console.error(e); }
    }

    async function handleAddUser(e) {
        e.preventDefault();
        const f = e.target;
        try {
            await apiCall('/admin/users', 'POST', {
                username: f.username.value,
                password: f.password.value,
                role: f.role.value
            });
            alert('User erstellt');
            f.reset();
            closeCreateUserModal();
            loadUsers();
            loadAdminStats();
        } catch(e) { alert(e.message); }
    }

    function openEditUser(id, name, role, isReset) {
        document.getElementById('editUserModal').style.display='flex';
        document.getElementById('editUserId').value = id;
        document.getElementById('editUsername').value = name;
        document.getElementById('editPassword').value = '';
        document.getElementById('editUserRole').value = role;
        document.getElementById('editResetComplete').checked = isReset;
    }

    async function handleEditUser(e) {
        e.preventDefault();
        const f = e.target;
        try {
            const payload = {
                id: parseInt(f.id.value),
                username: f.username.value,
                role: f.role.value,
                resetComplete: f.resetComplete.checked
            };
            if(f.password.value) payload.password = f.password.value;
            
            await apiCall('/admin/users', 'PUT', payload);
            alert('Gespeichert');
            closeEditUserModal();
            loadUsers();
            loadResetRequests();
        } catch(e) { alert(e.message); }
    }

    // --- Questions ---
    async function loadQuestions() {
        const qs = await apiCall('/admin/questions');
        adminQuestions = Array.isArray(qs) ? qs : [];
        renderQuestionTable(applyQuestionFilters(adminQuestions));
        loadAdminStats();
    }

    function renderUserTable(users) {
        const tbody = document.getElementById('userTableBody');
        if (!tbody) return;
        tbody.innerHTML = '';
        if (!users || users.length === 0) {
            tbody.innerHTML = '<tr><td colspan="3" style="text-align:center; padding:1rem;">Keine Benutzer gefunden.</td></tr>';
            return;
        }
        users.forEach(u => {
            const row = document.createElement('tr');
            row.style.borderBottom = '1px solid #eee';
            row.innerHTML = `
                <td style="padding:0.6rem;">\${u.username} \${u.resetRequested ? '🔑' : ''}</td>
                <td style="padding:0.6rem;">\${u.role}</td>
                <td style="padding:0.6rem; text-align:right;">
                    <button class="btn btn-ghost" style="font-size:0.8rem;">✎</button>
                    <button class="btn btn-ghost" style="color:red; font-size:0.8rem;">🗑</button>
                </td>
            `;
            const editBtn = row.querySelector('button:first-of-type');
            editBtn.onclick = () => openEditUser(u.id, u.username, u.role, u.resetRequested);
            const delBtn = row.querySelector('button:last-of-type');
            delBtn.onclick = () => deleteObject('users', u.id);
            tbody.appendChild(row);
        });
    }

    function renderQuestionTable(questions) {
        const tbody = document.getElementById('questionTableBody');
        if (!tbody) return;
        tbody.innerHTML = '';
        if (!questions || questions.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:1rem;">Keine Fragen gefunden.</td></tr>';
            return;
        }
        questions.forEach(q => {
             const row = document.createElement('tr');
             row.style.borderBottom = '1px solid #eee';
             const optionCount = getOptionCount(q);
             row.innerHTML = `
                 <td style="padding:0.5rem; color:grey;">\${q.id}</td>
                 <td style="padding:0.5rem; max-width:200px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">\${q.prompt}</td>
                 <td style="padding:0.5rem;"><small style="background:#e5e7eb; padding:2px 4px; border-radius:4px;">\${q.type}</small></td>
                 <td style="padding:0.5rem;">\${q.difficulty}</td>
                 <td style="padding:0.5rem;">\${optionCount}</td>
                 <td style="padding:0.5rem; text-align:right;">
                     <button class="btn btn-ghost" style="font-size:0.8rem;">✎</button>
                     <button class="btn btn-ghost" style="color:red; font-size:0.8rem;">🗑</button>
                 </td>
             `;
             const editBtn = row.querySelector('button:first-of-type');
             editBtn.onclick = () => openQuestionModal(q);
             const delBtn = row.querySelector('button:last-of-type');
             delBtn.onclick = () => deleteObject('questions', q.id);
             tbody.appendChild(row);
        });
    }

    function applyUserFilters(users) {
        let result = Array.isArray(users) ? [...users] : [];
        const filterValue = (document.getElementById('userFilter')?.value || '').trim();
        const roleValue = document.getElementById('userRoleFilter')?.value || '';
        const sortValue = document.getElementById('userSort')?.value || 'username';

        if (filterValue) {
            result = result.filter(u => matchesWildcard(u.username || '', filterValue));
        }
        if (roleValue) {
            result = result.filter(u => String(u.role) === roleValue);
        }

        result.sort((a, b) => compareUsers(a, b, sortValue));
        return result;
    }

    function applyQuestionFilters(questions) {
        let result = Array.isArray(questions) ? [...questions] : [];
        const filterValue = (document.getElementById('questionFilter')?.value || '').trim();
        const typeValue = document.getElementById('questionTypeFilter')?.value || '';
        const diffValue = document.getElementById('questionDiffFilter')?.value || '';
        const sortValue = document.getElementById('questionSort')?.value || 'id';
        const sortDir = document.getElementById('questionSortDir')?.value || 'asc';

        if (filterValue) {
            result = result.filter(q => {
                const haystack = `\${q.prompt || ''} \${q.category || ''}`;
                return matchesWildcard(haystack, filterValue);
            });
        }
        if (typeValue) {
            result = result.filter(q => String(q.type) === typeValue);
        }
        if (diffValue) {
            result = result.filter(q => String(q.difficulty) === diffValue);
        }

        result.sort((a, b) => compareQuestions(a, b, sortValue, sortDir));
        return result;
    }

    function matchesWildcard(value, pattern) {
        const needle = String(pattern || '').trim().toLowerCase();
        if (!needle) return true;
        const hay = String(value || '').toLowerCase();
        if (!needle.includes('*')) {
            return hay.includes(needle);
        }
        let escaped = needle.replace(/[.*+?^$()|[\]\\]/g, '\\$&');
        escaped = escaped.replace(/[{}]/g, '\\$&');
        const regexPattern = '^' + escaped.replace(/\*/g, '.*') + '$';
        const regex = new RegExp(regexPattern, 'i');
        return regex.test(hay);
    }

    function compareUsers(a, b, field) {
        if (field === 'id') {
            return compareNumbers(a.id, b.id, 'asc');
        }
        if (field === 'role') {
            return compareStrings(a.role || '', b.role || '', 'asc');
        }
        return compareStrings(a.username || '', b.username || '', 'asc');
    }

    function compareQuestions(a, b, field, dir) {
        switch (field) {
            case 'prompt':
                return compareStrings(a.prompt || '', b.prompt || '', dir);
            case 'category':
                return compareStrings(a.category || '', b.category || '', dir);
            case 'type':
                return compareStrings(a.type || '', b.type || '', dir);
            case 'difficulty':
                return compareNumbers(a.difficulty, b.difficulty, dir);
            case 'options':
                return compareNumbers(getOptionCount(a), getOptionCount(b), dir);
            default:
                return compareNumbers(a.id, b.id, dir);
        }
    }

    function compareStrings(a, b, dir) {
        const direction = dir === 'desc' ? -1 : 1;
        return a.localeCompare(b, 'de', { sensitivity: 'base' }) * direction;
    }

    function compareNumbers(a, b, dir) {
        const valA = Number.isFinite(Number(a)) ? Number(a) : 0;
        const valB = Number.isFinite(Number(b)) ? Number(b) : 0;
        if (valA === valB) return 0;
        if (dir === 'desc') return valA < valB ? 1 : -1;
        return valA < valB ? -1 : 1;
    }

    function getOptionCount(q) {
        if (q && Array.isArray(q.options)) return q.options.length;
        if (q && Array.isArray(q.tokens)) return q.tokens.length;
        return 0;
    }

    function openQuestionModal(q = null) {
        const modal = document.getElementById('questionModal');
        modal.style.display = 'flex';
        const f = document.getElementById('questionForm');
        f.reset();
        document.getElementById('imgPreview').innerHTML = '';
        document.getElementById('qImageFile').value = '';
        
        if (q) {
            document.getElementById('qModalTitle').innerText = 'Frage bearbeiten';
            document.getElementById('qId').value = q.id;
            document.getElementById('qType').value = q.type;
            document.getElementById('qCategory').value = q.category || '';
            document.getElementById('qPrompt').value = q.prompt;
            document.getElementById('qDiff').value = q.difficulty;
            document.getElementById('qPoints').value = q.points;
            
            toggleQuestionFields(q.type);
            if(q.imageUrl) {
                 document.getElementById('qImageUrl').value = q.imageUrl;
                 previewImage(q.imageUrl);
            }

            // Populate answers raw
            if (q.type === 'MC' || q.type === 'IMAGE' || q.type === 'FREE') {
                 if(q.options) {
                     const texts = q.options.map(o => (o.correct ? '*' : '') + o.answerText);
                     document.getElementById('qAnswersRaw').value = texts.join(', ');
                 }
            } else if (q.type === 'CLOZE' && q.tokens) {
                 let alternatives = null;
                 try {
                     const meta = q.metaJson ? JSON.parse(q.metaJson) : null;
                     alternatives = meta && Array.isArray(meta.clozeAlternatives) ? meta.clozeAlternatives : null;
                 } catch (e) {
                     alternatives = null;
                 }
                 if (alternatives && alternatives.length > 0) {
                     document.getElementById('qAnswersRaw').value = JSON.stringify(alternatives);
                 } else {
                     const base = q.tokens.sort((a,b) => a.tokenIndex - b.tokenIndex).map(t => t.expectedText);
                     document.getElementById('qAnswersRaw').value = JSON.stringify(base);
                 }
            }

        } else {
            document.getElementById('qModalTitle').innerText = 'Neue Frage';
            document.getElementById('qId').value = '';
            toggleQuestionFields('MC');
        }
    }
    
    function closeQuestionModal() {
        document.getElementById('questionModal').style.display='none';
    }

    async function handleSaveQuestion(e) {
        e.preventDefault();
        const f = e.target;
        const idVal = f.id.value;
        const method = idVal ? 'PUT' : 'POST';
        const type = f.type.value;
        const raw = f.answersRaw.value || '';

        let answers = null;
        let tokens = null;
        let metaJson = '{}';

        if (type === 'CLOZE') {
            let parsed = null;
            const trimmed = raw.trim();
            if (trimmed.startsWith('[')) {
                try {
                    parsed = JSON.parse(trimmed);
                } catch (e) {
                    alert('Ung&uuml;ltiges JSON f&uuml;r L&uuml;ckentext.');
                    return;
                }
            }
            if (!parsed) {
                parsed = trimmed.split(/,|\n/).map(s => s.trim()).filter(Boolean);
            }
            if (!Array.isArray(parsed) || parsed.length === 0) {
                alert('Bitte L&uuml;cken-L&ouml;sungen angeben.');
                return;
            }

            const alternatives = parsed.map(entry => {
                if (Array.isArray(entry)) {
                    return entry.map(v => String(v).trim()).filter(Boolean);
                }
                return [String(entry).trim()];
            }).filter(arr => arr.length > 0);
            if (alternatives.length === 0) {
                alert('Bitte g\u00fcltige L\u00f6sungen angeben.');
                return;
            }
            tokens = alternatives.map((opts, idx) => ({
                tokenIndex: idx,
                expectedText: opts[0] || '',
                partialValue: 1
            }));
            metaJson = JSON.stringify({ clozeAlternatives: alternatives });
        } else if (type === 'FREE') {
            const entries = raw.split(/,|\n/).map(s => s.trim()).filter(Boolean);
            if (entries.length === 0) {
                alert('Bitte mindestens eine L&ouml;sung angeben.');
                return;
            }
            answers = entries.map(text => ({ answerText: text, isCorrect: true, partialValue: 1 }));
        } else {
            const entries = raw.split(/,|\n/).map(s => s.trim()).filter(Boolean);
            if (entries.length === 0) {
                alert('Bitte Antworten angeben.');
                return;
            }
            answers = entries.map(s => {
                const isCorrect = s.startsWith('*');
                const text = isCorrect ? s.substring(1) : s;
                return { answerText: text.trim(), isCorrect: isCorrect, partialValue: isCorrect ? 1 : 0 };
            });
            if (!answers.some(a => a.isCorrect)) {
                alert('Bitte mindestens eine richtige Antwort mit * markieren.');
                return;
            }
        }

        const payload = {
            id: idVal ? parseInt(idVal) : 0,
            type: type,
            prompt: f.prompt.value,
            category: f.category.value,
            imageUrl: f.imageUrl.value || null,
            difficulty: parseInt(f.difficulty.value),
            points: parseInt(f.points.value),
            answers: answers,
            tokens: tokens,
            metaJson: metaJson
        };

        try {
            await apiCall('/admin/questions', method, payload);
            alert('Gespeichert');
            closeQuestionModal();
            loadQuestions();
        } catch(e) { alert(e.message); }
    }

    // --- Shared ---
    async function deleteObject(endpoint, id) {
        if(!confirm('Wirklich löschen?')) return;
        try {
            await apiCall('/admin/' + endpoint + '?id=' + id, 'DELETE');
            if(endpoint === 'users') loadUsers();
            else loadQuestions();
        } catch(e) { alert(e.message); }
    }

    function toggleQuestionFields(type) {
        document.getElementById('imageUrlGroup').style.display = (type === 'IMAGE') ? 'block' : 'none';
        const help = document.getElementById('qConfigHelp');
        const input = document.getElementById('qAnswersRaw');
        if (type === 'CLOZE') {
            help.innerHTML = 'L&uuml;ckentext als JSON-Array. Beispiel: <code>[["Sequenz","Sequenzdiagramm"],["Zeit"]]</code>.';
            input.placeholder = '[["Antwort 1","Variante"],["Antwort 2"]]';
        } else if (type === 'FREE') {
            help.innerHTML = 'Freitext: Mehrere L&ouml;sungen per Komma oder neue Zeile.';
            input.placeholder = 'L&ouml;sung A, L&ouml;sung B';
        } else {
            help.innerHTML = 'Bei MC/IMAGE: Kommagetrennt (Richtig*).';
            input.placeholder = '*Richtig, Falsch 1, Falsch 2';
        }
    }

    function previewImage(url) {
        const div = document.getElementById('imgPreview');
        if(url) div.innerHTML = `<img src="\${url}" style="height:100px; border-radius:4px;">`;
        else div.innerHTML = '';
    }

    function closeCreateUserModal() {
        document.getElementById('createUserModal').style.display = 'none';
    }

    function closeEditUserModal() {
        document.getElementById('editUserModal').style.display = 'none';
    }

    function setupImageDropZone() {
        const dropZone = document.getElementById('imageDropZone');
        if (!dropZone) return;
        dropZone.addEventListener('dragover', (e) => {
            e.preventDefault();
            dropZone.style.borderColor = '#6366f1';
            dropZone.style.background = '#eef2ff';
        });
        dropZone.addEventListener('dragleave', () => {
            dropZone.style.borderColor = '#cbd5f5';
            dropZone.style.background = 'transparent';
        });
        dropZone.addEventListener('drop', (e) => {
            e.preventDefault();
            dropZone.style.borderColor = '#cbd5f5';
            dropZone.style.background = 'transparent';
            const file = e.dataTransfer.files[0];
            if (file) uploadQuestionImage(file);
        });
    }

    function handleImageFileChange(e) {
        const file = e.target.files && e.target.files[0];
        if (file) uploadQuestionImage(file);
    }

    async function uploadQuestionImage(file) {
        if (!file.type.startsWith('image/')) {
            alert('Bitte eine Bilddatei ausw&auml;hlen.');
            return;
        }
        const formData = new FormData();
        formData.append('file', file);
        try {
            const resp = await fetch('api/admin/images', {
                method: 'POST',
                body: formData,
                credentials: 'same-origin'
            });
            if (!resp.ok) {
                throw new Error('Upload fehlgeschlagen');
            }
            const data = await resp.json();
            if (data && data.url) {
                document.getElementById('qImageUrl').value = data.url;
                previewImage(data.url);
            }
        } catch (e) {
            alert('Bild-Upload fehlgeschlagen');
        }
    }
</script>
