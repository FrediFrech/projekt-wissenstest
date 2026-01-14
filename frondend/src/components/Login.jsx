/*
 * Datei: components/Login.jsx
 * Diese Komponente ist das Login-Formular. Sie sammelt Benutzername und Passwort und ruft danach
 * das Backend unter /api/auth/login auf.
 * Verbindung: Nutzt apiClient.js und den AuthServlet im Backend.
 */
import React, { useState } from 'react';
import { apiPost } from '../services/apiClient.js';

export default function Login() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');

  const onSubmit = async (e) => {
    e.preventDefault();
    setMessage('');
    try {
      await apiPost('/api/auth/login', { username, password });
      setMessage('Login erfolgreich.');
    } catch (err) {
      setMessage(err.message || 'Login fehlgeschlagen.');
    }
  };

  return (
    <form className="card" onSubmit={onSubmit}>
      <h2>Login</h2>
      <label>Username</label>
      <input value={username} onChange={(e) => setUsername(e.target.value)} />
      <label>Password</label>
      <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
      <button type="submit">Einloggen</button>
      {message && <p className="message">{message}</p>}
    </form>
  );
}
