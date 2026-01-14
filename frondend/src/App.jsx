/*
 * Datei: src/App.jsx
 * Diese Komponente ist der zentrale Einstieg der Oberfläche. Sie zeigt eine einfache Navigation
 * und wechselt zwischen den Seiten (Login, Registrierung, Test und Admin).
 * Verbindung: Bindet die Komponenten Login, Register, TestRunner und AdminPanel ein.
 */
import React, { useState } from 'react';
import Login from './components/Login.jsx';
import Register from './components/Register.jsx';
import TestRunner from './components/TestRunner.jsx';
import AdminPanel from './components/AdminPanel.jsx';

export default function App() {
  const [view, setView] = useState('login');

  return (
    <div className="app">
      <header className="app-header">
        <h1>UML Wissenstest</h1>
        <nav>
          <button onClick={() => setView('login')}>Login</button>
          <button onClick={() => setView('register')}>Registrieren</button>
          <button onClick={() => setView('test')}>Test</button>
          <button onClick={() => setView('admin')}>Admin</button>
        </nav>
      </header>

      <main className="app-main">
        {view === 'login' && <Login />}
        {view === 'register' && <Register />}
        {view === 'test' && <TestRunner />}
        {view === 'admin' && <AdminPanel />}
      </main>
    </div>
  );
}
