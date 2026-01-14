/*
 * Datei: components/AdminPanel.jsx
 * Dieses Panel ist die einfache Admin-Oberfläche. Admins können Fragen ansehen, neue Fragen anlegen
 * und Benutzer entfernen. Das UI ist bewusst minimal gehalten und kann später erweitert werden.
 * Verbindung: Nutzt /api/admin/questions und /api/admin/users.
 */
import React, { useEffect, useState } from 'react';
import { apiGet, apiPost, apiDelete, apiPut } from '../services/apiClient.js';

export default function AdminPanel() {
  const [questions, setQuestions] = useState([]);
  const [prompt, setPrompt] = useState('');
  const [users, setUsers] = useState([]);
  const [edit, setEdit] = useState(null);
  const [editPrompt, setEditPrompt] = useState('');
  const [editDifficulty, setEditDifficulty] = useState(1);
  const [editPoints, setEditPoints] = useState(1);

  const load = async () => {
    const data = await apiGet('/api/admin/questions');
    setQuestions(data);
    const userData = await apiGet('/api/admin/users');
    setUsers(userData);
  };

  useEffect(() => { load(); }, []);

  const create = async () => {
    await apiPost('/api/admin/questions', {
      type: 'MC',
      prompt,
      difficulty: 1,
      points: 1,
      metaJson: '{}',
      answers: [
        { answerText: 'Beispiel', correct: true, partialValue: 1.0 }
      ]
    });
    setPrompt('');
    await load();
  };

  const startEdit = (q) => {
    setEdit(q);
    setEditPrompt(q.prompt);
    setEditDifficulty(q.difficulty);
    setEditPoints(q.points);
  };

  const saveEdit = async () => {
    if (!edit) return;
    await apiPut('/api/admin/questions', {
      id: edit.id,
      type: edit.type,
      prompt: editPrompt,
      difficulty: editDifficulty,
      points: editPoints,
      metaJson: edit.metaJson || '{}',
      answers: edit.type === 'MC' ? (edit.options || []) : null,
      tokens: edit.type === 'CLOZE' ? (edit.tokens || []) : null
    });
    setEdit(null);
    await load();
  };

  const removeUser = async (id) => {
    await apiDelete(`/api/admin/users?id=${id}`);
    await load();
  };

  return (
    <div className="card">
      <h2>Admin</h2>
      <label>Neue Frage (Prompt)</label>
      <input value={prompt} onChange={(e) => setPrompt(e.target.value)} />
      <button onClick={create} disabled={!prompt}>Frage anlegen</button>
      <ul>
        {questions.map((q) => (
          <li key={q.id}>
            {q.prompt}
            <button onClick={() => startEdit(q)}>Bearbeiten</button>
          </li>
        ))}
      </ul>

      {edit && (
        <div className="card" style={{ marginTop: '12px' }}>
          <h3>Frage bearbeiten</h3>
          <label>Prompt</label>
          <input value={editPrompt} onChange={(e) => setEditPrompt(e.target.value)} />
          <label>Schwierigkeit</label>
          <select value={editDifficulty} onChange={(e) => setEditDifficulty(Number(e.target.value))}>
            <option value={1}>Leicht</option>
            <option value={2}>Mittel</option>
            <option value={3}>Schwer</option>
          </select>
          <label>Punkte</label>
          <input type="number" value={editPoints} onChange={(e) => setEditPoints(Number(e.target.value))} />
          <button onClick={saveEdit}>Speichern</button>
          <button onClick={() => setEdit(null)}>Abbrechen</button>
        </div>
      )}

      <h3>Users</h3>
      <ul>
        {users.map((u) => (
          <li key={u.id}>
            {u.username} ({u.role})
            <button onClick={() => removeUser(u.id)}>Löschen</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
