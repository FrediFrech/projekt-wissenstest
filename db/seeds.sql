-- Datei: db/seeds.sql
-- Dieses Skript legt Beispiel-Daten an, damit man die App lokal testen kann (Admin-User + Fragen).
-- Es muss nach db/schema.sql ausgeführt werden, damit die Tabellen vorhanden sind.
-- Seed data for UML Wissenstest (Postgres)
-- Replace placeholders for password hashing with actual salted SHA‑256 hash values.
-- Example: if pgcrypto is available you can do:
--   SELECT encode(digest('student' || 'somesalt','sha256'),'hex');
-- and then plug the salt and hash below.

-- Student user (student / student)
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'student',
  'student@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896', 
  '00000000000000000000000000000000',
  'student'
);

-- Admin user (lehrer / student)
-- Password 'student' hash is same as above
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'lehrer',
  'lehrer@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896', 
  '00000000000000000000000000000000',
  'admin'
);

-- Teacher 2 (teacher2 / teacher)
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'teacher2',
  'teacher2@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896', 
  '00000000000000000000000000000000',
  'admin'
);

-- Student 2 (student2 / student)
INSERT INTO users (username, email, password_hash, password_salt, role)
VALUES (
  'student2',
  'student2@example.com',
  '97ef5ea559b44566e403ee1c0b4b9352b32cda56a6117eb9205999e2a8802896', 
  '00000000000000000000000000000000',
  'student'
);

-- Beispiel 1: Multiple Choice
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  VALUES ('MC', 'Welche UML-Diagrammart beschreibt die Struktur von Klassen?', 1, 2, '{"topic":"uml"}', 'Multiple Choice')
  RETURNING id
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT q.id, a.answer_text, a.is_correct, a.partial_value
FROM q,
  (VALUES
    ('Klassendiagramm', true, 1.0),
    ('Aktivitätsdiagramm', false, 0.0),
    ('Use-Case-Diagramm', false, 0.0),
    ('Sequenzdiagramm', false, 0.0)
  ) AS a(answer_text, is_correct, partial_value);

-- Beispiel 2: Lückentext
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  VALUES ('CLOZE', 'In UML beschreibt das ___ Diagramm die Abläufe zwischen Objekten.', 2, 3, '{"topic":"uml"}', 'Lückentext')
  RETURNING id
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q.id, 1, 'Sequenz', 1.0 FROM q;

-- Beispiel 3: Multiple Choice
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  VALUES ('MC', 'Welche Aussage trifft auf ein Use-Case-Diagramm zu?', 1, 2, '{"topic":"uml"}', 'Multiple Choice')
  RETURNING id
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT q.id, a.answer_text, a.is_correct, a.partial_value
FROM q,
  (VALUES
    ('Es zeigt Akteure und ihre Interaktionen mit dem System', true, 1.0),
    ('Es zeigt die zeitliche Reihenfolge von Nachrichten', false, 0.0),
    ('Es beschreibt die physische Server-Struktur', false, 0.0),
    ('Es listet Java-Klassen auf', false, 0.0)
  ) AS a(answer_text, is_correct, partial_value);

-- Beispiel 4: Lückentext
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  VALUES ('CLOZE', 'Ein ___ Diagramm zeigt den Lebenszyklus eines Objekts mit Zuständen und Übergängen.', 2, 3, '{"topic":"uml"}', 'Lückentext')
  RETURNING id
)
INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value)
SELECT q.id, 1, 'Zustands', 1.0 FROM q;

-- Beispiel 5: Multiple Choice (mittel/schwer)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  VALUES ('MC', 'Was beschreibt ein Sequenzdiagramm am genauesten?', 2, 3, '{"topic":"uml"}', 'Multiple Choice')
  RETURNING id
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT q.id, a.answer_text, a.is_correct, a.partial_value
FROM q,
  (VALUES
    ('Nachrichtenfluss zwischen Objekten über die Zeit', true, 1.0),
    ('Klassen und ihre Attribute', false, 0.0),
    ('Komponenten eines Deployments', false, 0.0),
    ('Datenbanktabellen und Beziehungen', false, 0.0)
  ) AS a(answer_text, is_correct, partial_value);

-- Sample attempt seed (optional)
-- INSERT INTO attempts (user_id, total_points, max_points, difficulty) VALUES (1, 0, 0, 1);

-- Beispiel 6: Multiple Choice (Hard)
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category)
  VALUES ('MC', 'Welches Entwurfsmuster gehört NICHT zu den GoF-Mustern?', 3, 5, '{"topic":"patterns"}', 'Multiple Choice')
  RETURNING id
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT q.id, a.answer_text, a.is_correct, a.partial_value
FROM q,
  (VALUES
    ('MVC (Model View Controller)', true, 1.0),
    ('Singleton', false, 0.0),
    ('Factory Method', false, 0.0),
    ('Observer', false, 0.0)
  ) AS a(answer_text, is_correct, partial_value);

-- Beispiel 7: Bild mit Antwort
WITH q AS (
  INSERT INTO questions (type, prompt, difficulty, points, meta, category, image_url)
  VALUES ('MC', 'Was zeigt dieses Diagramm?', 2, 4, '{"topic":"uml"}', 'Bild mit Antwort', '/assets/diagram_example.png')
  RETURNING id
)
INSERT INTO answers (question_id, answer_text, is_correct, partial_value)
SELECT q.id, a.answer_text, a.is_correct, a.partial_value
FROM q,
  (VALUES
    ('Klassendiagramm', true, 1.0),
    ('Komponentendiagramm', false, 0.0),
    ('Verteilungsdiagramm', false, 0.0),
    ('Objektdiagramm', false, 0.0)
  ) AS a(answer_text, is_correct, partial_value);

-- End of seed file
