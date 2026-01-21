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
        <h2 style="background: linear-gradient(to right, #ef4444, #b91c1c); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Admin Panel ðŸ”’</h2>
        <div style="font-size: 0.9rem; color: var(--text-muted);">VerwaltungsoberflÃ¤che</div>
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
            <div style="max-height: 500px; overflow-y: auto; background: white; border-radius: 8px;">
                <table style="width: 100%; border-collapse: collapse; min-width: 600px;">
                    <thead style="background: #f3f4f6; position:sticky; top:0;">
                        <tr>
                            <th style="padding:0.75rem;">ID</th>
                            <th style="padding:0.75rem;">Prompt</th>
                            <th style="padding:0.75rem;">Type</th>
                            <th style="padding:0.75rem;">Diff</th>
                            <th style="padding:0.75rem; text-align:right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="questionTableBody">
                        <tr><td colspan="5" style="text-align:center; padding:1rem;">Lade Fragen...</td></tr>
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
<div id="questionModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center; overflow-y:auto;">
    <div style="background:white; padding:2rem; border-radius:8px; width:600px; margin: 2rem 0; position:relative; max-height:90vh; overflow-y:auto;">
        <h3 id="qModalTitle">Frage erstellen</h3>
        <button onclick="closeQuestionModal()" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer; font-size:1.2rem;"></button>
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
                <label>Bild URL</label>
                <input type="text" name="imageUrl" id="qImageUrl" class="form-input" oninput="previewImage(this.value)">
                <div id="imgPreview" style="margin-top:0.5rem; max-height:100px; overflow:hidden;"></div>
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
<div id="createUserModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div style="background:white; padding:2rem; border-radius:8px; width:400px; position:relative;">
        <h3>Neuen User anlegen</h3>
        <button onclick="document.getElementById('createUserModal').style.display='none'" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer;"></button>
        <form onsubmit="handleAddUser(event)">
             <div class="form-group"><label>Username</label><input name="username" class="form-input" required></div>
             <div class="form-group"><label>Passwort</label><input type="password" name="password" class="form-input" required></div>
             <div class="form-group"><label>Role</label><select name="role" class="form-input"><option value="student">Student</option><option value="admin">Admin</option></select></div>
             <button type="submit" class="btn btn-primary" style="width:100%; margin-top:1rem;">Anlegen</button>
        </form>
    </div>
</div>

<!-- Edit User Modal -->
<div id="editUserModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div style="background:white; padding:2rem; border-radius:8px; width:400px; position:relative;">
        <h3 id="editUserTitle">User bearbeiten</h3>
        <button onclick="document.getElementById('editUserModal').style.display='none'" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer;"></button>
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
    document.addEventListener('DOMContentLoaded', () => {
        loadAdminStats();
        loadUsers();
        loadQuestions();
        loadResetRequests();
    });

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
        const tbody = document.getElementById('userTableBody');
        tbody.innerHTML = '';
        users.forEach(u => {
            const row = `
                <tr style="border-bottom: 1px solid #eee;">
                    <td style="padding:0.6rem;">${u.username} ${u.resetRequested ? '' : ''}</td>
                    <td style="padding:0.6rem;">${u.role}</td>
                    <td style="padding:0.6rem; text-align:right;">
                        <button onclick="openEditUser(${u.id}, '${u.username}', '${u.role}', ${u.resetRequested})" class="btn btn-ghost" style="font-size:0.8rem;"></button>
                        <button onclick="deleteObject('users', ${u.id})" class="btn btn-ghost" style="color:red; font-size:0.8rem;"></button>
                    </td>
                </tr>`;
            tbody.innerHTML += row;
        });
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
                     tbody.innerHTML += `
                        <tr style="border-bottom:1px solid #fecdd3;">
                            <td style="padding:0.5rem; font-weight:bold;">${u.username}</td>
                            <td style="padding:0.5rem;">${u.email || '-'}</td>
                            <td style="padding:0.5rem;">
                                <button onclick="openEditUser(${u.id}, '${u.username}', '${u.role}', true)" class="btn btn-primary" style="padding:0.2rem 0.6rem; font-size:0.8rem;">Reset</button>
                            </td>
                        </tr>
                     `;
                });
            } else {
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
            document.getElementById('createUserModal').style.display='none';
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
            document.getElementById('editUserModal').style.display='none';
            loadUsers();
            loadResetRequests();
        } catch(e) { alert(e.message); }
    }

    // --- Questions ---
    async function loadQuestions() {
        const qs = await apiCall('/admin/questions');
        const tbody = document.getElementById('questionTableBody');
        tbody.innerHTML = '';
        qs.forEach(q => {
             const row = `
                <tr style="border-bottom: 1px solid #eee;">
                    <td style="padding:0.5rem; color:grey;">${q.id}</td>
                    <td style="padding:0.5rem; max-width:200px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${q.prompt}</td>
                    <td style="padding:0.5rem;"><small style="background:#e5e7eb; padding:2px 4px; border-radius:4px;">${q.type}</small></td>
                    <td style="padding:0.5rem;">${q.difficulty}</td>
                    <td style="padding:0.5rem; text-align:right;">
                        <button onclick='openQuestionModal(\${JSON.stringify(q).replace(/'/g, "&#39;")})' class="btn btn-ghost" style="font-size:0.8rem;">✎</button>
                        <button onclick="deleteObject('questions', ${q.id})" class="btn btn-ghost" style="color:red; font-size:0.8rem;"></button>
                    </td>
                </tr>`;
             tbody.innerHTML += row;
        });
        loadAdminStats();
    }

    function openQuestionModal(q = null) {
        const modal = document.getElementById('questionModal');
        modal.style.display = 'flex';
        const f = document.getElementById('questionForm');
        f.reset();
        
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
                 // Reconstruct cloze raw? Hard. Just show instruction
                 document.getElementById('qAnswersRaw').value = "Tokens JSON edit not supported in simple mode yet.";
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
        
        // Basic parser
        const raw = f.answersRaw.value;
        const answers = raw.split(',').map(s => {
             s = s.trim();
             const isCorrect = s.startsWith('*');
             const text = isCorrect ? s.substring(1) : s;
             return { answerText: text, isCorrect: isCorrect, partialValue: isCorrect?1:0 };
        });

        const payload = {
            id: idVal ? parseInt(idVal) : 0,
            type: f.type.value,
            prompt: f.prompt.value,
            category: f.category.value,
            imageUrl: f.imageUrl.value,
            difficulty: parseInt(f.difficulty.value),
            points: parseInt(f.points.value),
            answers: answers, // only for MC/IMAGE usually
            metaJson: "{}"
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
    }

    function previewImage(url) {
        const div = document.getElementById('imgPreview');
        if(url) div.innerHTML = `<img src="${url}" style="height:100px; border-radius:4px;">`;
        else div.innerHTML = '';
    }
</script>
