/*
 * Datei: components/Result.jsx
 * Diese Komponente ist ein einfacher Platzhalter für eine Ergebnisanzeige. Sie kann später genutzt
 * werden, um detaillierte Auswertungen oder Feedback anzuzeigen.
 * Verbindung: Kann von TestRunner oder App eingebunden werden.
 */
import React from 'react';

export default function Result({ total, max }) {
  return (
    <div className="card">
      <h2>Ergebnis</h2>
      <p>{total} / {max}</p>
    </div>
  );
}
