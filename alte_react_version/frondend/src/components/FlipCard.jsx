/*
 * Datei: components/FlipCard.jsx
 * Wiederverwendbare Flip-Karte mit 3D-Animation
 */
import React, { useState } from 'react';
import { motion } from 'framer-motion';

export default function FlipCard({ front, back, style = {} }) {
  const [isFlipped, setIsFlipped] = useState(false);

  return (
    <div
      style={{
        perspective: '1000px',
        width: '100%',
        height: '100%',
        cursor: 'pointer',
        ...style
      }}
      onClick={() => setIsFlipped(!isFlipped)}
    >
      <motion.div
        style={{
          width: '100%',
          height: '100%',
          position: 'relative',
          transformStyle: 'preserve-3d',
        }}
        animate={{ rotateY: isFlipped ? 180 : 0 }}
        transition={{ duration: 0.6, type: 'spring', stiffness: 120 }}
      >
        {/* Front Side */}
        <div
          style={{
            position: 'absolute',
            width: '100%',
            height: '100%',
            backfaceVisibility: 'hidden',
            WebkitBackfaceVisibility: 'hidden',
          }}
        >
          {front}
        </div>

        {/* Back Side */}
        <div
          style={{
            position: 'absolute',
            width: '100%',
            height: '100%',
            backfaceVisibility: 'hidden',
            WebkitBackfaceVisibility: 'hidden',
            transform: 'rotateY(180deg)',
          }}
        >
          {back}
        </div>
      </motion.div>
    </div>
  );
}
