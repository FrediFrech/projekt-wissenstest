/*
 * Datei: components/Register.jsx
 */
import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { apiPost } from '../services/apiClient.js';

export default function Register({ onRegisterSuccess }) {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const onSubmit = async (e) => {
    e.preventDefault();
    setMessage('');
    setIsLoading(true);
    try {
      await apiPost('/api/auth/register', { username, email, password });
      setMessage('Registrierung erfolgreich! Du kannst dich jetzt einloggen.');
      setTimeout(() => {
        if (onRegisterSuccess) onRegisterSuccess();
      }, 2000);
    } catch (err) {
      setMessage(err.message || 'Registrierung fehlgeschlagen.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '60vh' }}>
      <motion.form 
        className="card" 
        onSubmit={onSubmit}
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.4 }}
        style={{ width: '100%', maxWidth: '400px', backgroundColor: 'white' }}
      >
        <h2 style={{ marginBottom: '1.5rem', textAlign: 'center', color: 'var(--primary-dark)', fontSize: '1.5rem', fontWeight: 'bold' }}>Neues Konto erstellen</h2>
        
        <div style={{ marginBottom: '1rem' }}>
          <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: 600 }}>Benutzername</label>
          <input 
            style={{ width: '100%' }}
            value={username} 
            onChange={(e) => setUsername(e.target.value)} 
            placeholder="Dein Name"
            required
          />
        </div>

        <div style={{ marginBottom: '1rem' }}>
          <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: 600 }}>E-Mail Adresse</label>
          <input 
            type="email"
            style={{ width: '100%' }}
            value={email} 
            onChange={(e) => setEmail(e.target.value)} 
            placeholder="student@example.com"
            required
          />
        </div>

        <div style={{ marginBottom: '1.5rem' }}>
          <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: 600 }}>Passwort</label>
          <input 
            type="password" 
            style={{ width: '100%' }}
            value={password} 
            onChange={(e) => setPassword(e.target.value)} 
            placeholder="••••••••"
            required
            minLength={6}
          />
        </div>

        <button 
          type="submit" 
          className="btn btn-primary" 
          style={{ width: '100%', padding: '0.75rem', fontSize: '1rem' }}
          disabled={isLoading}
        >
          {isLoading ? 'Registriere...' : 'Kostenlos registrieren'}
        </button>

        {message && (
          <motion.div 
            initial={{ opacity: 0, y: 10 }} 
            animate={{ opacity: 1, y: 0 }}
            style={{ 
              marginTop: '1rem', 
              padding: '0.75rem', 
              backgroundColor: message.includes('erfolgreich') ? '#dcfce7' : '#fee2e2',
              border: `1px solid ${message.includes('erfolgreich') ? '#bbf7d0' : '#fecaca'}`,
              color: message.includes('erfolgreich') ? '#166534' : '#991b1b',
              borderRadius: '6px',
              textAlign: 'center'
            }}
          >
            {message}
          </motion.div>
        )}
      </motion.form>
    </div>
  );
}
