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
  SELECT 'CLOZE', 'In UML beschreibt das ___ Diagramm die Abläufe zwischen Objekten.', 2, 3, '{"topic":"uml","class":"Sequenzdiagramm"}', 'Lückentext'
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
  SELECT 'MC', 'Welche Aussage trifft auf ein Use-Case-Diagramm zu?', 1, 2, '{"topic":"uml","class":"Use-Case"}', 'Multiple Choice'
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
  SELECT 'CLOZE', 'Ein ___ Diagramm zeigt den Lebenszyklus eines Objekts mit Zuständen und Übergängen.', 2, 3, '{"topic":"uml","class":"Zustandsdiagramm"}', 'Lückentext'
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
  SELECT 'MC', 'Was beschreibt ein Sequenzdiagramm am genauesten?', 2, 3, '{"topic":"uml","class":"Sequenzdiagramm"}', 'Multiple Choice'
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

-- Beispiel 6: Klassendiagramm (Schwer)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Beziehung beschreibt "Komposition" im UML-Klassendiagramm am besten?', 3, 5, '{"topic":"uml","class":"Klassendiagramm"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Beziehung beschreibt "Komposition" im UML-Klassendiagramm am besten?'
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
    AND prompt = 'Welche Beziehung beschreibt "Komposition" im UML-Klassendiagramm am besten?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Starke Teil-Ganzes-Beziehung (Lebenszyklus der Teile ist an das Ganze gekoppelt)', true, 1.0),
      ('Schwache Teil-Ganzes-Beziehung (Teile können unabhängig existieren)', false, 0.0),
      ('Vererbung / Generalisierung zwischen Klassen', false, 0.0),
      ('Beliebige Assoziation ohne Besitzverhältnis', false, 0.0)
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

-- Beispiel 7: Bildfrage (IMAGE) mit Antwort
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'IMAGE', 'Was zeigt dieses Bild?', 2, 4, '{"topic":"uml","class":"Sequenzdiagramm"}', 'Bild mit Antwort', 'assets/questions/sequenzdiagram.png'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'IMAGE'
      AND prompt = 'Was zeigt dieses Bild?'
      AND difficulty = 2
      AND category = 'Bild mit Antwort'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'IMAGE'
    AND prompt = 'Was zeigt dieses Bild?'
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
      ('Sequenzdiagramm', true, 1.0),
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

-- Fix existing Bildfrage prompt/image/answer (idempotent)
WITH q AS (
  SELECT id FROM questions
  WHERE type = 'IMAGE'
    AND category = 'Bild mit Antwort'
    AND prompt IN ('Was zeigt dieses Bild? ÄÖÜ ß', 'Was zeigt dieses Bild?')
  ORDER BY id DESC
  LIMIT 1
)
UPDATE questions
SET prompt = 'Was zeigt dieses Bild?',
  image_url = 'assets/questions/sequenzdiagram.png',
    meta = '{"topic":"uml","class":"Sequenzdiagramm"}'::jsonb
WHERE id IN (SELECT id FROM q);

-- Normalize legacy image rows with old image_url
UPDATE questions
SET prompt = 'Was zeigt dieses Bild?',
    image_url = 'assets/questions/sequenzdiagram.png',
    meta = '{"topic":"uml","class":"Sequenzdiagramm"}'::jsonb
WHERE type = 'IMAGE'
  AND category = 'Bild mit Antwort'
  AND image_url = '/assets/diagram_example.png';

WITH q AS (
  SELECT id FROM questions
  WHERE type = 'IMAGE'
    AND category = 'Bild mit Antwort'
    AND prompt = 'Was zeigt dieses Bild?'
  ORDER BY id DESC
  LIMIT 1
)
UPDATE answers
SET is_correct = (answer_text = 'Sequenzdiagramm'),
    partial_value = CASE WHEN answer_text = 'Sequenzdiagramm' THEN 1.0 ELSE 0.0 END
WHERE question_id IN (SELECT id FROM q)
  AND answer_text IN ('Klassendiagramm', 'Sequenzdiagramm', 'Paketdiagramm');

-- Ensure legacy image rows have only the intended options
WITH q AS (
  SELECT id FROM questions
  WHERE type = 'IMAGE'
    AND category = 'Bild mit Antwort'
    AND prompt = 'Was zeigt dieses Bild?'
)
DELETE FROM answers
WHERE question_id IN (SELECT id FROM q)
  AND answer_text NOT IN ('Klassendiagramm', 'Sequenzdiagramm', 'Paketdiagramm');

-- Deduplicate the image question (keep newest)
DELETE FROM questions
WHERE type = 'IMAGE'
  AND category = 'Bild mit Antwort'
  AND prompt = 'Was zeigt dieses Bild?'
  AND id NOT IN (
    SELECT MAX(id) FROM questions
    WHERE type = 'IMAGE'
      AND category = 'Bild mit Antwort'
      AND prompt = 'Was zeigt dieses Bild?'
  );

WITH q AS (
  SELECT id FROM questions
  WHERE type = 'IMAGE'
    AND category = 'Bild mit Antwort'
    AND prompt = 'Was zeigt dieses Bild?'
  ORDER BY id DESC
  LIMIT 1
)
DELETE FROM answers
WHERE question_id IN (SELECT id FROM q)
  AND answer_text NOT IN ('Klassendiagramm', 'Sequenzdiagramm', 'Paketdiagramm');

-- Beispiel 8: Bild mit Lückentext (Klassendiagramm)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  SELECT 'CLOZE', 'Dieses Bild zeigt ein ___.', 1, 2, '{"topic":"uml","class":"Klassendiagramm","image":true}', 'Bild mit Lückentext', 'assets/questions/klassendiagram.PNG'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Dieses Bild zeigt ein ___.'
      AND difficulty = 1
      AND category = 'Bild mit Lückentext'
  )
  RETURNING id
),
q_id AS (
  SELECT id FROM q
  UNION ALL
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND prompt = 'Dieses Bild zeigt ein ___.'
    AND difficulty = 1
    AND category = 'Bild mit Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Klassendiagramm', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- Fix existing Bild-Lückentext image URL (idempotent)
WITH q AS (
  SELECT id FROM questions
  WHERE type = 'CLOZE'
    AND category = 'Bild mit Lückentext'
    AND prompt = 'Dieses Bild zeigt ein ___.'
  ORDER BY id DESC
  LIMIT 1
)
UPDATE questions
SET image_url = 'assets/questions/klassendiagram.PNG'
WHERE id IN (SELECT id FROM q);

-- Normalize any remaining absolute /assets URLs to relative paths
UPDATE questions
SET image_url = REPLACE(image_url, '/assets/', 'assets/')
WHERE image_url LIKE '/assets/%';

-- Normalize legacy image exercise entries (remove umlaut test text and non-standard category)
WITH q AS (
  SELECT id
  FROM questions
  WHERE category = 'Bilder Übung'
     OR prompt ILIKE '%ÄÖÜ%'
     OR prompt ILIKE '%ß%'
)
UPDATE questions
SET category = 'Bild mit Antwort',
    prompt = 'Was zeigt dieses Bild?',
    meta = '{"topic":"uml","class":"Sequenzdiagramm"}'::jsonb,
    image_url = CASE
        WHEN image_url IS NULL OR image_url = '' THEN 'assets/questions/sequenzdiagram.png'
        WHEN image_url LIKE '/assets/%' THEN REPLACE(image_url, '/assets/', 'assets/')
        ELSE image_url
    END
WHERE id IN (SELECT id FROM q);

WITH q AS (
  SELECT id
  FROM questions
  WHERE category = 'Bild mit Antwort'
    AND prompt = 'Was zeigt dieses Bild?'
)
UPDATE answers
SET is_correct = (answer_text = 'Sequenzdiagramm'),
    partial_value = CASE WHEN answer_text = 'Sequenzdiagramm' THEN 1.0 ELSE 0.0 END
WHERE question_id IN (SELECT id FROM q)
  AND answer_text IN ('Klassendiagramm', 'Sequenzdiagramm', 'Paketdiagramm');

-- Beispiel 9: Lückentext
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Das UML Klassendiagramm zeigt die ___ zwischen den Klassen.', 2, 3, '{"topic":"uml","class":"Klassendiagramm"}', 'Lückentext'
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

-- Beispiel 10: Lückentext - Sequenz Diagramme
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Sequenzdiagramm stellt die ___ zwischen mehreren Objekten dar. Die vertikale Achse repräsentiert ___, während die horizontale Achse die ___ darstellt. Die ___ werden durch Pfeile dargestellt.', 2, 4, '{"topic":"uml","class":"Sequenzdiagramm"}', 'Lückentext'
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

-- Beispiel 11: Use-Case (Mittel)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Wann wird die Beziehung «include» in einem Use-Case-Diagramm typischerweise verwendet?', 2, 3, '{"topic":"uml","class":"Use-Case"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Wann wird die Beziehung «include» in einem Use-Case-Diagramm typischerweise verwendet?'
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
    AND prompt = 'Wann wird die Beziehung «include» in einem Use-Case-Diagramm typischerweise verwendet?'
    AND difficulty = 2
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Wenn ein verpflichtender Teilablauf von mehreren Use Cases wiederverwendet wird', true, 1.0),
      ('Wenn ein optionaler Ablauf nur bei Bedarf ergänzt wird', false, 0.0),
      ('Wenn ein Akteur mehrere Use Cases erbt', false, 0.0),
      ('Wenn ein Use Case außerhalb der Systemgrenze liegt', false, 0.0)
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

-- Beispiel 12: Use-Case (Schwer)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Was unterscheidet «extend» von «include» in Use-Case-Diagrammen am klarsten?', 3, 5, '{"topic":"uml","class":"Use-Case"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Was unterscheidet «extend» von «include» in Use-Case-Diagrammen am klarsten?'
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
    AND prompt = 'Was unterscheidet «extend» von «include» in Use-Case-Diagrammen am klarsten?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('«extend» ist optional/bedingt und erweitert einen Basis-Use-Case an Extension Points', true, 1.0),
      ('«extend» bedeutet, dass der Basis-Use-Case zwingend aufgerufen wird', false, 0.0),
      ('«include» wird nur zur Vererbung von Akteuren benutzt', false, 0.0),
      ('«include» ist optional und wird nur in Ausnahmen ausgeführt', false, 0.0)
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

-- Beispiel 13: Sequenzdiagramm (Leicht)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Achse repräsentiert in einem Sequenzdiagramm typischerweise den Zeitverlauf?', 1, 2, '{"topic":"uml","class":"Sequenzdiagramm"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Achse repräsentiert in einem Sequenzdiagramm typischerweise den Zeitverlauf?'
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
    AND prompt = 'Welche Achse repräsentiert in einem Sequenzdiagramm typischerweise den Zeitverlauf?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Die vertikale Achse (von oben nach unten)', true, 1.0),
      ('Die horizontale Achse (von links nach rechts)', false, 0.0),
      ('Keine Achse – Zeit wird durch Farben dargestellt', false, 0.0),
      ('Zeit wird nur durch Seitennummern dargestellt', false, 0.0)
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

-- Beispiel 14: Sequenzdiagramm (Schwer)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Wofür wird ein Combined Fragment «alt» in einem Sequenzdiagramm verwendet?', 3, 5, '{"topic":"uml","class":"Sequenzdiagramm"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Wofür wird ein Combined Fragment «alt» in einem Sequenzdiagramm verwendet?'
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
    AND prompt = 'Wofür wird ein Combined Fragment «alt» in einem Sequenzdiagramm verwendet?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Für alternative Abläufe (if/else) mit Guards', true, 1.0),
      ('Für Wiederholungen einer Nachricht (loop)', false, 0.0),
      ('Für parallele Ausführung (par)', false, 0.0),
      ('Für die Definition von Klassenattributen', false, 0.0)
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

-- Beispiel 15: Zustandsdiagramm (Leicht)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Was beschreibt ein UML-Zustandsdiagramm (State Machine Diagram) primär?', 1, 2, '{"topic":"uml","class":"Zustandsdiagramm"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Was beschreibt ein UML-Zustandsdiagramm (State Machine Diagram) primär?'
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
    AND prompt = 'Was beschreibt ein UML-Zustandsdiagramm (State Machine Diagram) primär?'
    AND difficulty = 1
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Zustände und Übergänge eines Objekts über seinen Lebenszyklus', true, 1.0),
      ('Akteure und ihre Interaktionen mit dem System', false, 0.0),
      ('Datenbanktabellen und deren Beziehungen', false, 0.0),
      ('Die Verteilung von Software auf Servern', false, 0.0)
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

-- Beispiel 16: Zustandsdiagramm (Schwer)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Was ist eine "Entry"-Action in einem UML-Zustandsdiagramm?', 3, 5, '{"topic":"uml","class":"Zustandsdiagramm"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Was ist eine "Entry"-Action in einem UML-Zustandsdiagramm?'
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
    AND prompt = 'Was ist eine "Entry"-Action in einem UML-Zustandsdiagramm?'
    AND difficulty = 3
    AND category = 'Multiple Choice'
  ORDER BY id DESC
  LIMIT 1
),
ins AS (
  SELECT q_id.id AS question_id, a.answer_text, a.is_correct, a.partial_value
  FROM q_id,
    (VALUES
      ('Eine Aktion, die beim Betreten eines Zustands automatisch ausgeführt wird', true, 1.0),
      ('Eine Aktion, die den Startzustand definiert', false, 0.0),
      ('Ein Ereignis, das immer einen Zustand beendet', false, 0.0),
      ('Die Beschriftung einer Transition mit ihrer Guard', false, 0.0)
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

-- Beispiel 17: Multiple Choice (Use-Case-Diagramm)
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

-- Beispiel 18: Multiple Choice (Komponente Klassendiagraamm)
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
-- Beispiel 19: Multiple Choice (UML-Diagramm Aktivitäten darstellen)
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
-- Beispiel 20: Multiple Choice (Use-Case-Diagramm Akteur)
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
-- Beispiel 21: Multiple Choice (Beziehung zwischen Klassen)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'MC', 'Welche Beziehung beschreibt eine „ist-ein“-Beziehung zwischen Klassen?', 1, 2, '{"topic":"uml"}', 'Multiple Choice'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'MC'
      AND prompt = 'Welche Beziehung beschreibt eine „ist-ein“-Beziehung zwischen Klassen?'
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
    AND prompt = 'Welche Beziehung beschreibt eine „ist-ein“-Beziehung zwischen Klassen?'
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
-- Beispiel 22: Multiple Choice (UML Startpunkt Aktivitätsdiagramm)
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

-- Beispiel 23: Multiple Choice (UML Deployment-Diagramm)
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

-- Beispiel 24: Lückentext (Use-Case-Diagramm Interaktion)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Use-Case-Diagramm stellt die Interaktion zwischen dem System und den ___ dar.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Use-Case-Diagramm stellt die Interaktion zwischen dem System und den ___ dar.'
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
    AND prompt = 'Ein Use-Case-Diagramm stellt die Interaktion zwischen dem System und den ___ dar.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Akteuren', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- Beispiel 25: Lückentext (Klassendiagramm Komponenten)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Klassendiagramm besteht unter anderem aus Klassen, Attributen und ___.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Klassendiagramm besteht unter anderem aus Klassen, Attributen und ___.'
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
    AND prompt = 'Ein Klassendiagramm besteht unter anderem aus Klassen, Attributen und ___.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Methoden', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- Beispiel 26: Lückentext (Aktivitätsdiagramm Prozess)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Aktivitätsdiagramm wird verwendet, um den ___ eines Prozesses darzustellen.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Aktivitätsdiagramm wird verwendet, um den ___ eines Prozesses darzustellen.'
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
    AND prompt = 'Ein Aktivitätsdiagramm wird verwendet, um den ___ eines Prozesses darzustellen.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Ablauf', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- Beispiel 27: Lückentext (Klassendiagramm Klassen)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'In UML werden Klassen in einem Klassendiagramm durch ___ dargestellt.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'In UML werden Klassen in einem Klassendiagramm durch ___ dargestellt.'
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
    AND prompt = 'In UML werden Klassen in einem Klassendiagramm durch ___ dargestellt.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'Rechtecke', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- Beispiel 28: Lückentext (Deployment-Diagramm Verteilung)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  SELECT 'CLOZE', 'Ein Deployment-Diagramm zeigt die ___ Verteilung eines Softwaresystems.', 2, 3, '{"topic":"uml"}', 'Lückentext'
  WHERE NOT EXISTS (
    SELECT 1 FROM questions
    WHERE type = 'CLOZE'
      AND prompt = 'Ein Deployment-Diagramm zeigt die ___ Verteilung eines Softwaresystems.'
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
    AND prompt = 'Ein Deployment-Diagramm zeigt die ___ Verteilung eines Softwaresystems.'
    AND difficulty = 2
    AND category = 'Lückentext'
  ORDER BY id DESC
  LIMIT 1
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q_id.id, 1, 'physische', 1.0
FROM q_id
ON CONFLICT (question_id, token_index) DO NOTHING;

-- End of seed file
