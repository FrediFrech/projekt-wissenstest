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
    localhost:5433
    Database: wissentest
    User: student
    Password: student
```

---

## 2. Tabellen-Schema (SQL-Struktur)

Hinweis: Die folgenden Diagramme und DDL-Snippets sind am `db/schema.sql` aus dem Repository orientiert und entsprechen der in der Projekt-Startlogik (startup/start_project.ps1) verwendeten Schema-Import-Routine.

### Vollständiges ER-Diagramm (konform)

```
┌────────────────────────────────────────┐
│                USERS                   │
├────────────────────────────────────────┤
│ id (PK) SERIAL                         │
│ username VARCHAR(100) UNIQUE NOT NULL  │
│ email VARCHAR(255) UNIQUE              │
│ password_hash VARCHAR(256) NOT NULL    │
│ password_salt VARCHAR(128) NOT NULL    │
│ role VARCHAR(32) DEFAULT 'student'     │
│ reset_requested BOOLEAN DEFAULT FALSE  │
│ created_at TIMESTAMPTZ DEFAULT now()   │
└────────────────────────────────────────┘
                │
                │ (1:n)
                ▼
┌────────────────────────────────────────┐
│                ATTEMPTS                │
├────────────────────────────────────────┤
│ id (PK) SERIAL                         │
│ user_id INTEGER REFERENCES users(id)  │
│ total_points NUMERIC(8,4) DEFAULT 0.0 │
│ max_points NUMERIC(8,4) DEFAULT 0.0   │
│ difficulty SMALLINT CHECK (1..3)      │
│ grade VARCHAR(10)                     │
│ duration_seconds INTEGER DEFAULT 0    │
│ created_at TIMESTAMPTZ DEFAULT now()  │
└────────────────────────────────────────┘
                │
                │ (1:n)
                ▼
┌────────────────────────────────────────┐
│             ATTEMPT_ANSWERS            │
├────────────────────────────────────────┤
│ id (PK) SERIAL                         │
│ attempt_id INTEGER REFERENCES attempts│
│ question_id INTEGER REFERENCES questions
│ given_answer TEXT                      │
│ points_awarded NUMERIC(8,4) DEFAULT 0.0│
└────────────────────────────────────────┘
                ▲
                │ (n:1)
                │
┌────────────────────────────────────────┐
│               QUESTIONS                │
├────────────────────────────────────────┤
│ id (PK) SERIAL                         │
│ type VARCHAR(16) CHECK (IN ('MC','CLOZE'))
│ prompt TEXT NOT NULL                   │
│ difficulty SMALLINT CHECK (1..3)       │
│ points INTEGER DEFAULT 1               │
│ category VARCHAR(64) DEFAULT 'Allgemein'
│ image_url VARCHAR(255)                 │
│ meta JSONB DEFAULT '{}'::jsonb         │
│ created_by INTEGER REFERENCES users(id)
│ created_at TIMESTAMPTZ DEFAULT now()   │
└────────────────────────────────────────┘
         │             │
         │             │ (1:n)
         │ (1:n)       ▼
┌────────────────────┐    ┌────────────────────┐
│      ANSWERS        │    │   CLOZE_ANSWERS    │
├────────────────────┤    ├────────────────────┤
│ id (PK) SERIAL      │    │ id (PK) SERIAL     │
│ question_id INTEGER │    │ question_id INTEGER│
│ answer_text TEXT    │    │ token_index SMALLINT
│ is_correct BOOLEAN  │    │ expected_text TEXT │
│ partial_value NUMERIC(5,4) │ partial_value NUMERIC(5,4) DEFAULT 1.0
└────────────────────┘    └────────────────────┘
```

---

## 3. Tabellen Details (konform zum `db/schema.sql`)

### USERS
```sql
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
```

Wichtig: Das Backend speichert neben `password_hash` auch `password_salt`. Das Passwort-Handling verwendet iterierte SHA-256-Hashes (siehe `util/PasswordUtils.java`) — die Dokumentation und Tests gehen davon aus, dass Salt separat vorliegt.

**Beispiel-Daten (Beispielwerte, Salt/Hash gekürzt):**
```
| id | username | email               | role    | created_at           |
|----|----------|---------------------|---------|----------------------|
| 1  | student  | student@example.org | student | 2025-11-10 10:30+00  |
| 2  | teacher  | lehrer@example.org  | teacher | 2025-11-01 09:00+00  |
| 3  | admin    | admin@example.org   | admin   | 2025-11-11 14:20+00  |
```

---

### QUESTIONS
```sql
CREATE TABLE questions (
  id SERIAL PRIMARY KEY,
  type VARCHAR(16) NOT NULL CHECK (type IN ('MC','CLOZE')),
  prompt TEXT NOT NULL,
  difficulty SMALLINT NOT NULL CHECK (difficulty IN (1,2,3)),
  points INTEGER NOT NULL DEFAULT 1,
  category VARCHAR(64) DEFAULT 'Allgemein',
  image_url VARCHAR(255),
  meta JSONB DEFAULT '{}'::jsonb,
  created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);
```

Hinweis: Das Schema limitiert Typen derzeit auf `MC` und `CLOZE`. Falls das Java-Model zusätzliche Typen enthält, ist das bewusst vom Schema getrennt und erfordert eine Änderung von `db/schema.sql`, wenn neue Typen persistiert werden sollen.

**Beispiel-Daten:**
```
| id | prompt                          | type | difficulty | points |
|----|----------------------------------|------|------------|--------|
| 1  | Was ist die Hauptstadt von D?    | MC   | 1          | 1      |
| 2  | Der größte Planet ist ____       | CLOZE| 2          | 1      |
| 3  | Rechne: Arbeit = Kraft * Weg     | MC   | 3          | 2      |
```

---

### ANSWERS
```sql
CREATE TABLE answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  answer_text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT false,
  partial_value NUMERIC(5,4) NOT NULL DEFAULT 0.0 CHECK (partial_value >= 0 AND partial_value <= 1)
);
```

**Beispiel-Daten (für Question 1):**
```
| id | question_id | answer_text | is_correct | partial_value |
|----|-------------|-------------|------------|---------------|
| 1  | 1           | Berlin      | true       | 1.0000        |
| 2  | 1           | München     | false      | 0.0000        |
```

---

### CLOZE_ANSWERS
```sql
CREATE TABLE cloze_answers (
  id SERIAL PRIMARY KEY,
  question_id INTEGER NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  token_index SMALLINT NOT NULL,
  expected_text TEXT NOT NULL,
  partial_value NUMERIC(5,4) NOT NULL DEFAULT 1.0 CHECK (partial_value >= 0 AND partial_value <= 1),
  UNIQUE(question_id, token_index)
);
```

**Beispiel-Daten (für Frage 2):**
```
| id | question_id | token_index | expected_text | partial_value |
|----|-------------|-------------|---------------|---------------|
| 1  | 2           | 0           | Jupiter       | 1.0000        |
```

---

### ATTEMPTS
```sql
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
```

**Beispiel-Daten:**
```
| id | user_id | total_points | max_points | difficulty | grade | created_at           |
|----|---------|--------------|------------|------------|-------|----------------------|
| 1  | 1       | 85.0000      | 100.0000   | 2          | "2"  | 2025-11-15 11:20+00  |
```

---

### ATTEMPT_ANSWERS
```sql
CREATE TABLE attempt_answers (
  id SERIAL PRIMARY KEY,
  attempt_id INTEGER NOT NULL REFERENCES attempts(id) ON DELETE CASCADE,
  question_id INTEGER REFERENCES questions(id) ON DELETE SET NULL,
  given_answer TEXT,
  points_awarded NUMERIC(8,4) NOT NULL DEFAULT 0.0
);
```

**Beispiel-Daten (Versuch 1, Frage 1):**
```
| id | attempt_id | question_id | given_answer | points_awarded |
|----|------------|-------------|--------------|----------------|
| 1  | 1          | 1           | Berlin       | 1.0000         |
| 2  | 1          | 2           | Jupiter      | 1.0000         |
```

---

## 4. Datenbankzugriff - Query Beispiele

(Die Beispiele orientieren sich an den DAO-Implementierungen in `mainlogik, backend/src/` und sind funktional gleich zu den SQL-Strings im Code.)

### In JdbcUserDao
```java
// SELECT
String sql = "SELECT * FROM users WHERE username = ?";
// INSERT (Salt + Hash stored separately)
String sql = "INSERT INTO users (username, email, password_hash, password_salt, role) VALUES (?, ?, ?, ?, ?)";
```

### In JdbcQuestionDao
```java
// Zufällige Fragen laden
String sql = "SELECT * FROM questions ORDER BY RANDOM() LIMIT 10";
```

### In JdbcAttemptDao
```java
// Versuch speichern + Antworten
String sql = "INSERT INTO attempts (user_id, total_points, max_points, difficulty, grade) VALUES (?, ?, ?, ?, ?)";
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
     ├─ UPDATE attempts SET total_points=?, grade=?
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
# Verbindung (Port beachten: 5433 wird lokal von startup/start_project.ps1 verwendet)
psql -U student -d wissentest -h localhost -p 5433

# Tabellen anzeigen
\dt

# Schema ansehen
\d users
\d questions
\d attempts
\d answers
\d cloze_answers
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
pg_dump -U student -d wissentest -p 5433 > backup.sql
```

### Aus Backup wiederherstellen
```bash
psql -U student -d wissentest -p 5433 < backup.sql
```

---

## 8. Performance-Tipps

| Problem | Lösung |
|---------|--------|
| Langsame SELECT bei vielen Attempts | Index auf `attempts(user_id, created_at)` oder `(user_id, created_at)` |
| Langsame Fragen-Auswahl | Index auf `questions(difficulty)` |
| Doppelte User-Namen | UNIQUE Constraint (bereits vorhanden auf `username`) |
| Verwaiste Attempt-Daten | CASCADE DELETE auf FKs (bereits vorhanden) |

---

## 9. Seed-Daten (seeds.sql)

Die Datei `db/seeds.sql` enthält initiale Test-Daten (Beispiel):

```sql
INSERT INTO users (username, email, password_hash, password_salt, role) VALUES
  ('student1', 'student1@example.com', '...hash...', '...salt...', 'student'),
  ('student2', 'student2@example.com', '...hash...', '...salt...', 'student'),
  ('admin', 'admin@example.com', '...hash...', '...salt...', 'admin');

INSERT INTO questions (prompt, type, difficulty) VALUES
  ('Was ist die Hauptstadt von Deutschland?', 'MC', 1),
  ('Der größte Planet ist ____', 'CLOZE', 2),
  ('Die Formel für Arbeit ist ____', 'MC', 3);

-- ... weitere Daten
```

**Daten laden:**
```bash
psql -U student -d wissentest -p 5433 < db/seeds.sql
```
