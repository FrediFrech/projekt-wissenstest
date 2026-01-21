/*
 * Datei: components/LandingPage.jsx
 * Landing Page die Features präsentiert und zur Registrierung motiviert
 */
import React from 'react';
import { motion } from 'framer-motion';
import FlipCard from './FlipCard.jsx';

export default function LandingPage({ onNavigate }) {
  const features = [
    {
      icon: '🎯',
      title: 'Adaptives Lernen',
      description: 'Intelligente Schwierigkeitsanpassung basierend auf deiner Performance'
    },
    {
      icon: '📊',
      title: 'Detaillierte Auswertung',
      description: 'Erhalte sofortiges Feedback und verfolge deinen Lernfortschritt'
    },
    {
      icon: '⚡',
      title: 'Multiple Fragetypen',
      description: 'Multiple Choice und Lückentext für abwechslungsreiches Lernen'
    },
    {
      icon: '🎓',
      title: 'Schulnoten-System',
      description: 'Automatische Berechnung deiner Note basierend auf deinen Ergebnissen'
    }
  ];

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
      {/* Hero Section */}
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        style={{
          textAlign: 'center',
          padding: '4rem 2rem',
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          borderRadius: '20px',
          marginBottom: '4rem',
          color: 'white',
          position: 'relative',
          overflow: 'hidden'
        }}
      >
        <motion.div
          animate={{
            scale: [1, 1.2, 1],
            rotate: [0, 180, 360]
          }}
          transition={{
            duration: 20,
            repeat: Infinity,
            ease: "linear"
          }}
          style={{
            position: 'absolute',
            top: '-50%',
            right: '-10%',
            width: '500px',
            height: '500px',
            background: 'rgba(255,255,255,0.1)',
            borderRadius: '50%',
            filter: 'blur(40px)'
          }}
        />
        
        <motion.h1
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          style={{
            fontSize: '3.5rem',
            fontWeight: '900',
            marginBottom: '1.5rem',
            textShadow: '0 4px 6px rgba(0,0,0,0.2)',
            position: 'relative'
          }}
        >
          UML Wissenstest
        </motion.h1>
        
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          style={{
            fontSize: '1.5rem',
            marginBottom: '2.5rem',
            maxWidth: '700px',
            margin: '0 auto 2.5rem',
            lineHeight: '1.6',
            position: 'relative'
          }}
        >
          Die intelligente Lernplattform für UML-Konzepte. 
          Teste dein Wissen, verbessere deine Fähigkeiten und erreiche deine Lernziele.
        </motion.p>
        
        <motion.div
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.6 }}
          style={{ display: 'flex', gap: '1rem', justifyContent: 'center', position: 'relative' }}
        >
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => onNavigate('register')}
            style={{
              padding: '1rem 2.5rem',
              fontSize: '1.2rem',
              background: 'white',
              color: '#667eea',
              border: 'none',
              borderRadius: '12px',
              fontWeight: 'bold',
              cursor: 'pointer',
              boxShadow: '0 10px 25px rgba(0,0,0,0.2)'
            }}
          >
            Kostenlos starten
          </motion.button>
          
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => onNavigate('login')}
            style={{
              padding: '1rem 2.5rem',
              fontSize: '1.2rem',
              background: 'rgba(255,255,255,0.2)',
              color: 'white',
              border: '2px solid white',
              borderRadius: '12px',
              fontWeight: 'bold',
              cursor: 'pointer',
              backdropFilter: 'blur(10px)'
            }}
          >
            Einloggen
          </motion.button>
        </motion.div>
      </motion.div>

      {/* Features Grid mit FlipCards */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.8 }}
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
          gap: '2rem',
          marginBottom: '4rem'
        }}
      >
        {features.map((feature, index) => (
          <motion.div
            key={index}
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.9 + index * 0.1 }}
            style={{ minHeight: '280px' }}
          >
            <FlipCard
              front={
                <div className="card" style={{
                  textAlign: 'center',
                  padding: '2.5rem',
                  height: '100%',
                  minHeight: '280px',
                  display: 'flex',
                  flexDirection: 'column',
                  justifyContent: 'center',
                  background: 'white',
                  position: 'relative'
                }}>
                  <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>
                    {feature.icon}
                  </div>
                  <h3 style={{ 
                    fontSize: '1.5rem', 
                    marginBottom: '1rem', 
                    color: 'var(--primary-dark)',
                    fontWeight: 'bold'
                  }}>
                    {feature.title}
                  </h3>
                  <div style={{
                    position: 'absolute',
                    bottom: '1rem',
                    left: '50%',
                    transform: 'translateX(-50%)',
                    fontSize: '0.85rem',
                    color: 'var(--text-light)',
                    fontStyle: 'italic'
                  }}>
                    Klick mich 🔄
                  </div>
                </div>
              }
              back={
                <div className="card" style={{
                  textAlign: 'center',
                  padding: '2.5rem',
                  height: '100%',
                  minHeight: '280px',
                  display: 'flex',
                  flexDirection: 'column',
                  justifyContent: 'center',
                  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                  color: 'white'
                }}>
                  <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>
                    {feature.icon}
                  </div>
                  <p style={{ 
                    lineHeight: '1.6',
                    fontSize: '1.1rem'
                  }}>
                    {feature.description}
                  </p>
                </div>
              }
            />
          </motion.div>
        ))}
      </motion.div>

      {/* Stats Section */}
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 1.3 }}
        className="card"
        style={{
          padding: '3rem',
          textAlign: 'center',
          background: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
          color: 'white',
          marginBottom: '4rem'
        }}
      >
        <h2 style={{ fontSize: '2.5rem', marginBottom: '2rem', fontWeight: 'bold' }}>
          Warum UML Wissenstest?
        </h2>
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
          gap: '2rem',
          marginTop: '2rem'
        }}>
          <div>
            <div style={{ fontSize: '3rem', fontWeight: 'bold', marginBottom: '0.5rem' }}>
              3
            </div>
            <div style={{ fontSize: '1.1rem' }}>Schwierigkeitsstufen</div>
          </div>
          <div>
            <div style={{ fontSize: '3rem', fontWeight: 'bold', marginBottom: '0.5rem' }}>
              2min
            </div>
            <div style={{ fontSize: '1.1rem' }}>Pro Test-Durchlauf</div>
          </div>
          <div>
            <div style={{ fontSize: '3rem', fontWeight: 'bold', marginBottom: '0.5rem' }}>
              ∞
            </div>
            <div style={{ fontSize: '1.1rem' }}>Versuche möglich</div>
          </div>
        </div>
      </motion.div>

      {/* CTA Section */}
      <motion.div
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: 1.5 }}
        className="card"
        style={{
          padding: '3rem',
          textAlign: 'center',
          background: 'var(--background)',
          border: '2px solid var(--primary)',
          marginBottom: '2rem'
        }}
      >
        <h2 style={{ fontSize: '2rem', marginBottom: '1.5rem', color: 'var(--text)' }}>
          Bereit dein UML-Wissen zu testen?
        </h2>
        <p style={{ fontSize: '1.2rem', color: 'var(--text-light)', marginBottom: '2rem', maxWidth: '600px', margin: '0 auto 2rem' }}>
          Erstelle jetzt dein kostenloses Konto und beginne mit deinem ersten Test in wenigen Sekunden.
        </p>
        <motion.button
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={() => onNavigate('register')}
          className="btn btn-primary"
          style={{
            padding: '1rem 3rem',
            fontSize: '1.3rem',
            boxShadow: 'var(--shadow-lg)'
          }}
        >
          Jetzt loslegen →
        </motion.button>
      </motion.div>
    </div>
  );
}
