-- Datei: db/schema.sql
-- Dieses SQL-Skript legt die Tabellen für Benutzer, Fragen, Antworten und Testversuche an.
-- Es ist die Grundlage für alle JDBC-Zugriffe im Backend. Ohne dieses Schema können die DAOs
-- keine Daten speichern oder laden.
-- DB Schema for UML Wissenstest (Postgres)
-- Use this as a draft. Adjust types and constraints as needed.

-- Optional: enable pgcrypto if you want to compute digests in Postgres
-- CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE IF EXISTS attempt_answers CASCADE;
DROP TABLE IF EXISTS attempts CASCADE;
DROP TABLE IF EXISTS cloze_answers CASCADE;
DROP TABLE IF EXISTS answers CASCADE;
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS config CASCADE;

-- Users
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  email VARCHAR(255) UNIQUE,
  password_hash VARCHAR(256) NOT NULL,
  password_salt VARCHAR(128) NOT NULL,
  role VARCHAR(32) NOT NULL DEFAULT 'student',
  reset_requested BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Questions
CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  type VARCHAR(16) NOT NULL CHECK (type IN ('MC','CLOZE')),
  prompt TEXT NOT NULL,
  difficulty SMALLINT NOT NULL CHECK (difficulty IN (1,2,3)), -- 1=easy,2=medium,3=hard
  points INTEGER NOT NULL DEFAULT 1,
  category VARCHAR(64) DEFAULT 'Allgemein',
  image_url VARCHAR(255),
  meta JSONB DEFAULT '{}'::jsonb,
  created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Multiple choice answers (also used for single/multi-correct MC)
CREATE TABLE answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  answer_text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT false,
  partial_value NUMERIC(5,4) NOT NULL DEFAULT 0.0 CHECK (partial_value >= 0 AND partial_value <= 1)
);

-- Cloze (Lückentext) expected tokens (order matters)
CREATE TABLE cloze_answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  token_index SMALLINT NOT NULL,
  expected_text TEXT NOT NULL,
  partial_value NUMERIC(5,4) NOT NULL DEFAULT 1.0 CHECK (partial_value >= 0 AND partial_value <= 1),
  UNIQUE(question_id, token_index)
);

-- Test attempts (one row per finished attempt)
CREATE TABLE attempts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  total_points NUMERIC(8,4) NOT NULL DEFAULT 0.0,
  max_points NUMERIC(8,4) NOT NULL DEFAULT 0.0,
  difficulty SMALLINT NOT NULL CHECK (difficulty IN (1,2,3)),
  grade VARCHAR(10),
  duration_seconds INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Per-question results for each attempt
CREATE TABLE attempt_answers (
  id SERIAL PRIMARY KEY,
  attempt_id INTEGER NOT NULL REFERENCES attempts(id) ON DELETE CASCADE,
  question_id INTEGER REFERENCES questions(id) ON DELETE SET NULL,
  given_answer TEXT,
  points_awarded NUMERIC(8,4) NOT NULL DEFAULT 0.0
);

-- Configuration table for placeholders like progression thresholds
CREATE TABLE config (
  key VARCHAR(128) PRIMARY KEY,
  value VARCHAR(255) NOT NULL,
  description TEXT
);

-- Useful indexes
CREATE INDEX idx_questions_difficulty ON questions(difficulty);
CREATE INDEX idx_attempts_user ON attempts(user_id);

-- Example config placeholders
INSERT INTO config (key, value, description) VALUES
('progress.promote_threshold', '0.70', 'Promote to next difficulty if last test score >= 70% (placeholder)'),
('progress.demote_threshold',  '0.40', 'Demote if average of last N attempts <= 40% (placeholder)'),
('progress.window_size',      '3',    'Number of recent attempts used to calculate demotion (placeholder)');

-- End of schema draft
