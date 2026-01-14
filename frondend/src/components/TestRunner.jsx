/*
 * Datei: components/TestRunner.jsx
 * Diese Komponente führt den Test durch: Sie startet den Test, zeigt Fragen an, sammelt Antworten
 * und sendet sie an das Backend. Zusätzlich läuft ein 2-Minuten-Timer, der automatisch abschickt.
 * Verbindung: Nutzt /api/test/start und /api/test/submit (TestServlet).
 */
import React, { useEffect, useState } from 'react';
import { apiPost } from '../services/apiClient.js';

export default function TestRunner() {
  const [difficulty, setDifficulty] = useState(1);
  const [questions, setQuestions] = useState([]);
  const [message, setMessage] = useState('');
  const [answers, setAnswers] = useState({});
  const [secondsLeft, setSecondsLeft] = useState(0);

  const start = async () => {
    const data = await apiPost('/api/test/start', { difficulty, limit: 5 });
    setQuestions(data);
    setAnswers({});
    setSecondsLeft(120);
  };

  const submit = async () => {
    const questionIds = questions.map((q) => q.id);
    const attempt = await apiPost('/api/test/submit', { difficulty, questionIds, answers });
    setMessage(`Ergebnis: ${attempt.totalPoints} / ${attempt.maxPoints}`);
  };

  useEffect(() => {
    if (!secondsLeft) return;
    const timer = setInterval(() => {
      setSecondsLeft((s) => {
        if (s <= 1) {
          clearInterval(timer);
          submit().catch(() => {});
          return 0;
        }
        return s - 1;
      });
    }, 1000);
    return () => clearInterval(timer);
  }, [secondsLeft]);

  const updateMcAnswer = (questionId, optionId, checked) => {
    setAnswers((prev) => {
      const current = Array.isArray(prev[questionId]) ? prev[questionId] : [];
      const next = checked
        ? Array.from(new Set([...current, optionId]))
        : current.filter((id) => id !== optionId);
      return { ...prev, [questionId]: next };
    });
  };

  const updateClozeAnswer = (questionId, index, value) => {
    setAnswers((prev) => {
      const current = Array.isArray(prev[questionId]) ? prev[questionId] : [];
      const next = [...current];
      next[index] = value;
      return { ...prev, [questionId]: next };
    });
  };

  return (
    <div className="card">
      <h2>Test</h2>
      <label>Schwierigkeit</label>
      <select value={difficulty} onChange={(e) => setDifficulty(Number(e.target.value))}>
        <option value={1}>Leicht</option>
        <option value={2}>Mittel</option>
        <option value={3}>Schwer</option>
      </select>
      <div className="row">
        <button onClick={start}>Test starten</button>
        <button onClick={submit} disabled={!questions.length}>Test abschicken</button>
      </div>
      {secondsLeft > 0 && <p className="timer">Zeit: {secondsLeft}s</p>}
      {message && <p className="message">{message}</p>}
      <div className="question-list">
        {questions.map((q) => (
          <div key={q.id} className="question">
            <p><strong>{q.prompt}</strong></p>
            {q.type === 'MC' && Array.isArray(q.options) && (
              <div className="options">
                {q.options.map((opt) => (
                  <label key={opt.id} className="option">
                    <input
                      type="checkbox"
                      onChange={(e) => updateMcAnswer(q.id, opt.id, e.target.checked)}
                    />
                    {opt.answerText}
                  </label>
                ))}
              </div>
            )}
            {q.type === 'CLOZE' && Array.isArray(q.tokens) && (
              <div className="cloze">
                {q.tokens.map((t, idx) => (
                  <input
                    key={t.id}
                    placeholder={`Token ${idx + 1}`}
                    onChange={(e) => updateClozeAnswer(q.id, idx, e.target.value)}
                  />
                ))}
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
