/*
 * Datei: services/apiClient.js
 * Diese Datei kapselt die HTTP-Aufrufe ins Backend, damit die Komponenten nicht jedes Mal den
 * gleichen Fetch-Code schreiben müssen. Sie bietet einfache GET/POST/DELETE Funktionen mit
 * JSON-Handling und Fehlerausgabe.
 * Verbindung: Wird in Login, Register, TestRunner und AdminPanel genutzt.
 */
const BASE = '/wissentest';

export async function apiGet(path) {
  const res = await fetch(`${BASE}${path}`, { credentials: 'include' });
  if (!res.ok) {
    throw new Error(`HTTP ${res.status}`);
  }
  return res.json();
}

export async function apiPost(path, body) {
  const res = await fetch(`${BASE}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: JSON.stringify(body)
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.error || `HTTP ${res.status}`);
  }
  return res.json();
}

export async function apiDelete(path) {
  const res = await fetch(`${BASE}${path}`, {
    method: 'DELETE',
    credentials: 'include'
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.error || `HTTP ${res.status}`);
  }
  return res.json();
}

export async function apiPut(path, body) {
  const res = await fetch(`${BASE}${path}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: JSON.stringify(body)
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.error || `HTTP ${res.status}`);
  }
  return res.json();
}
