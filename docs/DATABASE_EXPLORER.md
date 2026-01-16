# Datenbank-Diagramm & Explorer

## 1. Datenbankverbindung und Konfiguration

```
┌────────────────────────────────────────────────────┐
│  DbConnectionManager.java                          │
│  (Singleton Pattern)                               │
├────────────────────────────────────────────────────┤
│ - INSTANCE: static DbConnectionManager             │
│ - jdbcUrl: String                                  │
│ - driver: String (PostgreSQL JDBC)                 │
│                                                    │
│ + getInstance(): DbConnectionManager (Singleton)   │
│ + getConnection(): Connection                      │
│ + closeConnection(Connection): void                │
│                                                    │
│ Config Source:                                     │
│  └─ db.properties (JDBC URL, Credentials)          │
└────────────────────────────────────────────────────┘
         │
         ▼ uses
    PostgreSQL 15
    localhost:5432
    Database: wissentest_db
    User: student
    Password: student
```

---

## 2. Tabellen-Schema (SQL-Struktur)

### Vollständiges ER-Diagramm

```
┌────────────────────┐
│      USERS         │
├────────────────────┤
│ id (PK) INT        │───┐
│ username UNIQUE    │   │
│ email UNIQUE       │   │
│ password_hash      │   │
│ is_admin BOOL      │   │
│ created_at TIMESTAMP   │
└────────────────────┘   │
                         │ (1:n)
                         │
                         │
                    ┌────────────────────┐
                    │     ATTEMPTS       │
                    ├────────────────────┤
                    │ id (PK) INT        │───┐
                    │ user_id (FK) ──────┘   │
                    │ score INT              │
                    │ max_score INT          │
                    │ grade INT (1-6)        │
                    │ completed_at TS        │
                    └────────────────────┘   │
                             │               │ (1:n)
                             │               │
                             │          ┌────────────────────────┐
                             └─────────→│  ATTEMPT_ANSWERS       │
                                        ├────────────────────────┤
                                        │ id (PK) INT            │
                                        │ attempt_id (FK) ───────┘
                                        │ question_id (FK) ──┐
                                        │ given_answer       │
                                        │ is_correct BOOL    │
                                        └────────────────────┘
                                                 ↑
                                                 │ (n:1)
                                                 │
                                        ┌────────────────────┐
                                        │    QUESTIONS       │
                                        ├────────────────────┤
                                        │ id (PK) INT        │───┐
                                        │ question_text      │   │
                                        │ question_type ENUM │   │ (1:n)
                                        │  (MC/CLOZE)        │   │
                                        │ difficulty INT     │   │
                                        │ created_at TS      │   │
                                        └────────────────────┘   │
                                                 ↑                │
                                        (1:n)    │               │
                                        ┌────────┴──────┐       │
                                        │               │       │
                                  ┌─────────────────┐  │  ┌──────────────────┐
                                  │ ANSWER_OPTIONS  │  │  │  CLOZE_TOKENS    │
                                  ├─────────────────┤  │  ├──────────────────┤
                                  │ id (PK) INT     │  │  │ id (PK) INT      │
                                  │ question_id ────┘  │  │ question_id ─────┘
                                  │ option_text        │  │ token_text       │
                                  │ is_correct BOOL    │  │ position INT      │
                                  └─────────────────┘  │  └──────────────────┘
                                                       │
                                        (1:n)         │
                                        ─────────────┘
```

---

## 3. Tabellen Details

### USERS
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

Indizes:
- PK: id
- UNIQUE: username, email
- Optional: created_at (für Sortierung)
```

**Beispiel-Daten:**
```
| id | username | email              | is_admin | created_at      |
|----|----------|--------------------|---------|--------------------|
| 1  | student1 | student1@example.. | false   | 2024-01-10 10:30 |
| 2  | admin1   | admin@example.com  | true    | 2024-01-01 09:00 |
| 3  | student2 | student2@example.. | false   | 2024-01-11 14:20 |
```

---

### QUESTIONS
```sql
CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  question_text TEXT NOT NULL,
  question_type ENUM ('MULTIPLE_CHOICE', 'CLOZE_TEXT'),
  difficulty INT CHECK (difficulty BETWEEN 1 AND 5),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

Indizes:
- PK: id
- Optional: question_type, difficulty (für Abfragen)
```

**Beispiel-Daten:**
```
| id | question_text                | type           | difficulty |
|----|-------------------------------|----------------|------------|
| 1  | Was ist die Hauptstadt..?     | MULTIPLE_CHOICE| 1          |
| 2  | Der größte Planet ist ____    | CLOZE_TEXT     | 2          |
| 3  | Die Formel für Geschwindigkeit| CLOZE_TEXT     | 3          |
```

---

### ANSWER_OPTIONS
```sql
CREATE TABLE answer_options (
  id SERIAL PRIMARY KEY,
  question_id INT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  option_text VARCHAR(255) NOT NULL,
  is_correct BOOLEAN DEFAULT FALSE
);

Indizes:
- PK: id
- FK: question_id
- Optional: question_id (für Index)
```

**Beispiel-Daten (für Question 1):**
```
| id | question_id | option_text | is_correct |
|----|-------------|-------------|-----------|
| 1  | 1           | Berlin      | true      |
| 2  | 1           | München     | false     |
| 3  | 1           | Hamburg     | false     |
```

---

### CLOZE_TOKENS
```sql
CREATE TABLE cloze_tokens (
  id SERIAL PRIMARY KEY,
  question_id INT NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  token_text VARCHAR(255) NOT NULL,
  position INT NOT NULL
);

Indizes:
- PK: id
- FK: question_id
```

**Beispiel-Daten (für Question 2):**
```
| id | question_id | token_text | position |
|----|-------------|-----------|----------|
| 1  | 2           | Jupiter   | 0        |
```

---

### ATTEMPTS
```sql
CREATE TABLE attempts (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  score INT NOT NULL,
  max_score INT NOT NULL,
  grade INT CHECK (grade BETWEEN 1 AND 6),
  completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

Indizes:
- PK: id
- FK: user_id
- Optional: user_id, completed_at (für Abfragen)
```

**Beispiel-Daten:**
```
| id | user_id | score | max_score | grade | completed_at        |
|----|---------|-------|-----------|-------|---------------------|
| 1  | 1       | 85    | 100       | 2     | 2024-01-15 11:20 |
| 2  | 1       | 72    | 100       | 3     | 2024-01-16 14:10 |
| 3  | 3       | 95    | 100       | 1     | 2024-01-16 15:30 |
```

---

### ATTEMPT_ANSWERS
```sql
CREATE TABLE attempt_answers (
  id SERIAL PRIMARY KEY,
  attempt_id INT NOT NULL REFERENCES attempts(id) ON DELETE CASCADE,
  question_id INT NOT NULL REFERENCES questions(id),
  given_answer VARCHAR(255),
  is_correct BOOLEAN
);

Indizes:
- PK: id
- FK: attempt_id, question_id
```

**Beispiel-Daten (Versuch 1, Frage 1):**
```
| id | attempt_id | question_id | given_answer | is_correct |
|----|------------|-------------|--------------|-----------|
| 1  | 1          | 1           | Berlin       | true      |
| 2  | 1          | 2           | Jupiter      | true      |
| 3  | 1          | 3           | v = d/t      | true      |
```

---

## 4. Datenbankzugriff - Query Beispiele

### In JdbcUserDao
```java
// SELECT
String sql = "SELECT * FROM users WHERE username = ?";
ResultSet rs = stmt.executeQuery();

// INSERT
String sql = "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)";
stmt.executeUpdate();

// UPDATE
String sql = "UPDATE users SET is_admin = ? WHERE id = ?";
stmt.executeUpdate();

// DELETE
String sql = "DELETE FROM users WHERE id = ?";
stmt.executeUpdate();
```

### In JdbcQuestionDao
```java
// Zufällige Fragen laden
String sql = "SELECT * FROM questions ORDER BY RANDOM() LIMIT 10";
ResultSet rs = stmt.executeQuery();

// Mit Schwierigkeit filtern
String sql = "SELECT * FROM questions WHERE difficulty >= ? ORDER BY RANDOM() LIMIT ?";
stmt.setInt(1, minDifficulty);
stmt.setInt(2, count);
```

### In JdbcAttemptDao
```java
// Versuch speichern + Antworten
String sql = "INSERT INTO attempts (user_id, score, max_score, grade) VALUES (?, ?, ?, ?)";
stmt.executeUpdate();

// Verlauf abrufen
String sql = "SELECT * FROM attempts WHERE user_id = ? ORDER BY completed_at DESC";
ResultSet rs = stmt.executeQuery();
```

---

## 5. Transaktionsbeispiel (Test durchführen)

```
BenutzerKlick → TestServlet.doPost()
     │
     ├─ Connection.setAutoCommit(false)  // Begin Transaction
     │
     ├─ INSERT INTO attempts (...)       // Versuch erstellen
     │  └─ Get attempt_id
     │
     ├─ FOR each question/answer:
     │  └─ INSERT INTO attempt_answers (...)
     │
     ├─ Calculate Score & Grade
     │
     ├─ UPDATE attempts SET score=?, grade=?
     │
     ├─ IF all successful:
     │  └─ Connection.commit()  // COMMIT
     │
     └─ ELSE:
        └─ Connection.rollback()  // ROLLBACK
```

---

## 6. Datenbank-Explorations-Befehle (psql)

```bash
# Verbindung
psql -U student -d wissentest_db -h localhost

# Tabellen anzeigen
\dt

# Schema ansehen
\d users
\d questions
\d attempts
\d answer_options
\d cloze_tokens
\d attempt_answers

# Beispiel-Abfragen
SELECT COUNT(*) FROM users;
SELECT * FROM questions LIMIT 5;
SELECT u.username, COUNT(a.id) FROM users u LEFT JOIN attempts a ON u.id = a.user_id GROUP BY u.id;

# Daten löschen (bei Bedarf)
DELETE FROM attempt_answers;
DELETE FROM attempts;
TRUNCATE users RESTART IDENTITY;
```

---

## 7. Backup & Restore

### Backup erstellen
```bash
pg_dump -U student -d wissentest_db > backup.sql
```

### Aus Backup wiederherstellen
```bash
psql -U student -d wissentest_db < backup.sql
```

---

## 8. Performance-Tipps

| Problem | Lösung |
|---------|--------|
| Langsame SELECT bei vielen Attempts | Index auf `attempts(user_id, completed_at)` |
| Langsame Fragen-Auswahl | Index auf `questions(difficulty)` |
| Doppelte User-Namen | UNIQUE Constraint (bereits vorhanden) |
| Verwaiste Attempt-Daten | CASCADE DELETE auf FKs (bereits vorhanden) |

---

## 9. Seed-Daten (seeds.sql)

Die Datei `db/seeds.sql` enthält initiale Test-Daten:

```sql
INSERT INTO users (username, email, password_hash, is_admin) VALUES
  ('student1', 'student1@example.com', '...hash...', false),
  ('student2', 'student2@example.com', '...hash...', false),
  ('admin', 'admin@example.com', '...hash...', true);

INSERT INTO questions (question_text, question_type, difficulty) VALUES
  ('Was ist die Hauptstadt von Deutschland?', 'MULTIPLE_CHOICE', 1),
  ('Der größte Planet ist ____', 'CLOZE_TEXT', 2),
  ('Die Formel für Arbeit ist ____', 'CLOZE_TEXT', 4);

-- ... weitere Daten
```

**Daten laden:**
```bash
psql -U student -d wissentest_db < db/seeds.sql
```
