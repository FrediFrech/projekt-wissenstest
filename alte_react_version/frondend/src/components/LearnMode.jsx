/*
 * Datei: components/LearnMode.jsx
 * Lernmodus mit Karteikarten für Fragen und Antworten
 */
import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import FlipCard from './FlipCard.jsx';
import { apiGet } from '../services/apiClient.js';

export default function LearnMode() {
  const [questions, setQuestions] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [difficulty, setDifficulty] = useState(1);
  const [loading, setLoading] = useState(false);

  const loadQuestions = async () => {
    setLoading(true);
    try {
      // Fetch questions from admin endpoint or create a dedicated learn endpoint
      const data = await apiGet('/api/admin/questions');
      const filtered = Array.isArray(data) 
        ? data.filter(q => q.difficulty === difficulty) 
        : [];
      setQuestions(filtered);
      setCurrentIndex(0);
    } catch (e) {
      console.error('Fehler beim Laden der Fragen:', e);
      setQuestions([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadQuestions();
  }, [difficulty]);

  const nextCard = () => {
    if (currentIndex < questions.length - 1) {
      setCurrentIndex(currentIndex + 1);
    }
  };

  const prevCard = () => {
    if (currentIndex > 0) {
      setCurrentIndex(currentIndex - 1);
    }
  };

  const currentQuestion = questions[currentIndex];

  const renderAnswer = (q) => {
    if (q.type === 'MC' && Array.isArray(q.options)) {
      const correct = q.options.filter(opt => opt.isCorrect || opt.correct);
      return (
        <div>
          <div style={{ fontSize: '1.2rem', fontWeight: 'bold', marginBottom: '1rem', color: 'var(--success)' }}>
            Richtige Antwort{correct.length > 1 ? 'en' : ''}:
          </div>
          <ul style={{ listStyle: 'none', padding: 0, display: 'grid', gap: '0.5rem' }}>
            {correct.map(opt => (
              <li key={opt.id} style={{ 
                padding: '0.75rem', 
                background: '#dcfce7', 
                borderRadius: '8px',
                border: '2px solid #22c55e'
              }}>
                ✓ {opt.answerText}
              </li>
            ))}
          </ul>
        </div>
      );
    } else if (q.type === 'CLOZE' && Array.isArray(q.tokens)) {
      return (
        <div>
          <div style={{ fontSize: '1.2rem', fontWeight: 'bold', marginBottom: '1rem', color: 'var(--success)' }}>
            Lösung:
          </div>
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.5rem', fontSize: '1.1rem' }}>
            {q.tokens.map((token, idx) => (
              <span key={idx} style={{ 
                padding: '0.5rem 1rem', 
                background: '#dcfce7', 
                borderRadius: '6px',
                fontWeight: 'bold',
                border: '2px solid #22c55e'
              }}>
                {token.expectedText}
              </span>
            ))}
          </div>
        </div>
      );
    }
    return <div style={{ color: 'var(--text-light)' }}>Keine Antwort verfügbar</div>;
  };

  if (loading) {
    return (
      <div style={{ textAlign: 'center', padding: '4rem' }}>
        <div style={{ fontSize: '2rem' }}>Lade Karteikarten...</div>
      </div>
    );
  }

  if (!questions.length) {
    return (
      <div className="card" style={{ textAlign: 'center', padding: '3rem' }}>
        <h2 style={{ color: 'var(--text-light)' }}>Keine Fragen für diesen Schwierigkeitsgrad verfügbar</h2>
        <p style={{ marginTop: '1rem' }}>Bitte wähle einen anderen Schwierigkeitsgrad oder erstelle neue Fragen im Admin-Bereich.</p>
      </div>
    );
  }

  return (
    <div style={{ maxWidth: '800px', margin: '0 auto' }}>
      <div style={{ marginBottom: '2rem', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h2 style={{ margin: 0 }}>Lernmodus 📚</h2>
        <div style={{ display: 'flex', gap: '0.5rem' }}>
          {[1, 2, 3].map(level => (
            <button
              key={level}
              onClick={() => setDifficulty(level)}
              className={difficulty === level ? 'btn btn-primary' : 'btn btn-secondary'}
              style={{ padding: '0.5rem 1rem' }}
            >
              {level === 1 ? 'Leicht' : level === 2 ? 'Mittel' : 'Schwer'}
            </button>
          ))}
        </div>
      </div>

      <div style={{ marginBottom: '1rem', textAlign: 'center', color: 'var(--text-light)' }}>
        Karte {currentIndex + 1} von {questions.length}
      </div>

      <AnimatePresence mode="wait">
        <motion.div
          key={currentIndex}
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.9 }}
          transition={{ duration: 0.3 }}
          style={{ minHeight: '400px' }}
        >
          {currentQuestion && (
            <FlipCard
              style={{ minHeight: '400px' }}
              front={
                <div className="card" style={{ 
                  height: '100%', 
                  display: 'flex', 
                  flexDirection: 'column', 
                  justifyContent: 'center',
                  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                  color: 'white',
                  minHeight: '400px'
                }}>
                  <div style={{ 
                    position: 'absolute', 
                    top: '1rem', 
                    right: '1rem',
                    background: 'rgba(255,255,255,0.2)',
                    padding: '0.5rem 1rem',
                    borderRadius: '999px',
                    fontSize: '0.85rem',
                    fontWeight: 'bold'
                  }}>
                    {currentQuestion.type === 'MC' ? 'Multiple Choice' : 'Lückentext'}
                  </div>
                  <div style={{ fontSize: '1.5rem', lineHeight: '1.6', textAlign: 'center', padding: '2rem' }}>
                    {currentQuestion.prompt}
                  </div>
                  <div style={{ 
                    position: 'absolute', 
                    bottom: '1rem', 
                    left: '50%', 
                    transform: 'translateX(-50%)',
                    fontSize: '0.9rem',
                    opacity: 0.8,
                    fontStyle: 'italic'
                  }}>
                    Klicke zum Umdrehen 🔄
                  </div>
                </div>
              }
              back={
                <div className="card" style={{ 
                  height: '100%', 
                  display: 'flex', 
                  flexDirection: 'column', 
                  justifyContent: 'center',
                  background: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
                  color: 'white',
                  minHeight: '400px',
                  padding: '2rem'
                }}>
                  {renderAnswer(currentQuestion)}
                  <div style={{ 
                    position: 'absolute', 
                    bottom: '1rem', 
                    left: '50%', 
                    transform: 'translateX(-50%)',
                    fontSize: '0.9rem',
                    opacity: 0.8,
                    fontStyle: 'italic'
                  }}>
                    Klicke zum Zurückdrehen 🔄
                  </div>
                </div>
              }
            />
          )}
        </motion.div>
      </AnimatePresence>

      <div style={{ marginTop: '2rem', display: 'flex', justifyContent: 'space-between', gap: '1rem' }}>
        <button
          onClick={prevCard}
          disabled={currentIndex === 0}
          className="btn btn-secondary"
          style={{ flex: 1, padding: '1rem', fontSize: '1.1rem' }}
        >
          ← Vorherige
        </button>
        <button
          onClick={nextCard}
          disabled={currentIndex === questions.length - 1}
          className="btn btn-primary"
          style={{ flex: 1, padding: '1rem', fontSize: '1.1rem' }}
        >
          Nächste →
        </button>
      </div>

      <div style={{ marginTop: '2rem', textAlign: 'center' }}>
        <div style={{ 
          display: 'inline-flex', 
          gap: '0.5rem',
          padding: '1rem',
          background: 'var(--background)',
          borderRadius: '12px'
        }}>
          {questions.map((_, idx) => (
            <div
              key={idx}
              onClick={() => setCurrentIndex(idx)}
              style={{
                width: '12px',
                height: '12px',
                borderRadius: '50%',
                background: idx === currentIndex ? 'var(--primary)' : '#cbd5e1',
                cursor: 'pointer',
                transition: 'all 0.2s'
              }}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
