/*
 * Datei: src/App.jsx
 */
import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import LandingPage from './components/LandingPage.jsx';
import Login from './components/Login.jsx';
import Register from './components/Register.jsx';
import TestRunner from './components/TestRunner.jsx';
import AdminPanel from './components/AdminPanel.jsx';
import LearnMode from './components/LearnMode.jsx';

// Simple SVG Icons
const Icons = {
  Login: () => <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}><path strokeLinecap="round" strokeLinejoin="round" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1" /></svg>,
  Register: () => <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}><path strokeLinecap="round" strokeLinejoin="round" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" /></svg>,
  Test: () => <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}><path strokeLinecap="round" strokeLinejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" /></svg>,
  Learn: () => <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}><path strokeLinecap="round" strokeLinejoin="round" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" /></svg>,
  Admin: () => <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}><path strokeLinecap="round" strokeLinejoin="round" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" /><path strokeLinecap="round" strokeLinejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /></svg>,
};

export default function App() {
  const [view, setView] = useState('landing');
  const [user, setUser] = useState(null); // { username, role }

  const handleLoginSuccess = (userData) => {
    setUser(userData);
    setView('test');
  };

  const handleLogout = () => {
    setUser(null);
    setView('landing');
  };

  // Navigation items basierend auf Login-Status
  const getNavItems = () => {
    const items = [];
    
    if (!user) {
      items.push({ id: 'landing', label: 'Home', icon: () => <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}><path strokeLinecap="round" strokeLinejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" /></svg> });
      items.push({ id: 'login', label: 'Login', icon: Icons.Login });
      items.push({ id: 'register', label: 'Register', icon: Icons.Register });
    } else {
      items.push({ id: 'test', label: 'Test', icon: Icons.Test });
      items.push({ id: 'learn', label: 'Lernen', icon: Icons.Learn });
      if (user.role === 'admin') {
        items.push({ id: 'admin', label: 'Admin', icon: Icons.Admin });
      }
    }
    
    return items;
  };

  const navItems = getNavItems();

  return (
    <div className="app" style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      <header style={{ 
        background: 'rgba(255, 255, 255, 0.8)', 
        backdropFilter: 'blur(10px)', 
        borderBottom: '1px solid #e2e8f0', 
        position: 'sticky', 
        top: 0, 
        zIndex: 10 
      }}>
        <div className="container" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '1rem 2rem' }}>
          <h1 
            onClick={() => setView(user ? 'test' : 'landing')} 
            style={{ 
              fontSize: '1.5rem', 
              fontWeight: '800', 
              margin: 0, 
              background: 'linear-gradient(to right, var(--primary), var(--secondary))', 
              WebkitBackgroundClip: 'text', 
              WebkitTextFillColor: 'transparent',
              cursor: 'pointer'
            }}
          >
            UML Wissenstest
          </h1>
          <nav style={{ display: 'flex', gap: '0.5rem', alignItems: 'center' }}>
            {navItems.map((item) => (
              <button
                key={item.id}
                onClick={() => setView(item.id)}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.5rem',
                  padding: '0.5rem 1rem',
                  borderRadius: '8px',
                  backgroundColor: view === item.id ? 'var(--primary)' : 'transparent',
                  color: view === item.id ? 'white' : 'var(--text-light)',
                  fontWeight: 500,
                  transition: 'all 0.2s'
                }}
              >
                <item.icon />
                {item.label}
              </button>
            ))}
            {user && (
              <div style={{ marginLeft: '1rem', display: 'flex', alignItems: 'center', gap: '1rem' }}>
                <span style={{ color: 'var(--text-light)', fontSize: '0.9rem' }}>
                  {user.username}
                </span>
                <button
                  onClick={handleLogout}
                  className="btn btn-secondary"
                  style={{ padding: '0.5rem 1rem' }}
                >
                  Logout
                </button>
              </div>
            )}
          </nav>
        </div>
      </header>

      <main className="container" style={{ flex: 1, padding: '2rem', width: '100%', position: 'relative' }}>
        <AnimatePresence mode="wait">
          <motion.div
            key={view}
            initial={{ opacity: 0, x: 20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -20 }}
            transition={{ duration: 0.2 }}
            style={{ width: '100%' }}
          >
            {view === 'landing' && <LandingPage onNavigate={setView} />}
            {view === 'login' && <Login onLoginSuccess={handleLoginSuccess} />}
            {view === 'register' && <Register onRegisterSuccess={() => setView('login')} />}
            {view === 'test' && user && <TestRunner />}
            {view === 'learn' && user && <LearnMode />}
            {view === 'admin' && user?.role === 'admin' && <AdminPanel />}
          </motion.div>
        </AnimatePresence>
      </main>
    </div>
  );
}
