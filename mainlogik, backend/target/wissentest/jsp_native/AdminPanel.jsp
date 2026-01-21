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
        <h2 style="background: linear-gradient(to right, #ef4444, #b91c1c); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Admin Panel 🔒</h2>
        <div style="font-size: 0.9rem; color: var(--text-muted);">Verwaltungsoberfläche</div>
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
        <div>
            <h3>Frage hinzufügen</h3>
            <form id="addQuestionForm" onsubmit="handleAddQuestion(event)" style="background: rgba(255,255,255,0.5); padding: 1.5rem; border-radius: 1rem;">
                <div class="form-group">
                    <label>Typ</label>
                    <select name="type" class="form-input" onchange="toggleQuestionFields(this.value)">
                        <option value="MC">Multiple Choice</option>
                        <option value="CLOZE">Lückentext</option>
                        <option value="FREE">Freitext</option>
                        <option value="IMAGE">Bild-Frage</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Kategorie</label>
                    <input type="text" name="category" class="form-input" placeholder="z.B. Java, SQL..." required>
                </div>
                 <div class="form-group">
                    <label>Fragetext</label>
                    <input type="text" name="prompt" class="form-input" required>
                </div>
                 <div class="form-group" id="imageUrlGroup" style="display:none;">
                    <label>Bild URL</label>
                    <div style="display: flex; gap: 0.5rem; margin-bottom: 0.5rem;">
                        <input type="text" name="imageUrl" id="imageUrlInput" class="form-input" placeholder="http://..." oninput="debouncePreview(this.value)">
                    </div>
                    <div id="imagePreviewContainer" style="padding: 0.5rem; border: 1px dashed #ccc; border-radius: 4px; min-height: 100px; display: flex; align-items: center; justify-content: center; background: rgba(255,255,255,0.3); overflow: hidden;">
                        <span style="color: #666; font-size: 0.8rem;">Vorschau...</span>
                    </div>
                    <div id="imageValidationMsg" style="font-size: 0.8rem; margin-top: 0.2rem;"></div>
                </div>
                
                 <div class="form-group" id="answersGroup">
                    <label>Antwortoptionen (Kommagetrennt, Richtige mit *)</label>
                    <textarea name="answersRaw" class="form-input" placeholder="*Berlin, München, Hamburg" rows="3"></textarea>
                    <small style="color: grey;">Bei Freitext: Die Musterlösung.</small>
                </div>

                 <div class="form-group">
                    <label>Schwierigkeit (1-3)</label>
                    <input type="number" name="difficulty" value="1" min="1" max="3" class="form-input">
                </div>
                <div class="form-group">
                    <label>Punkte</label>
                    <input type="number" name="points" value="1" min="1" class="form-input">
                </div>

                <button type="submit" class="btn btn-primary" style="background: #ef4444; width: 100%; margin-top: 1rem;">Speichern</button>
            </form>
        </div>

        <!-- User Management List -->
        <div>
            <h3>Benutzerverwaltung</h3>
            
            <!-- User List -->
            <div style="max-height: 400px; overflow-y: auto; background: rgba(255,255,255,0.8); border-radius: 8px; margin-bottom: 2rem;">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background: rgba(0,0,0,0.05);">
                            <th style="text-align:left; padding:0.8rem;">User</th>
                            <th style="text-align:left; padding:0.8rem;">Role</th>
                            <th style="text-align:right; padding:0.8rem;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="userTableBody">
                        <tr><td colspan="3" style="padding:1rem; text-align:center;">Lade User...</td></tr>
                    </tbody>
                </table>
            </div>

            <!-- Create User Form -->
            <h3>Neuen User anlegen</h3>
            <form onsubmit="handleAddUser(event)" style="background: rgba(255,255,255,0.5); padding: 1.5rem; border-radius: 1rem;">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" class="form-input" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" class="form-input" placeholder="optional">
                </div>
                <div class="form-group">
                    <label>Passwort</label>
                    <input type="password" name="password" class="form-input" required>
                </div>
                <div class="form-group">
                    <label>Rolle</label>
                    <select name="role" class="form-input">
                        <option value="student">Student</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">User anlegen</button>
            </form>
        </div>
    </div>
</div>

<!-- Edit User Modal -->
<div id="editUserModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div style="background:white; padding:2rem; border-radius:8px; width:400px; position:relative;">
        <h3>User bearbeiten</h3>
        <button onclick="closeEditModal()" style="position:absolute; top:1rem; right:1rem; border:none; background:none; cursor:pointer; font-size:1.2rem;">✖</button>
        <form onsubmit="handleEditUser(event)">
            <input type="hidden" name="id" id="editUserId">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" id="editUsername" class="form-input">
            </div>
            <div class="form-group">
                <label>Neues Passwort (leer lassen für keine Änderung)</label>
                <input type="password" name="password" class="form-input">
            </div>
             <div class="form-group">
                <label>Rolle</label>
                <select name="role" id="editUserRole" class="form-input">
                    <option value="student">Student</option>
                    <option value="admin">Admin</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary" style="width:100%; margin-top:1rem;">Speichern</button>
        </form>
    </div>
</div>

<script>
    // Admin Logic
    document.addEventListener('DOMContentLoaded', () => {
        loadAdminStats();
        loadUsers();
    });

    async function handleAddUser(e) {
        e.preventDefault();
        const f = e.target;
        const payload = {
            username: f.username.value,
            email: f.email.value,
            password: f.password.value,
            role: f.role.value
        };
        try {
            await apiCall('/admin/users', 'POST', payload);
            alert('User erstellt!');
            f.reset();
            loadUsers();
            loadAdminStats();
        } catch(err) {
            alert('Fehler: ' + err.message);
        }
    }

    function openEditModal(id, username, role) {
        document.getElementById('editUserModal').style.display = 'flex';
        document.getElementById('editUserId').value = id;
        document.getElementById('editUsername').value = username;
        document.getElementById('editUserRole').value = role;
    }
    
    function closeEditModal() {
        document.getElementById('editUserModal').style.display = 'none';
    }

    async function handleEditUser(e) {
        e.preventDefault();
        const f = e.target;
        const payload = {
            id: parseInt(f.id.value),
            username: f.username.value,
            role: f.role.value
        };
        if(f.password.value) {
            payload.password = f.password.value;
        }

        try {
            await apiCall('/admin/users', 'PUT', payload);
            alert('User aktualisiert!');
            closeEditModal();
            loadUsers();
        } catch(err) {
            alert('Fehler: ' + err.message);
        }
    }

    async function loadAdminStats() {
        try {
            const stats = await apiCall('/admin/stats');
            document.getElementById('statUsers').innerText = stats.users || 0;
            document.getElementById('statQuestions').innerText = stats.questions || 0;
            document.getElementById('statTests').innerText = stats.attempts || 0;
        } catch(e) {
            console.log("Admin API not accessible", e);
            document.getElementById('statUsers').innerHTML = "<span style='color:red; font-size:1rem'>Zugriff verweigert</span>";
        }
    }

    async function loadUsers() {
        try {
            const users = await apiCall('/admin/users');
            const tbody = document.getElementById('userTableBody');
            tbody.innerHTML = '';
            users.forEach(u => {
                const isAdmin = u.role === 'admin';
                const row = `
                    <tr style="border-bottom: 1px solid #eee;">
                        <td style="padding:0.6rem;">\${u.username}</td>
                        <td style="padding:0.6rem;">
                            <span style="padding: 2px 8px; border-radius: 12px; background: \${isAdmin ? '#fee2e2' : '#e5e7eb'}; color: \${isAdmin ? '#991b1b' : '#374151'}; font-size: 0.8rem; font-weight: bold;">
                                \${u.role}
                            </span>
                        </td>
                        <td style="padding:0.6rem; text-align:right;">
                           <button onclick="openEditModal(\${u.id}, '\${u.username}', '\${u.role}')" class="btn btn-ghost" style="padding: 0.2rem 0.5rem; font-size: 0.8rem; margin-right: 0.5rem;">✎</button>
                           <button onclick="deleteUser(\${u.id})" class="btn btn-ghost" style="color:red; padding: 0.2rem 0.5rem; font-size: 0.8rem;">✖</button>
                        </td>
                    </tr>
                `;
                tbody.innerHTML += row;
            });
        } catch(e) { console.error(e); }
    }

    async function deleteUser(id) {
        if(!confirm('User wirklich löschen?')) return;
        await apiCall('/admin/users?id=' + id, 'DELETE');
        loadUsers();
        loadAdminStats();
    }

    async function toggleRole(id, currentRole) {
        const newRole = currentRole === 'admin' ? 'student' : 'admin';
        await apiCall('/admin/users?id=' + id + '&role=' + newRole, 'PUT');
        loadUsers();
    }

    async function handleAddQuestion(e) {
        e.preventDefault();
        const f = e.target;
        
        // Parse answers
        const rawAnswers = f.answersRaw.value.split(',').map(s => s.trim()).filter(s => s);
        const answers = [];
        
        rawAnswers.forEach(str => {
             let isCorrect = str.startsWith('*') || f.type.value === 'FREE';
             let text = str.startsWith('*') ? str.substring(1) : str;
             answers.push({ answerText: text, isCorrect: isCorrect, partialValue: isCorrect ? 1.0 : 0.0 });
        });

        const payload = {
            type: f.type.value,
            prompt: f.prompt.value,
            category: f.category.value,
            imageUrl: f.imageUrl.value,
            difficulty: parseInt(f.difficulty.value),
            points: parseInt(f.points.value),
            answers: answers,
            tokens: [] // TODO: Add Cloze UI logic
        };
        
        try {
            await apiCall('/admin/questions', 'POST', payload);
            alert("Frage erfolgreich gespeichert!");
            f.reset();
            loadAdminStats();
        } catch(err) {
            alert("Fehler: " + err.message);
        }
    }

    function toggleQuestionFields(type) {
        const imgGroup = document.getElementById('imageUrlGroup');
        if (type === 'IMAGE') {
            imgGroup.style.display = 'block';
        } else {
            imgGroup.style.display = 'none';
        }
    }

    let imageDebounceTimer;
    function debouncePreview(url) {
        clearTimeout(imageDebounceTimer);
        imageDebounceTimer = setTimeout(() => previewImage(url), 500);
    }

    function previewImage(url) {
        const container = document.getElementById('imagePreviewContainer');
        const msg = document.getElementById('imageValidationMsg');
        
        if (!url || url.length < 5) {
            container.innerHTML = '<span style="color: #666; font-size: 0.8rem;">Kein Bild geladen</span>';
            msg.innerText = "";
            return;
        }

        container.innerHTML = '<span>Lade...</span>';
        msg.innerText = "Prüfe Bild...";
        msg.style.color = "blue";

        const img = new Image();
        img.onload = function() {
            container.innerHTML = '';
            img.style.maxWidth = '100%';
            img.style.maxHeight = '200px';
            img.style.borderRadius = '4px';
            container.appendChild(img);
            msg.innerText = "✓ Bild gültig";
            msg.style.color = "green";
        };
        img.onerror = function() {
            container.innerHTML = '<span style="color: red;">Bild konnte nicht geladen werden</span>';
            msg.innerText = "⚠ Ungültige URL oder Format";
            msg.style.color = "red";
        };
        img.src = url;
    }
</script>
