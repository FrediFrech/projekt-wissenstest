/*
 * Datei: src/main.jsx
 * Diese Datei startet die React-Anwendung. Sie rendert die App-Komponente in das HTML-Element
 * mit der ID "root" und bindet die globalen Styles ein.
 * Verbindung: App.jsx enthält die Navigation und die Seitenkomponenten.
 */
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.jsx';
import './styles/modern.css';

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
