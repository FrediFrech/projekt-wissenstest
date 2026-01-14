/*
 * Datei: vite.config.js
 * Diese Datei steuert, wie der Vite-Devserver und der Build für das React-Frontend laufen.
 * So kannst du lokal schnell entwickeln und später den Build ins WAR kopieren.
 * Verbindung: Wird von den npm-Skripten in package.json genutzt.
 */
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173
  }
});
