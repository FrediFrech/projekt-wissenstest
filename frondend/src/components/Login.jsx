/*
 * Datei: components/Login.jsx
 */
import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { apiPost } from '../services/apiClient.js';

export default function Login({ onLoginSuccess }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const onSubmit = async (e) => {
    e.preventDefault();
    setMessage('');
    setIsLoading(true);
    try {
      const response = await apiPost('/api/auth/login', { username, password });
      setMessage('Login erfolgreich.');
      // Pass user data to parent (username and role)
      if (onLoginSuccess) {
        onLoginSuccess({ 
          username: response.username || username, 
          role: response.role || 'student' 
        });
      }
    } catch (err) {
      setMessage(err.message || 'Login fehlgeschlagen.');
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
        transition={{ duration: 0.4, ease: "easeOut" }}
        style={{ width: '100%', maxWidth: '400px', backgroundColor: 'white' }}
      >
        <h2 style={{ marginBottom: '1.5rem', textAlign: 'center', color: 'var(--primary-dark)', fontSize: '1.5rem', fontWeight: 'bold' }}>Willkommen zurück</h2>
        
        <div style={{ marginBottom: '1rem' }}>
          <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: 600, color: '#374151' }}>Benutzername</label>
          <input 
            style={{ width: '100%' }}
            value={username} 
            onChange={(e) => setUsername(e.target.value)} 
            placeholder="z.B. student"
          />
        </div>

        <div style={{ marginBottom: '1.5rem' }}>
          <label style={{ display: 'block', marginBottom: '0.5rem', fontWeight: 600, color: '#374151' }}>Passwort</label>
          <input 
            type="password" 
            style={{ width: '100%' }}
            value={password} 
            onChange={(e) => setPassword(e.target.value)} 
            placeholder="••••••"
          />
        </div>

        <button 
          type="submit" 
          className="btn btn-primary" 
          style={{ width: '100%', padding: '0.75rem', fontSize: '1rem' }}
          disabled={isLoading}
        >
          {isLoading ? 'Melde an...' : 'Anmelden'}
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
              textAlign: 'center',
              fontSize: '0.9rem'
            }}
          >
            {message}
          </motion.div>
        )}
      </motion.form>
    </div>
  );
}
