-- Datei: db/seeds.sql
-- Dieses Skript legt Beispiel-Daten an, damit man die App lokal testen kann (Admin-User + Fragen).
-- Es muss nach db/schema.sql ausgeführt werden, damit die Tabellen vorhanden sind.
-- Seed data for UML Wissenstest (Postgres)
-- Replace placeholders for password hashing with actual salted SHA‑256 hash values.
-- Example: if pgcrypto is available you can do:
--   SELECT encode(digest('student' || 'somesalt','sha256'),'hex');
-- and then plug the salt and hash below.

SET client_encoding = 'UTF8';

-- Ensure schema extensions for new question types and image storage
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.table_constraints
    WHERE table_name = 'questions'
      AND constraint_type = 'CHECK'
      AND constraint_name = 'questions_type_check'
  ) THEN
    ALTER TABLE questions DROP CONSTRAINT questions_type_check;
  END IF;
EXCEPTION WHEN undefined_table THEN
  -- table not created yet
END $$;

ALTER TABLE questions
  ADD CONSTRAINT questions_type_check CHECK (type IN ('MC','CLOZE','FREE','IMAGE'));

CREATE TABLE IF NOT EXISTS question_images (
  id SERIAL PRIMARY KEY,
  content_type VARCHAR(128) NOT NULL,
  data BYTEA NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Student user (student / student)
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'student',
  'student@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896', 
  '00000000000000000000000000000000',
  'student'
)
ON CONFLICT (username) DO NOTHING;

-- Admin user (lehrer / student)
-- Password 'student' hash is same as above
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'lehrer',
  'lehrer@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896', 
  '00000000000000000000000000000000',
  'admin'
)
ON CONFLICT (username) DO NOTHING;

-- Teacher 2 (teacher2 / student)
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'teacher2',
  'teacher2@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896', 
  '00000000000000000000000000000000',
  'admin'
)
ON CONFLICT (username) DO NOTHING;

-- Student 2 (student2 / student)
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'student2',
  'student2@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896', 
  '00000000000000000000000000000000',
  'student'
)
ON CONFLICT (username) DO NOTHING;

-- ===========================================
-- MULTIPLE CHOICE FRAGEN Leicht (MC 1-8)
-- ===========================================

-- L-MC-1: Welche UML-Diagrammart beschreibt die Struktur von Klassen?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche UML-Diagrammart beschreibt die Struktur von Klassen?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche UML-Diagrammart beschreibt die Struktur von Klassen?'
      AND difficulty = 1
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche UML-Diagrammart beschreibt die Struktur von Klassen?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Klassendiagramm', true, 1.0),
      ('Aktivitätsdiagramm', false, 0.0),
      ('Use-Case-Diagramm', false, 0.0),
      ('Sequenzdiagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-MC 2: Welche Aufgabe hat ein Use-Case-Diagramm in UML?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Aufgabe hat ein Use-Case-Diagramm in UML?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Aufgabe hat ein Use-Case-Diagramm in UML?'
      AND difficulty = 1
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Aufgabe hat ein Use-Case-Diagramm in UML?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Es beschreibt die interne Struktur von Klassen', false, 0.0),
      ('Es stellt die Interaktion zwischen Benutzer und System dar', true, 1.0),
      ('Es zeigt die zeitliche Abfolge von Methodenaufrufen', false, 0.0),
      ('Es modelliert den Lebenszyklus eines Objekts', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-MC-3: Welche Komponente gehört typischerweise zu einem Klassendiagramm?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Komponente gehört typischerweise zu einem Klassendiagramm?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Komponente gehört typischerweise zu einem Klassendiagramm?'
      AND difficulty = 1
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Komponente gehört typischerweise zu einem Klassendiagramm?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Akteur', false, 0.0),
      ('Zustand', false, 0.0),
      ('Methode', true, 1.0),
      ('Entscheidungsknoten', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-MC-4: Welches UML-Diagramm wird verwendet, um den Ablauf von Aktivitäten darzustellen?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welches UML-Diagramm wird verwendet, um den Ablauf von Aktivitäten darzustellen?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welches UML-Diagramm wird verwendet, um den Ablauf von Aktivitäten darzustellen?'
      AND difficulty = 1
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welches UML-Diagramm wird verwendet, um den Ablauf von Aktivitäten darzustellen?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Klassendiagramm', false, 0.0),
      ('Use-Case-Diagramm', false, 0.0),
      ('Aktivitätsdiagramm', true, 1.0),
      ('Deployment-Diagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-MC-5: Was stellt ein Akteur in einem Use-Case-Diagramm dar?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Was stellt ein Akteur in einem Use-Case-Diagramm dar?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Was stellt ein Akteur in einem Use-Case-Diagramm dar?'
      AND difficulty = 1
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Was stellt ein Akteur in einem Use-Case-Diagramm dar?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Eine Klasse des Systems', false, 0.0),
      ('Einen internen Systemprozess', false, 0.0),
      ('Eine externe Rolle oder Benutzer des Systems', true, 1.0),
      ('Eine Datenbank', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-MC-6: Welche Beziehung beschreibt eine „ist-ein"-Beziehung zwischen Klassen?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Beziehung beschreibt eine „ist-ein"-Beziehung zwischen Klassen?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Beziehung beschreibt eine „ist-ein"-Beziehung zwischen Klassen?'
      AND difficulty = 1
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Beziehung beschreibt eine „ist-ein"-Beziehung zwischen Klassen?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Assoziation', false, 0.0),
      ('Aggregation', false, 0.0),
      ('Komposition', false, 0.0),
      ('Vererbung', true, 1.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-MC-7: Welches Element wird in UML zur Darstellung eines Startpunkts in einem Aktivitätsdiagramm verwendet?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welches Element wird in UML zur Darstellung eines Startpunkts in einem Aktivitätsdiagramm verwendet?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welches Element wird in UML zur Darstellung eines Startpunkts in einem Aktivitätsdiagramm verwendet?'
      AND difficulty = 1
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welches Element wird in UML zur Darstellung eines Startpunkts in einem Aktivitätsdiagramm verwendet?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Rechteck', false, 0.0),
      ('Pfeil', false, 0.0),
      ('Gefüllter Kreis', true, 1.0),
      ('Raute', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-MC-8: Wofür wird ein Deployment-Diagramm hauptsächlich eingesetzt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Wofür wird ein Deployment-Diagramm hauptsächlich eingesetzt?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Wofür wird ein Deployment-Diagramm hauptsächlich eingesetzt?'
      AND difficulty = 1
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Wofür wird ein Deployment-Diagramm hauptsächlich eingesetzt?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Darstellung der Benutzerinteraktionen', false, 0.0),
      ('Modellierung von Klassen und Attributen', false, 0.0),
      ('Abbildung der physischen Systemarchitektur', true, 1.0),
      ('Beschreibung von Zustandsübergängen', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- ===========================================
-- MULTIPLE CHOICE Mittel (MC 1-8)
-- ===========================================

-- M-MC-1: Welche Aussage trifft auf ein Use-Case-Diagramm zu?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Aussage trifft auf ein Use-Case-Diagramm zu?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Aussage trifft auf ein Use-Case-Diagramm zu?'
      AND difficulty = 2
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Aussage trifft auf ein Use-Case-Diagramm zu?'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Es zeigt Akteure und ihre Interaktionen mit dem System', true, 1.0),
      ('Es zeigt die zeitliche Reihenfolge von Nachrichten', false, 0.0),
      ('Es beschreibt die physische Server-Struktur', false, 0.0),
      ('Es listet Java-Klassen auf', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-MC-2: Was beschreibt ein Sequenzdiagramm am genauesten?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Was beschreibt ein Sequenzdiagramm am genauesten?', 2, 3, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Was beschreibt ein Sequenzdiagramm am genauesten?'
      AND difficulty = 2
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Was beschreibt ein Sequenzdiagramm am genauesten?'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Nachrichtenfluss zwischen Objekten über die Zeit', true, 1.0),
      ('Klassen und ihre Attribute', false, 0.0),
      ('Komponenten eines Deployments', false, 0.0),
      ('Datenbanktabellen und Beziehungen', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-MC-3: Welche Information wird typischerweise nicht in einem Klassendiagramm dargestellt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Information wird typischerweise nicht in einem Klassendiagramm dargestellt?', 2, 3, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Information wird typischerweise nicht in einem Klassendiagramm dargestellt?'
      AND difficulty = 2
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Information wird typischerweise nicht in einem Klassendiagramm dargestellt?'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Attribute einer Klasse', true, 0.0),
      ('Methoden einer Klasse', false, 0.0),
      ('Zustandsübergänge eines Objekts', true, 1.0),
      ('Beziehungen zwischen Klassen', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-MC-4: Worin liegt der Hauptunterschied zwischen einem Sequenzdiagramm und einem Aktivitätsdiagramm?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Worin liegt der Hauptunterschied zwischen einem Sequenzdiagramm und einem Aktivitätsdiagramm?', 2, 3, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Worin liegt der Hauptunterschied zwischen einem Sequenzdiagramm und einem Aktivitätsdiagramm?'
      AND difficulty = 2
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Worin liegt der Hauptunterschied zwischen einem Sequenzdiagramm und einem Aktivitätsdiagramm?'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Sequenzdiagramme zeigen Klassen, Aktivitätsdiagramme nicht', false, 0.0),
      ('Sequenzdiagramme stellen zeitliche Interaktionen dar, Aktivitätsdiagramme den Ablauf von Aktionen', true, 1.0),
      ('Aktivitätsdiagramme werden nur für Datenbanken verwendet', false, 0.0),
      ('Sequenzdiagramme ersetzen Use-Case-Diagramme', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-MC-5: Welche Beziehung im Klassendiagramm beschreibt, dass ein Objekt zwar zu einem anderen gehört, aber auch unabhängig existieren kann?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Beziehung im Klassendiagramm beschreibt, dass ein Objekt zwar zu einem anderen gehört, aber auch unabhängig existieren kann?', 2, 3, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Beziehung im Klassendiagramm beschreibt, dass ein Objekt zwar zu einem anderen gehört, aber auch unabhängig existieren kann?'
      AND difficulty = 2
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Beziehung im Klassendiagramm beschreibt, dass ein Objekt zwar zu einem anderen gehört, aber auch unabhängig existieren kann?'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Vererbung', false, 0.0),
      ('Komposition', false, 0.0),
      ('Aggregation', true, 1.0),
      ('Abhängigkeit', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-MC-6: Welche Aussage zu Use-Case-Diagrammen ist korrekt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Aussage zu Use-Case-Diagrammen ist korrekt?', 2, 3, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Aussage zu Use-Case-Diagrammen ist korrekt?'
      AND difficulty = 2
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Aussage zu Use-Case-Diagrammen ist korrekt?'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Sie beschreiben die interne Programmlogik', false, 0.0),
      ('Sie modellieren den zeitlichen Ablauf von Methoden', false, 0.0),
      ('Sie zeigen funktionale Anforderungen aus Benutzersicht', true, 1.0),
      ('Sie stellen Datenbankstrukturen dar', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-MC-7: Welches UML-Diagramm eignet sich am besten, um parallele Abläufe darzustellen?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welches UML-Diagramm eignet sich am besten, um parallele Abläufe darzustellen?', 2, 3, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welches UML-Diagramm eignet sich am besten, um parallele Abläufe darzustellen?'
      AND difficulty = 2
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welches UML-Diagramm eignet sich am besten, um parallele Abläufe darzustellen?'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Klassendiagramm', false, 0.0),
      ('Aktivitätsdiagramm', true, 1.0),
      ('Deployment-Diagramm', false, 0.0),
      ('Use-Case-Diagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-MC-8: Was beschreibt ein Deployment-Diagramm auf konzeptioneller Ebene?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Was beschreibt ein Deployment-Diagramm auf konzeptioneller Ebene?', 2, 3, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Was beschreibt ein Deployment-Diagramm auf konzeptioneller Ebene?'
      AND difficulty = 2
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Was beschreibt ein Deployment-Diagramm auf konzeptioneller Ebene?'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Die Abfolge von Benutzerinteraktionen', false, 0.0),
      ('Die Struktur von Klassen und Paketen', false, 0.0),
      ('Die Verteilung von Softwareartefakten auf Hardwareknoten', true, 1.0),
      ('Den Lebenszyklus einzelner Objekte', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- ===========================================
-- MULTIPLE CHOICE Schwer (MC 1- 8)
-- ===========================================

--S-MC-1: Welches Entwurfsmuster gehört NICHT zu den GoF-Mustern?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welches Entwurfsmuster gehört NICHT zu den GoF-Mustern?', 3, 5, '{"topic":"patterns"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welches Entwurfsmuster gehört NICHT zu den GoF-Mustern?'
      AND difficulty = 3
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welches Entwurfsmuster gehört NICHT zu den GoF-Mustern?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('MVC (Model View Controller)', true, 1.0),
      ('Singleton', false, 0.0),
      ('Factory Method', false, 0.0),
      ('Observer', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-MC-2: Welche UML-Diagrammkombination eignet sich am besten, um sowohl funktionale Anforderungen als auch den technischen Ablauf eines Systems zu beschreiben?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche UML-Diagrammkombination eignet sich am besten, um sowohl funktionale Anforderungen als auch den technischen Ablauf eines Systems zu beschreiben?', 3, 5, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche UML-Diagrammkombination eignet sich am besten, um sowohl funktionale Anforderungen als auch den technischen Ablauf eines Systems zu beschreiben?'
      AND difficulty = 3
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche UML-Diagrammkombination eignet sich am besten, um sowohl funktionale Anforderungen als auch den technischen Ablauf eines Systems zu beschreiben?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Klassendiagramm und Deployment-Diagramm', false, 0.0),
      ('Use-Case-Diagramm und Sequenzdiagramm', true, 1.0),
      ('Aktivitätsdiagramm und Zustandsdiagramm', false, 0.0),
      ('Klassendiagramm und ER-Diagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-MC-3: Warum ist ein Klassendiagramm allein nicht ausreichend, um das Laufzeitverhalten eines Systems zu beschreiben?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Warum ist ein Klassendiagramm allein nicht ausreichend, um das Laufzeitverhalten eines Systems zu beschreiben?', 3, 5, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Warum ist ein Klassendiagramm allein nicht ausreichend, um das Laufzeitverhalten eines Systems zu beschreiben?'
      AND difficulty = 3
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Warum ist ein Klassendiagramm allein nicht ausreichend, um das Laufzeitverhalten eines Systems zu beschreiben?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Es enthält keine Methoden', false, 0.0),
      ('Es zeigt keine zeitlichen Abläufe oder Objektinteraktionen', true, 1.0),
      ('Es kann keine Beziehungen darstellen', false, 0.0),
      ('Es ist nur für Datenbanken gedacht', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-MC-4: Welche Aussage zur Komposition im Vergleich zur Aggregation ist korrekt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Aussage zur Komposition im Vergleich zur Aggregation ist korrekt?', 3, 5, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Aussage zur Komposition im Vergleich zur Aggregation ist korrekt?'
      AND difficulty = 3
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Aussage zur Komposition im Vergleich zur Aggregation ist korrekt?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Bei beiden Beziehungen können Teile unabhängig existieren', false, 0.0),
      ('Komposition ist eine schwächere Form der Aggregation', false, 0.0),
      ('Bei einer Komposition sind die Teile vom Lebenszyklus des Ganzen abhängig', true, 1.0),
      ('Aggregation und Komposition sind in UML identisch', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-MC-5: Welches UML-Diagramm eignet sich am besten, um Fehlerzustände und Übergänge eines Systems zu analysieren?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welches UML-Diagramm eignet sich am besten, um Fehlerzustände und Übergänge eines Systems zu analysieren?', 3, 5, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welches UML-Diagramm eignet sich am besten, um Fehlerzustände und Übergänge eines Systems zu analysieren?'
      AND difficulty = 3
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welches UML-Diagramm eignet sich am besten, um Fehlerzustände und Übergänge eines Systems zu analysieren?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Aktivitätsdiagramm', false, 0.0),
      ('Klassendiagramm', false, 0.0),
      ('Zustandsdiagramm', true, 1.0),
      ('Deployment-Diagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-MC-6: Welche Konsequenz hat es, wenn ein Use Case fälschlicherweise interne Systemlogik beschreibt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Konsequenz hat es, wenn ein Use Case fälschlicherweise interne Systemlogik beschreibt?', 3, 5, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Konsequenz hat es, wenn ein Use Case fälschlicherweise interne Systemlogik beschreibt?'
      AND difficulty = 3
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Konsequenz hat es, wenn ein Use Case fälschlicherweise interne Systemlogik beschreibt?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Das Diagramm wird automatisch ungültig', false, 0.0),
      ('Die funktionalen Anforderungen werden aus Benutzersicht unklar', true, 1.0),
      ('Das Diagramm kann nicht mehr implementiert werden', false, 0.0),
      ('Die Performance des Systems sinkt', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-MC-7: Welche Aussage beschreibt den Unterschied zwischen einem Aktivitätsdiagramm und einem Sequenzdiagramm am treffendsten?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Aussage beschreibt den Unterschied zwischen einem Aktivitätsdiagramm und einem Sequenzdiagramm am treffendsten?', 3, 5, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Aussage beschreibt den Unterschied zwischen einem Aktivitätsdiagramm und einem Sequenzdiagramm am treffendsten?'
      AND difficulty = 3
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Aussage beschreibt den Unterschied zwischen einem Aktivitätsdiagramm und einem Sequenzdiagramm am treffendsten?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Aktivitätsdiagramme sind detaillierter als Sequenzdiagramme', false, 0.0),
      ('Sequenzdiagramme zeigen Klassen, Aktivitätsdiagramme Prozesse', false, 0.0),
      ('Aktivitätsdiagramme modellieren Kontrollflüsse, Sequenzdiagramme Objektinteraktionen', true, 1.0),
      ('Beide Diagrammarten sind funktional identisch', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-MC-8: Welche Information lässt sich nicht direkt aus einem Deployment-Diagramm ableiten?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Information lässt sich nicht direkt aus einem Deployment-Diagramm ableiten?', 3, 5, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Information lässt sich nicht direkt aus einem Deployment-Diagramm ableiten?'
      AND difficulty = 3
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Information lässt sich nicht direkt aus einem Deployment-Diagramm ableiten?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Auf welchem Knoten eine Anwendung ausgeführt wird', false, 0.0),
      ('Welche Hardware-Komponenten beteiligt sind', false, 0.0),
      ('Welche Methoden innerhalb einer Klasse aufgerufen werden', true, 1.0),
      ('Wie Softwareartefakte verteilt sind', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- ===========================================
-- LÜCKENTEXT FRAGEN Leicht (Lückentext 1-8)
-- ===========================================

-- L-LT-1: In UML beschreibt das ___ Diagramm die Abläufe zwischen Objekten.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'In UML beschreibt das ___ Diagramm die Abläufe zwischen Objekten.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'In UML beschreibt das ___ Diagramm die Abläufe zwischen Objekten.'
      AND difficulty = 1
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'In UML beschreibt das ___ Diagramm die Abläufe zwischen Objekten.'
    AND difficulty = 1
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Sequenz', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- L-LT-2: Ein ___ Diagramm zeigt den Lebenszyklus eines Objekts mit Zuständen und Übergängen.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein ___ Diagramm zeigt den Lebenszyklus eines Objekts mit Zuständen und Übergängen.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein ___ Diagramm zeigt den Lebenszyklus eines Objekts mit Zuständen und Übergängen.'
      AND difficulty = 1
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein ___ Diagramm zeigt den Lebenszyklus eines Objekts mit Zuständen und Übergängen.'
    AND difficulty = 1
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Zustands', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- L-LT-3: Das UML Klassendiagramm zeigt die ___ zwischen den Klassen.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Das UML Klassendiagramm zeigt die ___ zwischen den Klassen.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Das UML Klassendiagramm zeigt die ___ zwischen den Klassen.'
      AND difficulty = 1
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Das UML Klassendiagramm zeigt die ___ zwischen den Klassen.'
    AND difficulty = 1
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Beziehungen', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- L-LT-4: Ein Use-Case-Diagramm stellt die Interaktion zwischen dem System und den ___ dar.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Use-Case-Diagramm stellt die Interaktion zwischen dem System und den ___ dar.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Use-Case-Diagramm stellt die Interaktion zwischen dem System und den ___ dar.'
      AND difficulty = 1
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Use-Case-Diagramm stellt die Interaktion zwischen dem System und den ___ dar.'
    AND difficulty = 1
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Akteuren', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- L-LT-5: Ein Klassendiagramm besteht unter anderem aus Klassen, Attributen und ___.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Klassendiagramm besteht unter anderem aus Klassen, Attributen und ___.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Klassendiagramm besteht unter anderem aus Klassen, Attributen und ___.'
      AND difficulty = 1
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Klassendiagramm besteht unter anderem aus Klassen, Attributen und ___.'
    AND difficulty = 1
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Methoden', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- L-LT-6: Ein Aktivitätsdiagramm wird verwendet, um den ___ eines Prozesses darzustellen.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Aktivitätsdiagramm wird verwendet, um den ___ eines Prozesses darzustellen.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Aktivitätsdiagramm wird verwendet, um den ___ eines Prozesses darzustellen.'
      AND difficulty = 1
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Aktivitätsdiagramm wird verwendet, um den ___ eines Prozesses darzustellen.'
    AND difficulty = 1
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Ablauf', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- L-LT-7: In UML werden Klassen in einem Klassendiagramm durch ___ dargestellt.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'In UML werden Klassen in einem Klassendiagramm durch ___ dargestellt.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'In UML werden Klassen in einem Klassendiagramm durch ___ dargestellt.'
      AND difficulty = 1
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'In UML werden Klassen in einem Klassendiagramm durch ___ dargestellt.'
    AND difficulty = 1
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Rechtecke', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- L-LT-8: Ein Deployment-Diagramm zeigt die ___ Verteilung eines Softwaresystems.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Deployment-Diagramm zeigt die ___ Verteilung eines Softwaresystems.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Deployment-Diagramm zeigt die ___ Verteilung eines Softwaresystems.'
      AND difficulty = 1
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Deployment-Diagramm zeigt die ___ Verteilung eines Softwaresystems.'
    AND difficulty = 1
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'physische', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- ===========================================
-- LÜCKENTEXT FRAGEN Mittel (Lückentext 1-8)
-- ===========================================

--M-LT-1: In einem Sequenzdiagramm repräsentiert die gestrichelte Linie unter einem Objekt die sogenannte ___.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'In einem Sequenzdiagramm repräsentiert die gestrichelte Linie unter einem Objekt die sogenannte ___.', 3, 5, '{"topic":"patterns"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'In einem Sequenzdiagramm repräsentiert die gestrichelte Linie unter einem Objekt die sogenannte ___.'
      AND difficulty = 2
      AND category = 'Multiple Choice'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'In einem Sequenzdiagramm repräsentiert die gestrichelte Linie unter einem Objekt die sogenannte ___.'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Lifeline', true, 1.0),
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-LT-2: Ein Use-Case-Diagramm beschreibt die ___ Anforderungen eines Systems aus der Sicht der ___.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Use-Case-Diagramm beschreibt die ___ Anforderungen eines Systems aus der Sicht der ___.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Use-Case-Diagramm beschreibt die ___ Anforderungen eines Systems aus der Sicht der ___.'
      AND difficulty = 2
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Use-Case-Diagramm beschreibt die ___ Anforderungen eines Systems aus der Sicht der ___.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, v.token_index, v.expected_text, v.partial_value
  FROM q_id,
    (VALUES
      (1, 'funktionalen', 1.0),
      (2, 'Akteure', 1.0)
    ) AS v(token_index, expected_text, partial_value)
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT ins.question_id, ins.token_index, ins.expected_text, ins.partial_value
FROM ins
ON CONFLICT (question_id, token_index) DO NOTHING;

-- M-LT-3: In einem Klassendiagramm wird die Vererbung durch eine Linie mit einem ___ ___ dargestellt.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'In einem Klassendiagramm wird die Vererbung durch eine Linie mit einem ___ ___ dargestellt.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'In einem Klassendiagramm wird die Vererbung durch eine Linie mit einem ___ ___ dargestellt.'
      AND difficulty = 2
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'In einem Klassendiagramm wird die Vererbung durch eine Linie mit einem ___ ___ dargestellt.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'offenen Dreieck', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- M-LT-4: Ein Sequenzdiagramm stellt die Interaktionen zwischen Objekten entlang einer ___ ___ dar.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Sequenzdiagramm stellt die Interaktionen zwischen Objekten entlang einer ___ ___ dar.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Sequenzdiagramm stellt die Interaktionen zwischen Objekten entlang einer ___ ___ dar.'
      AND difficulty = 2
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Sequenzdiagramm stellt die Interaktionen zwischen Objekten entlang einer ___ ___ dar.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'zeitlichen Achse', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- M-LT-5: Ein Aktivitätsdiagramm kann mithilfe von ___ die Aufteilung in parallele Abläufe darstellen.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Aktivitätsdiagramm kann mithilfe von ___ die Aufteilung in parallele Abläufe darstellen.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Aktivitätsdiagramm kann mithilfe von ___ die Aufteilung in parallele Abläufe darstellen.'
      AND difficulty = 2
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Aktivitätsdiagramm kann mithilfe von ___ die Aufteilung in parallele Abläufe darstellen.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Forks', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- M-LT-6: Ein Deployment-Diagramm zeigt die Zuordnung von ___ zu ___.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Deployment-Diagramm zeigt die Zuordnung von ___ zu ___.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Deployment-Diagramm zeigt die Zuordnung von ___ zu ___.'
      AND difficulty = 2
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Deployment-Diagramm zeigt die Zuordnung von ___ zu ___.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, v.token_index, v.expected_text, v.partial_value
  FROM q_id,
    (VALUES
      (1, 'Softwareartefakten', 1.0),
      (2, 'Hardwareknoten', 1.0)
    ) AS v(token_index, expected_text, partial_value)
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT ins.question_id, ins.token_index, ins.expected_text, ins.partial_value
FROM ins
ON CONFLICT (question_id, token_index) DO NOTHING;

-- M-LT-7: Eine Aggregation beschreibt eine ___-___-Beziehung zwischen Klassen.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Eine Aggregation beschreibt eine ___-___-Beziehung zwischen Klassen.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Eine Aggregation beschreibt eine ___-___-Beziehung zwischen Klassen.'
      AND difficulty = 2
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Eine Aggregation beschreibt eine ___-___-Beziehung zwischen Klassen.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, v.token_index, v.expected_text, v.partial_value
  FROM q_id,
    (VALUES
      (1, 'Ganzes', 1.0),
      (2, 'Teil', 1.0)
    ) AS v(token_index, expected_text, partial_value)
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT ins.question_id, ins.token_index, ins.expected_text, ins.partial_value
FROM ins
ON CONFLICT (question_id, token_index) DO NOTHING;

-- M-LT-8: Zustandsdiagramme bestehen aus Zuständen und ___, die den Wechsel zwischen diesen beschreiben.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Zustandsdiagramme bestehen aus Zuständen und ___, die den Wechsel zwischen diesen beschreiben.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Zustandsdiagramme bestehen aus Zuständen und ___, die den Wechsel zwischen diesen beschreiben.'
      AND difficulty = 2
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Zustandsdiagramme bestehen aus Zuständen und ___, die den Wechsel zwischen diesen beschreiben.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Übergängen', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- ===========================================
-- LÜCKENTEXT FRAGEN Schwer (Lückentext 1 - ...)
-- ===========================================

-- S-LT-1: Ein Sequenzdiagramm stellt die ___ zwischen mehreren Objekten dar. Die vertikale Achse repräsentiert ___, während die horizontale Achse die ___ darstellt. Die ___ werden durch Pfeile dargestellt.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Sequenzdiagramm stellt die ___ zwischen mehreren Objekten dar. Die vertikale Achse repräsentiert ___, während die horizontale Achse die ___ darstellt. Die ___ werden durch Pfeile dargestellt.', 2, 4, '{"topic":"sequence-diagrams"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Sequenzdiagramm stellt die ___ zwischen mehreren Objekten dar. Die vertikale Achse repräsentiert ___, während die horizontale Achse die ___ darstellt. Die ___ werden durch Pfeile dargestellt.'
      AND difficulty = 2
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Sequenzdiagramm stellt die ___ zwischen mehreren Objekten dar. Die vertikale Achse repräsentiert ___, während die horizontale Achse die ___ darstellt. Die ___ werden durch Pfeile dargestellt.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, v.token_index, v.expected_text, v.partial_value
  FROM q_id,
    (VALUES
      (1, 'Interaktion', 1.0),
      (2, 'Akteure', 1.0),
      (3, 'Zeit', 1.0),
      (4, 'Nachrichten', 1.0)
    ) AS v(token_index, expected_text, partial_value)
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT ins.question_id, ins.token_index, ins.expected_text, ins.partial_value
FROM ins
ON CONFLICT (question_id, token_index) DO NOTHING;

-- S-LT-2: Ein Use-Case-Diagramm beschreibt bewusst nicht die ___ Implementierung eines Systems.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Use-Case-Diagramm beschreibt bewusst nicht die ___ Implementierung eines Systems.', 3, 5, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Use-Case-Diagramm beschreibt bewusst nicht die ___ Implementierung eines Systems.'
      AND difficulty = 3
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Use-Case-Diagramm beschreibt bewusst nicht die ___ Implementierung eines Systems.'
    AND difficulty = 3
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'technische', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- S-LT-3: Ein Sequenzdiagramm stellt die ___ zwischen Objekten dar, wobei die zeitliche Reihenfolge entlang der ___ Achse verläuft und durch ___ visualisiert wird.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Sequenzdiagramm stellt die ___ zwischen Objekten dar, wobei die zeitliche Reihenfolge entlang der ___ Achse verläuft und durch ___ visualisiert wird.', 3, 5, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Sequenzdiagramm stellt die ___ zwischen Objekten dar, wobei die zeitliche Reihenfolge entlang der ___ Achse verläuft und durch ___ visualisiert wird.'
      AND difficulty = 3
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Sequenzdiagramm stellt die ___ zwischen Objekten dar, wobei die zeitliche Reihenfolge entlang der ___ Achse verläuft und durch ___ visualisiert wird.'
    AND difficulty = 3
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, v.token_index, v.expected_text, v.partial_value
  FROM q_id,
    (VALUES
      (1, 'Interaktionen', 1.0),
      (2, 'vertikalen', 1.0),
      (3, 'Nachrichten', 1.0)
    ) AS v(token_index, expected_text, partial_value)
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT ins.question_id, ins.token_index, ins.expected_text, ins.partial_value
FROM ins
ON CONFLICT (question_id, token_index) DO NOTHING;

-- S-LT-4: Bei einer Komposition sind die ___ Objekte fest an den ___ des übergeordneten Objekts gebunden.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Bei einer Komposition sind die ___ Objekte fest an den ___ des übergeordneten Objekts gebunden.', 3, 5, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Bei einer Komposition sind die ___ Objekte fest an den ___ des übergeordneten Objekts gebunden.'
      AND difficulty = 3
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Bei einer Komposition sind die ___ Objekte fest an den ___ des übergeordneten Objekts gebunden.'
    AND difficulty = 3
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, v.token_index, v.expected_text, v.partial_value
  FROM q_id,
    (VALUES
      (1, 'untergeordneten', 1.0),
      (2, 'Lebenszyklus', 1.0)
    ) AS v(token_index, expected_text, partial_value)
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT ins.question_id, ins.token_index, ins.expected_text, ins.partial_value
FROM ins
ON CONFLICT (question_id, token_index) DO NOTHING;

-- S-LT-5: Ein Aktivitätsdiagramm besteht unter anderem aus Aktionen, Kontrollflüssen, ___-Knoten zur Parallelisierung sowie ___-Knoten zur Zusammenführung der Abläufe und einem ___- sowie ___-Knoten.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Aktivitätsdiagramm besteht unter anderem aus Aktionen, Kontrollflüssen, ___-Knoten zur Parallelisierung sowie ___-Knoten zur Zusammenführung der Abläufe und einem ___- sowie ___-Knoten.', 3, 5, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Aktivitätsdiagramm besteht unter anderem aus Aktionen, Kontrollflüssen, ___-Knoten zur Parallelisierung sowie ___-Knoten zur Zusammenführung der Abläufe und einem ___- sowie ___-Knoten.'
      AND difficulty = 3
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Aktivitätsdiagramm besteht unter anderem aus Aktionen, Kontrollflüssen, ___-Knoten zur Parallelisierung sowie ___-Knoten zur Zusammenführung der Abläufe und einem ___- sowie ___-Knoten.'
    AND difficulty = 3
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, v.token_index, v.expected_text, v.partial_value
  FROM q_id,
    (VALUES
      (1, 'Fork', 1.0),
      (2, 'Join', 1.0),
      (3, 'Start', 1.0),
      (4, 'End', 1.0)
    ) AS v(token_index, expected_text, partial_value)
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT ins.question_id, ins.token_index, ins.expected_text, ins.partial_value
FROM ins
ON CONFLICT (question_id, token_index) DO NOTHING;

-- S-LT-6: Die Multiplizität „0..1" in einem Klassendiagramm beschreibt eine ___ Beziehung.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Die Multiplizität „0..1" in einem Klassendiagramm beschreibt eine ___ Beziehung.', 3, 5, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Die Multiplizität „0..1" in einem Klassendiagramm beschreibt eine ___ Beziehung.'
      AND difficulty = 3
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Die Multiplizität „0..1" in einem Klassendiagramm beschreibt eine ___ Beziehung.'
    AND difficulty = 3
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'optionale', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- S-LT-7: Ein Deployment-Diagramm modelliert die Zuordnung von ___ zu ___, welche auf physischen oder ___ Knoten ausgeführt werden.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Deployment-Diagramm modelliert die Zuordnung von ___ zu ___, welche auf physischen oder ___ Knoten ausgeführt werden.', 3, 5, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Deployment-Diagramm modelliert die Zuordnung von ___ zu ___, welche auf physischen oder ___ Knoten ausgeführt werden.'
      AND difficulty = 3
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Deployment-Diagramm modelliert die Zuordnung von ___ zu ___, welche auf physischen oder ___ Knoten ausgeführt werden.'
    AND difficulty = 3
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, v.token_index, v.expected_text, v.partial_value
  FROM q_id,
    (VALUES
      (1, 'Softwareartefakten', 1.0),
      (2, 'Hardware', 1.0),
      (3, 'virtuellen', 1.0)
    ) AS v(token_index, expected_text, partial_value)
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT ins.question_id, ins.token_index, ins.expected_text, ins.partial_value
FROM ins
ON CONFLICT (question_id, token_index) DO NOTHING;

-- S-LT-8: Ein Zustandsdiagramm fokussiert sich auf Zustände und ___, während ein Aktivitätsdiagramm primär ___ modelliert.
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Zustandsdiagramm fokussiert sich auf Zustände und ___, während ein Aktivitätsdiagramm primär ___ modelliert.', 3, 5, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Zustandsdiagramm fokussiert sich auf Zustände und ___, während ein Aktivitätsdiagramm primär ___ modelliert.'
      AND difficulty = 3
      AND category = 'Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Ein Zustandsdiagramm fokussiert sich auf Zustände und ___, während ein Aktivitätsdiagramm primär ___ modelliert.'
    AND difficulty = 3
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, v.token_index, v.expected_text, v.partial_value
  FROM q_id,
    (VALUES
      (1, 'Übergänge', 1.0),
      (2, 'Abläufe', 1.0)
    ) AS v(token_index, expected_text, partial_value)
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT ins.question_id, ins.token_index, ins.expected_text, ins.partial_value
FROM ins
ON CONFLICT (question_id, token_index) DO NOTHING;



-- ===========================================
-- BILDER FRAGEN Leicht (Bild 1 - ...)
-- ===========================================

-- L-B-1: Welche Diagrammart wird in der Abbildung dargestellt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Diagrammart wird in der Abbildung dargestellt?', 2, 4, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Diagrammart wird in der Abbildung dargestellt?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Diagrammart wird in der Abbildung dargestellt?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Klassendiagramm', true, 1.0),
      ('Komponentendiagramm', false, 0.0),
      ('Verteilungsdiagramm', false, 0.0),
      ('Objektdiagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-B-2: Welcher UML-Diagrammtyp ist in der Abbildung dargestellt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welcher UML-Diagrammtyp ist in der Abbildung dargestellt?', 2, 4, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welcher UML-Diagrammtyp ist in der Abbildung dargestellt?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welcher UML-Diagrammtyp ist in der Abbildung dargestellt?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Klassendiagramm', false, 0.0),
      ('Sequenzdiagramm', false, 0.0),
      ('Aktivitätsdiagramm', false, 0.0),
      ('Use-Case-Diagramm', true, 1.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);


-- L-B-1: Welche Diagrammart wird in der Abbildung dargestellt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Diagrammart wird in der Abbildung dargestellt?', 1, 2, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Diagrammart wird in der Abbildung dargestellt?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Diagrammart wird in der Abbildung dargestellt?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Klassendiagramm', true, 1.0),
      ('Komponentendiagramm', false, 0.0),
      ('Verteilungsdiagramm', false, 0.0),
      ('Objektdiagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-B-2: Welcher UML-Diagrammtyp ist in der Abbildung dargestellt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welcher UML-Diagrammtyp ist in der Abbildung dargestellt?', 1, 2, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welcher UML-Diagrammtyp ist in der Abbildung dargestellt?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welcher UML-Diagrammtyp ist in der Abbildung dargestellt?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Klassendiagramm', false, 0.0),
      ('Sequenzdiagramm', false, 0.0),
      ('Aktivitätsdiagramm', false, 0.0),
      ('Use-Case-Diagramm', true, 1.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-B-3: Welcher UML-Diagrammtyp zeigt den in der Abbildung dargestellten Ablauf?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welcher UML-Diagrammtyp zeigt den in der Abbildung dargestellten Ablauf?', 1, 2, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welcher UML-Diagrammtyp zeigt den in der Abbildung dargestellten Ablauf?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welcher UML-Diagrammtyp zeigt den in der Abbildung dargestellten Ablauf?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Aktivitätsdiagramm', true, 1.0),
      ('Zustandsdiagramm', false, 0.0),
      ('Kommunikationsdiagramm', false, 0.0),
      ('Paketdiagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-B-4: Welche UML-Diagrammart zeigt die in der Abbildung dargestellte Abfolge?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche UML-Diagrammart zeigt die in der Abbildung dargestellte Abfolge?', 1, 2, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche UML-Diagrammart zeigt die in der Abbildung dargestellte Abfolge?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche UML-Diagrammart zeigt die in der Abbildung dargestellte Abfolge?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Sequenzdiagramm', true, 1.0),
      ('Aktivitätsdiagramm', false, 0.0),
      ('Use-Case-Diagramm', false, 0.0),
      ('Komponentendiagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-B-5: Welche Art von Beziehung zwischen den Klassen ist in der Abbildung dargestellt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Art von Beziehung zwischen den Klassen ist in der Abbildung dargestellt?', 1, 2, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Art von Beziehung zwischen den Klassen ist in der Abbildung dargestellt?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Art von Beziehung zwischen den Klassen ist in der Abbildung dargestellt?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Vererbungsbeziehung', true, 1.0),
      ('Aggregation', false, 0.0),
      ('Assoziation', false, 0.0),
      ('Abhängigkeit', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-B-6: Welches UML-Diagramm stellt die in der Abbildung gezeigte Systemarchitektur dar?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welches UML-Diagramm stellt die in der Abbildung gezeigte Systemarchitektur dar?', 1, 2, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welches UML-Diagramm stellt die in der Abbildung gezeigte Systemarchitektur dar?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welches UML-Diagramm stellt die in der Abbildung gezeigte Systemarchitektur dar?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Deployment-Diagramm', true, 1.0),
      ('Sequenzdiagramm', false, 0.0),
      ('Zustandsdiagramm', false, 0.0),
      ('Aktivitätsdiagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-B-7: Wie bezeichnet man die Strichmännchen in der vorliegenden UML-Diagrammart?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Wie bezeichnet man die Strichmännchen in der vorliegenden UML-Diagrammart?', 1, 2, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Wie bezeichnet man die Strichmännchen in der vorliegenden UML-Diagrammart?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Wie bezeichnet man die Strichmännchen in der vorliegenden UML-Diagrammart?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Akteur', true, 1.0),
      ('Objekt', false, 0.0),
      ('Komponente', false, 0.0),
      ('Knoten (Node)', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- L-B-8: Welche UML-Diagrammart zeigt den in der Abbildung dargestellten Zyklus?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche UML-Diagrammart zeigt den in der Abbildung dargestellten Zyklus?', 1, 2, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche UML-Diagrammart zeigt den in der Abbildung dargestellten Zyklus?'
      AND difficulty = 1
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche UML-Diagrammart zeigt den in der Abbildung dargestellten Zyklus?'
    AND difficulty = 1
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Zustandsdiagramm', true, 1.0),
      ('Aktivitätsdiagramm', false, 0.0),
      ('Sequenzdiagramm', false, 0.0),
      ('Paketdiagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- ===========================================
-- BILDER FRAGEN Mittel (Bild 1 - ...)
-- ===========================================

-- M-B-1: Welche Beziehung zwischen den Klassen ist in der Abbildung dargestellt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Beziehung zwischen den Klassen ist in der Abbildung dargestellt?', 2, 3, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Beziehung zwischen den Klassen ist in der Abbildung dargestellt?'
      AND difficulty = 2
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Beziehung zwischen den Klassen ist in der Abbildung dargestellt?'
    AND difficulty = 2
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Assoziation', false, 0.0),
      ('Aggregation', false, 0.0),
      ('Komposition', true, 1.0),
      ('Abhängigkeit', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-B-2: Welche UML-Diagrammart eignet sich am besten zur Darstellung des gezeigten Szenarios?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche UML-Diagrammart eignet sich am besten zur Darstellung des gezeigten Szenarios?', 2, 3, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche UML-Diagrammart eignet sich am besten zur Darstellung des gezeigten Szenarios?'
      AND difficulty = 2
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche UML-Diagrammart eignet sich am besten zur Darstellung des gezeigten Szenarios?'
    AND difficulty = 2
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Klassendiagramm', false, 0.0),
      ('Use-Case-Diagramm', false, 0.0),
      ('Aktivitätsdiagramm', true, 1.0),
      ('Deployment-Diagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-B-3: Welche Rolle übernimmt das in der Abbildung dargestellte Element im Diagramm?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Rolle übernimmt das in der Abbildung dargestellte Element im Diagramm?', 2, 3, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Rolle übernimmt das in der Abbildung dargestellte Element im Diagramm?'
      AND difficulty = 2
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Rolle übernimmt das in der Abbildung dargestellte Element im Diagramm?'
    AND difficulty = 2
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Generalisierung', false, 0.0),
      ('Include- oder Extend-Beziehung', true, 1.0),
      ('Assoziation', false, 0.0),
      ('Abhängigkeit', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-B-4: Welche Aussage beschreibt den Ablauf im dargestellten Diagramm korrekt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Aussage beschreibt den Ablauf im dargestellten Diagramm korrekt?', 2, 3, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Aussage beschreibt den Ablauf im dargestellten Diagramm korrekt?'
      AND difficulty = 2
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Aussage beschreibt den Ablauf im dargestellten Diagramm korrekt?'
    AND difficulty = 2
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Die Struktur von Klassen', false, 0.0),
      ('Die Verteilung von Softwarekomponenten', false, 0.0),
      ('Die zeitliche Abfolge von Nachrichten zwischen Objekten', true, 1.0),
      ('Den Lebenszyklus eines Objekts', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-B-5: Welche UML-Diagrammart wird verwendet, um den dargestellten Zustandwechsel zu modellieren?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche UML-Diagrammart wird verwendet, um den dargestellten Zustandwechsel zu modellieren?', 2, 3, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche UML-Diagrammart wird verwendet, um den dargestellten Zustandwechsel zu modellieren?'
      AND difficulty = 2
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche UML-Diagrammart wird verwendet, um den dargestellten Zustandwechsel zu modellieren?'
    AND difficulty = 2
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Aktivitätsdiagramm', false, 0.0),
      ('Zustandsdiagramm', true, 1.0),
      ('Sequenzdiagramm', false, 0.0),
      ('Use-Case-Diagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-B-6: Welche Art von Beziehung besteht zwischen den dargestellten Klassen?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Art von Beziehung besteht zwischen den dargestellten Klassen?', 2, 3, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Art von Beziehung besteht zwischen den dargestellten Klassen?'
      AND difficulty = 2
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Art von Beziehung besteht zwischen den dargestellten Klassen?'
    AND difficulty = 2
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Vererbung', false, 0.0),
      ('Komposition', false, 0.0),
      ('Aggregation', false, 0.0),
      ('Assoziation', true, 1.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-B-7: Welche Komponente ist in der Abbildung für die Ausführung der dargestellten Software verantwortlich?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Komponente ist in der Abbildung für die Ausführung der dargestellten Software verantwortlich?', 2, 3, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Komponente ist in der Abbildung für die Ausführung der dargestellten Software verantwortlich?'
      AND difficulty = 2
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Komponente ist in der Abbildung für die Ausführung der dargestellten Software verantwortlich?'
    AND difficulty = 2
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Client', false, 0.0),
      ('Datenbank', false, 0.0),
      ('Server-Knoten', true, 1.0),
      ('Benutzer', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- M-B-8: Welche Information lässt sich aus der Abbildung direkt ablesen?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Information lässt sich aus der Abbildung direkt ablesen?', 2, 3, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Information lässt sich aus der Abbildung direkt ablesen?'
      AND difficulty = 2
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Information lässt sich aus der Abbildung direkt ablesen?'
    AND difficulty = 2
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Assoziation', false, 0.0),
      ('Vererbung', true, 1.0),
      ('Aggregation', false, 0.0),
      ('Abhängigkeit', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- ===========================================
-- BILDER FRAGEN Schwer (Bild 1 - 8)
-- ===========================================

-- S-B-1: Welche konzeptionelle Aussage lässt sich aus dem dargestellten Diagramm korrekt ableiten?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche konzeptionelle Aussage lässt sich aus dem dargestellten Diagramm korrekt ableiten?', 3, 5, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche konzeptionelle Aussage lässt sich aus dem dargestellten Diagramm korrekt ableiten?'
      AND difficulty = 3
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche konzeptionelle Aussage lässt sich aus dem dargestellten Diagramm korrekt ableiten?'
    AND difficulty = 3
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Die Unterklassen erben Attribute und Methoden der Oberklasse', true, 1.0),
      ('Die Unterklassen sind unabhängig von der Oberklasse', false, 0.0),
      ('Die Klassen sind über eine Aggregation verbunden', false, 0.0),
      ('Die Klassen interagieren zeitlich miteinander', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-B-2: Welche Eigenschaft der dargestellten Beziehung ist korrekt?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Eigenschaft der dargestellten Beziehung ist korrekt?', 3, 5, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Eigenschaft der dargestellten Beziehung ist korrekt?'
      AND difficulty = 3
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Eigenschaft der dargestellten Beziehung ist korrekt?'
    AND difficulty = 3
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Die Beziehung ist eine Assoziation', false, 0.0),
      ('Die Beziehung ist eine Aggregation', false, 0.0),
      ('Die Beziehung ist eine Komposition', true, 1.0),
      ('Die Beziehung ist eine Abhängigkeit', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-B-3: Welche Information wird durch das dargestellte Diagramm explizit modelliert?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Information wird durch das dargestellte Diagramm explizit modelliert?', 3, 5, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Information wird durch das dargestellte Diagramm explizit modelliert?'
      AND difficulty = 3
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Information wird durch das dargestellte Diagramm explizit modelliert?'
    AND difficulty = 3
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Die interne Datenstruktur der Klassen', false, 0.0),
      ('Die zeitliche Reihenfolge der Objektinteraktionen', true, 1.0),
      ('Die physische Verteilung der Software', false, 0.0),
      ('Die funktionalen Anforderungen des Systems', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-B-4: Welche Schlussfolgerung lässt sich aus dem dargestellten Aktivitätsdiagramm ziehen?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Schlussfolgerung lässt sich aus dem dargestellten Aktivitätsdiagramm ziehen?', 3, 5, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Schlussfolgerung lässt sich aus dem dargestellten Aktivitätsdiagramm ziehen?'
      AND difficulty = 3
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Schlussfolgerung lässt sich aus dem dargestellten Aktivitätsdiagramm ziehen?'
    AND difficulty = 3
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Die Aktivitäten werden strikt sequenziell ausgeführt', false, 0.0),
      ('Der Prozess enthält parallele Ausführungspfade', true, 1.0),
      ('Das Diagramm beschreibt Zustandswechsel', false, 0.0),
      ('Das Diagramm stellt Objektinteraktionen dar', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-B-5: Welche Aussage beschreibt den Zweck des dargestellten Diagramms am treffendsten?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Aussage beschreibt den Zweck des dargestellten Diagramms am treffendsten?', 3, 5, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Aussage beschreibt den Zweck des dargestellten Diagramms am treffendsten?'
      AND difficulty = 3
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Aussage beschreibt den Zweck des dargestellten Diagramms am treffendsten?'
    AND difficulty = 3
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Darstellung der technischen Systemarchitektur', false, 0.0),
      ('Modellierung funktionaler Anforderungen aus Benutzersicht', true, 1.0),
      ('Beschreibung der zeitlichen Ausführung von Methoden', false, 0.0),
      ('Abbildung der Klassenhierarchie', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-B-6: Welche Information kann aus dem dargestellten Diagramm nicht direkt abgeleitet werden?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Information kann aus dem dargestellten Diagramm nicht direkt abgeleitet werden?', 3, 5, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Information kann aus dem dargestellten Diagramm nicht direkt abgeleitet werden?'
      AND difficulty = 3
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Information kann aus dem dargestellten Diagramm nicht direkt abgeleitet werden?'
    AND difficulty = 3
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Auf welchem Knoten ein Artefakt ausgeführt wird', false, 0.0),
      ('Welche Hardware-Komponenten beteiligt sind', false, 0.0),
      ('Welche Methoden innerhalb einer Klasse existieren', true, 1.0),
      ('Wie die Software physisch verteilt ist', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-B-7: Welche UML-Diagrammart ist für die dargestellte Modellierung am besten geeignet?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche UML-Diagrammart ist für die dargestellte Modellierung am besten geeignet?', 3, 5, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche UML-Diagrammart ist für die dargestellte Modellierung am besten geeignet?'
      AND difficulty = 3
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche UML-Diagrammart ist für die dargestellte Modellierung am besten geeignet?'
    AND difficulty = 3
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Aktivitätsdiagramm', false, 0.0),
      ('Sequenzdiagramm', false, 0.0),
      ('Zustandsdiagramm', true, 1.0),
      ('Use-Case-Diagramm', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- S-B-8: Welche Modellierungsentscheidung wird im dargestellten Diagramm getroffen?
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Welche Modellierungsentscheidung wird im dargestellten Diagramm getroffen?', 3, 5, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Modellierungsentscheidung wird im dargestellten Diagramm getroffen?'
      AND difficulty = 3
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'MC'
    AND prompt = 'Welche Modellierungsentscheidung wird im dargestellten Diagramm getroffen?'
    AND difficulty = 3
    AND category = 'Bild mit Antwort'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Die Lebenszyklen der Objekte sind voneinander abhängig', false, 0.0),
      ('Die Beziehung ist eine lose strukturelle Verbindung', true, 1.0),
      ('Die Klassen stehen in einer Vererbungsbeziehung', false, 0.0),
      ('Die Objekte existieren nur innerhalb des Ganzen', false, 0.0)
    ) AS a(answer_text, is_correct, partial_value)
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT ins.question_id, ins.answer_text, ins.is_correct, ins.partial_value
FROM ins
WHERE NOT EXISTS (
  SELECT 1 FROM answers a2
  WHERE a2.question_id = ins.question_id
    AND a2.answer_text = ins.answer_text
);

-- Sample attempt seed (optional)
-- INSERT INTO attempts (user_id, total_points, max_points, difficulty) VALUES (1, 0, 0, 1);

-- End of seed file
