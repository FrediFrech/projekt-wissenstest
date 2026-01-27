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

-- Beispiel 1: Multiple Choice
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

-- Beispiel 2: Lückentext
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'In UML beschreibt das ___ Diagramm die Abläufe zwischen Objekten.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'In UML beschreibt das ___ Diagramm die Abläufe zwischen Objekten.'
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
    AND prompt = 'In UML beschreibt das ___ Diagramm die Abläufe zwischen Objekten.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Sequenz', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- Beispiel 3: Multiple Choice
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Aussage trifft auf ein Use-Case-Diagramm zu?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Aussage trifft auf ein Use-Case-Diagramm zu?'
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
    AND prompt = 'Welche Aussage trifft auf ein Use-Case-Diagramm zu?'
    AND difficulty = 1
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

-- Beispiel 4: Lückentext
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein ___ Diagramm zeigt den Lebenszyklus eines Objekts mit Zuständen und Übergängen.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein ___ Diagramm zeigt den Lebenszyklus eines Objekts mit Zuständen und Übergängen.'
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
    AND prompt = 'Ein ___ Diagramm zeigt den Lebenszyklus eines Objekts mit Zuständen und Übergängen.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Zustands', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- Beispiel 5: Multiple Choice (mittel/schwer)
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

-- Sample attempt seed (optional)
-- INSERT INTO attempts (user_id, total_points, max_points, difficulty) VALUES (1, 0, 0, 1);

-- Beispiel 6: Multiple Choice (Hard)
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

-- Beispiel 7: Bild mit Antwort
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'MC', 'Was zeigt dieses Diagramm?', 2, 4, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Was zeigt dieses Diagramm?'
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
    AND prompt = 'Was zeigt dieses Diagramm?'
    AND difficulty = 2
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

-- Beispiel 8: Lückentext
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Das UML Klassendiagramm zeigt die ___ zwischen den Klassen.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Das UML Klassendiagramm zeigt die ___ zwischen den Klassen.'
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
    AND prompt = 'Das UML Klassendiagramm zeigt die ___ zwischen den Klassen.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Beziehungen', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- Beispiel 9: Lückentext - Sequenz Diagramme
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

-- Beispiel 10: Multiple Choice (Seed-Update Test)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Komponente rendert die JSP-Ansichten?', 1, 2, '{"topic":"jsp"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Komponente rendert die JSP-Ansichten?'
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
    AND prompt = 'Welche Komponente rendert die JSP-Ansichten?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Tomcat (Servlet Container)', true, 1.0),
      ('PostgreSQL', false, 0.0)
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

-- Beispiel 11: Multiple Choice (Use-Case-Diagramm)
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

-- Beispiel 12: Multiple Choice (Komponente Klassendiagraamm)
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


-- End of seed file
