/*
 * Datei: components/AdminPanel.jsx
 */
import React, { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { apiGet, apiPost, apiDelete, apiPut } from '../services/apiClient.js';

export default function AdminPanel() {
  const [questions, setQuestions] = useState([]);
  const [prompt, setPrompt] = useState('');
  const [users, setUsers] = useState([]);
  const [edit, setEdit] = useState(null);
  const [editPrompt, setEditPrompt] = useState('');
  const [editDifficulty, setEditDifficulty] = useState(1);
  const [editPoints, setEditPoints] = useState(1);
  const [activeTab, setActiveTab] = useState('questions');

  const load = async () => {
    try {
      const data = await apiGet('/api/admin/questions');
      setQuestions(Array.isArray(data) ? data : []);
      const userData = await apiGet('/api/admin/users');
      setUsers(Array.isArray(userData) ? userData : []);
    } catch(e) {
      console.error(e);
    }
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
        { answerText: 'Beispiel (Richtig)', correct: true, partialValue: 1.0 },
        { answerText: 'Beispiel (Falsch)', correct: false, partialValue: 0.0 }
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
    if(window.confirm('Benutzer wirklich löschen?')) {
        await apiDelete(`/api/admin/users?id=${id}`);
        await load();
    }
  };

  return (
    <div className="card" style={{ maxWidth: '1000px', margin: '0 auto', minHeight: '80vh' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem', borderBottom: '1px solid #e2e8f0', paddingBottom: '1rem' }}>
          <h2 style={{ margin: 0, color: 'var(--primary-dark)' }}>Admin Dashboard</h2>
          <div style={{ display: 'flex', gap: '0.5rem' }}>
              <button 
                  className={activeTab === 'questions' ? 'btn btn-primary' : 'btn btn-secondary'}
                  onClick={() => setActiveTab('questions')}
              >
                  Fragen
              </button>
              <button 
                  className={activeTab === 'users' ? 'btn btn-primary' : 'btn btn-secondary'}
                  onClick={() => setActiveTab('users')}
              >
                  Benutzer
              </button>
          </div>
      </div>

      <AnimatePresence mode="wait">
      {activeTab === 'questions' && (
        <motion.div 
            key="questions"
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: 10 }}
        >
          <div style={{ background: '#f8fafc', padding: '1.5rem', borderRadius: '8px', marginBottom: '2rem' }}>
              <h3 style={{ marginTop: 0 }}>Neue Frage erstellen</h3>
              <div style={{ display: 'flex', gap: '1rem' }}>
                  <input 
                    value={prompt} 
                    onChange={(e) => setPrompt(e.target.value)} 
                    placeholder="Fragetext eingeben..."
                    style={{ flex: 1 }}
                  />
                  <button onClick={create} disabled={!prompt} className="btn btn-primary">Anlegen</button>
              </div>
          </div>

          <h3 style={{ marginBottom: '1rem' }}>Fragenkatalog ({questions.length})</h3>
          <ul style={{ listStyle: 'none', padding: 0, display: 'grid', gap: '1rem' }}>
            {questions.map((q) => (
              <motion.li 
                key={q.id}
                layout
                style={{ 
                    background: 'white', padding: '1rem', borderRadius: '8px', 
                    border: '1px solid #e2e8f0', display: 'flex', justifyContent: 'space-between', alignItems: 'center',
                    boxShadow: '0 2px 4px rgba(0,0,0,0.05)' 
                }}
              >
                <div>
                    <span style={{ fontWeight: 'bold', display: 'block', marginBottom: '0.25rem' }}>{q.prompt}</span>
                    <div style={{ fontSize: '0.85rem', color: 'var(--text-light)' }}>
                        <span style={{ marginRight: '1rem' }}>Typ: {q.type}</span>
                        <span style={{ marginRight: '1rem' }}>Diff: {q.difficulty}</span>
                        <span>Pts: {q.points}</span>
                    </div>
                </div>
                <button className="btn btn-secondary" onClick={() => startEdit(q)}>Bearbeiten</button>
              </motion.li>
            ))}
          </ul>
        </motion.div>
      )}

      {activeTab === 'users' && (
        <motion.div
            key="users"
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: 10 }}
        >
          <h3>Registrierte Benutzer ({users.length})</h3>
          <ul style={{ listStyle: 'none', padding: 0, display: 'grid', gap: '0.5rem' }}>
            {users.map((u) => (
              <li key={u.id} style={{ 
                  display: 'flex', justifyContent: 'space-between', padding: '1rem', 
                  background: 'white', borderRadius: '8px', border: '1px solid #e2e8f0' 
              }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                    <div style={{ 
                        width: '40px', height: '40px', borderRadius: '50%', background: '#e0e7ff', 
                        display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--primary)', fontWeight: 'bold'
                    }}>
                        {u.username.substring(0, 2).toUpperCase()}
                    </div>
                    <div>
                        <div style={{ fontWeight: 600 }}>{u.username}</div>
                        <div style={{ fontSize: '0.85rem', color: 'var(--text-light)' }}>{u.role}</div>
                    </div>
                </div>
                <button 
                    className="btn btn-secondary" 
                    style={{ color: 'var(--error)', borderColor: '#fecaca', background: '#fef2f2' }}
                    onClick={() => removeUser(u.id)}
                >
                    Entfernen
                </button>
              </li>
            ))}
          </ul>
        </motion.div>
      )}
      </AnimatePresence>

      {edit && (
        <div style={{ 
            position: 'fixed', top: 0, left: 0, right: 0, bottom: 0, 
            background: 'rgba(0,0,0,0.5)', display: 'flex', justifyContent: 'center', alignItems: 'center', zIndex: 100 
        }}>
          <motion.div 
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="card" style={{ width: '500px', maxWidth: '90%' }}
          >
            <h3 style={{ marginTop: 0 }}>Frage bearbeiten</h3>
            
            <div style={{ marginBottom: '1rem' }}>
                <label style={{ display: 'block', marginBottom: '0.5rem' }}>Prompt</label>
                <input style={{ width: '100%' }} value={editPrompt} onChange={(e) => setEditPrompt(e.target.value)} />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem', marginBottom: '1rem' }}>
                <div>
                    <label style={{ display: 'block', marginBottom: '0.5rem' }}>Schwierigkeit</label>
                    <select style={{ width: '100%' }} value={editDifficulty} onChange={(e) => setEditDifficulty(Number(e.target.value))}>
                        <option value={1}>Leicht</option>
                        <option value={2}>Mittel</option>
                        <option value={3}>Schwer</option>
                    </select>
                </div>
                <div>
                    <label style={{ display: 'block', marginBottom: '0.5rem' }}>Punkte</label>
                    <input style={{ width: '100%' }} type="number" value={editPoints} onChange={(e) => setEditPoints(Number(e.target.value))} />
                </div>
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.5rem', marginTop: '1.5rem' }}>
                <button className="btn btn-secondary" onClick={() => setEdit(null)}>Abbrechen</button>
                <button className="btn btn-primary" onClick={saveEdit}>Speichern</button>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  );
}
