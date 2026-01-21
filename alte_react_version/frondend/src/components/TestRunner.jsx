/*
 * Datei: components/TestRunner.jsx
 */
import React, { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { apiPost } from '../services/apiClient.js';

export default function TestRunner() {
  const [difficulty, setDifficulty] = useState(1);
  const [questions, setQuestions] = useState([]);
  const [message, setMessage] = useState('');
  const [answers, setAnswers] = useState({});
  const [secondsLeft, setSecondsLeft] = useState(0);
  const [isStarted, setIsStarted] = useState(false);

  const start = async () => {
    try {
      const data = await apiPost('/api/test/start', { difficulty, limit: 5 });
      setQuestions(data);
      setAnswers({});
      setSecondsLeft(120);
      setIsStarted(true);
      setMessage('');
    } catch (e) {
      setMessage('Fehler beim Starten des Tests: ' + e.message);
    }
  };

  const submit = async () => {
    try {
      const questionIds = questions.map((q) => q.id);
      const attempt = await apiPost('/api/test/submit', { difficulty, questionIds, answers });
      setMessage(`Ergebnis: ${attempt.totalPoints} / ${attempt.maxPoints} Punkte (${((attempt.totalPoints/attempt.maxPoints)*100).toFixed(0)}%)`);
      // Scroll to top or show modal
      setTimeout(() => {
        setIsStarted(false);
        setSecondsLeft(0);
      }, 2000);
    } catch (e) {
      setMessage('Fehler beim Absenden: ' + e.message);
    }
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

  // Progress Bar for Timer
  const progressPercent = (secondsLeft / 120) * 100;

  if (!isStarted) {
    return (
      <div style={{ display: 'flex', justifyContent: 'center' }}>
        <motion.div 
          className="card"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          style={{ maxWidth: '400px', width: '100%', textAlign: 'center' }}
        >
          <h2 style={{ color: 'var(--primary-dark)', marginBottom: '1.5rem' }}>Neuen Test starten</h2>
          
          <div style={{ marginBottom: '2rem' }}>
            <label style={{ display: 'block', marginBottom: '1rem', fontWeight: 600 }}>Schwierigkeitsgrad wählen</label>
            <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center' }}>
              {[1, 2, 3].map(level => (
                <button
                  key={level}
                  onClick={() => setDifficulty(level)}
                  style={{
                    padding: '0.75rem 1.5rem',
                    borderRadius: '8px',
                    border: difficulty === level ? '2px solid var(--primary)' : '2px solid #e2e8f0',
                    backgroundColor: difficulty === level ? '#e0e7ff' : 'white',
                    color: difficulty === level ? 'var(--primary-dark)' : 'inherit',
                    fontWeight: 'bold',
                    transition: 'all 0.2s'
                  }}
                >
                  {level === 1 ? 'Leicht' : level === 2 ? 'Mittel' : 'Schwer'}
                </button>
              ))}
            </div>
          </div>

          <button onClick={start} className="btn btn-primary" style={{ width: '100%', fontSize: '1.1rem', padding: '1rem' }}>
            Los geht's
          </button>
          
          {message && <p style={{ marginTop: '1rem', fontWeight: 'bold', fontSize: '1rem', color: 'var(--success)' }}>{message}</p>}
        </motion.div>
      </div>
    );
  }

  return (
    <div>
      <div style={{ 
        position: 'sticky', top: '80px', zIndex: 5, background: 'var(--background)', paddingBottom: '1rem',
        display: 'flex', justifyContent: 'space-between', alignItems: 'center', borderBottom: '1px solid #e2e8f0', marginBottom: '2rem'
      }}>
         <h2 style={{ margin: 0, color: 'var(--text)' }}>Test läuft</h2>
         <div style={{ textAlign: 'right' }}>
            <div style={{ fontWeight: 'bold', fontSize: '1.5rem', color: secondsLeft < 30 ? 'var(--error)' : 'var(--primary)', fontVariantNumeric: 'tabular-nums' }}>
              {Math.floor(secondsLeft / 60)}:{(secondsLeft % 60).toString().padStart(2, '0')}
            </div>
         </div>
      </div>
      <div style={{ position: 'fixed', top: '79px', left: 0, right: 0, height: '4px', background: '#e2e8f0', zIndex: 6 }}>
           <motion.div 
             initial={{ width: '100%' }}
             animate={{ width: `${progressPercent}%` }}
             style={{ height: '100%', background: secondsLeft < 30 ? 'var(--error)' : 'var(--primary)' }}
           />
      </div>

      <div className="question-list" style={{ display: 'flex', flexDirection: 'column', gap: '2rem' }}>
        <AnimatePresence>
          {questions.map((q, qIndex) => (
            <motion.div 
              key={q.id} 
              className="card"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: qIndex * 0.1 }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1rem', alignItems: 'center' }}>
                 <strong style={{ fontSize: '1.1rem', color: 'var(--text-light)' }}>Frage {qIndex + 1}</strong>
                 <span style={{ 
                   fontSize: '0.8rem', padding: '0.25rem 0.75rem', borderRadius: '999px', fontWeight: 600,
                   background: q.type === 'MC' ? '#fee2e2' : '#dbeafe', color: q.type === 'MC' ? '#991b1b' : '#1e40af' 
                 }}>
                   {q.type === 'MC' ? 'Multiple Choice' : 'Lückentext'}
                 </span>
              </div>
              
              <p style={{ marginBottom: '1.5rem', lineHeight: '1.6', fontSize: '1.1rem' }}>{q.prompt}</p>
              
              {q.type === 'MC' && Array.isArray(q.options) && (
                <div style={{ display: 'grid', gap: '0.75rem' }}>
                  {q.options.map((opt) => (
                    <label key={opt.id} style={{ 
                      display: 'flex', alignItems: 'center', gap: '1rem', 
                      padding: '1rem', borderRadius: '12px', 
                      border: '1px solid #e2e8f0', cursor: 'pointer',
                      transition: 'all 0.2s',
                      backgroundColor: (answers[q.id]?.includes(opt.id)) ? '#f0f9ff' : 'white',
                      borderColor: (answers[q.id]?.includes(opt.id)) ? 'var(--primary)' : '#e2e8f0'
                    }}
                    >
                      <input
                        type="checkbox"
                        style={{ width: '1.25rem', height: '1.25rem', accentColor: 'var(--primary)' }}
                        onChange={(e) => updateMcAnswer(q.id, opt.id, e.target.checked)}
                        checked={answers[q.id]?.includes(opt.id) || false}
                      />
                      <span style={{ fontSize: '1rem' }}>{opt.answerText}</span>
                    </label>
                  ))}
                </div>
              )}

              {q.type === 'CLOZE' && Array.isArray(q.tokens) && (
                <div className="cloze" style={{ display: 'flex', flexWrap: 'wrap', gap: '0.75rem', alignItems: 'center', lineHeight: 2 }}>
                  {q.tokens.map((t, idx) => (
                    <input
                      key={t.id}
                      placeholder={`Lücke ${idx + 1}`}
                      style={{ 
                          padding: '0.5rem 1rem', borderRadius: '6px', border: '1px solid #cbd5e1', width: '200px',
                          display: 'inline-block', fontSize: '1rem'
                      }}
                      onChange={(e) => updateClozeAnswer(q.id, idx, e.target.value)}
                    />
                  ))}
                </div>
              )}
            </motion.div>
          ))}
        </AnimatePresence>
      </div>

      <div style={{ marginTop: '2rem', display: 'flex', justifyContent: 'flex-end', paddingBottom: '4rem' }}>
        <button className="btn btn-primary" onClick={submit} style={{ padding: '1rem 3rem', fontSize: '1.2rem', boxShadow: 'var(--shadow-lg)' }}>
          Test abgeben
        </button>
      </div>
    </div>
  );
}
