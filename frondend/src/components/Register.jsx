/*
 * Datei: components/Register.jsx
 * Diese Komponente zeigt das Registrierungsformular. Die Daten werden an /api/auth/register gesendet,
 * damit der Benutzer in der Datenbank angelegt wird.
 * Verbindung: Nutzt apiClient.js und den AuthServlet im Backend.
 */
import React, { useState } from 'react';
import { apiPost } from '../services/apiClient.js';

export default function Register() {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');

  const onSubmit = async (e) => {
    e.preventDefault();
    setMessage('');
    try {
      await apiPost('/api/auth/register', { username, email, password });
      setMessage('Registrierung erfolgreich.');
    } catch (err) {
      setMessage(err.message || 'Registrierung fehlgeschlagen.');
    }
  };

  return (
    <form className="card" onSubmit={onSubmit}>
      <h2>Registrierung</h2>
      <label>Username</label>
      <input value={username} onChange={(e) => setUsername(e.target.value)} />
      <label>E-Mail</label>
      <input value={email} onChange={(e) => setEmail(e.target.value)} />
      <label>Password</label>
      <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
      <button type="submit">Registrieren</button>
      {message && <p className="message">{message}</p>}
    </form>
  );
}
