# Klassendiagramm - Backend Architektur

## 1. Model Layer - Datenmodelle

```
┌─────────────────────────────┐
│          User               │
├─────────────────────────────┤
│ - id: int                   │
│ - username: String          │
│ - email: String             │
│ - passwordHash: String      │
│ - passwordSalt: String      │
│ - role: String              │
│ - resetRequested: boolean   │
│ - createdAt: OffsetDateTime │
├─────────────────────────────┤
│ + getId(): int              │
│ + getUsername(): String     │
│ + setPassword(pwd): void    │
└─────────────────────────────┘

┌─────────────────────────────┐
│        Question             │
├─────────────────────────────┤
│ - id: int                   │
│ - prompt: String            │
│ - type: QuestionType        │
│ - difficulty: int           │
│ - points: int               │
│ - category: String          │
│ - imageUrl: String          │
├─────────────────────────────┤
│ + getId(): int              │
│ + getType(): QuestionType   │
│ + getAnswerOptions(): List  │
└─────────────────────────────┘
         ↑
         │ uses
         │
┌─────────────────────────────┐
│     QuestionType (Enum)     │
├─────────────────────────────┤
│ MC                           │
│ CLOZE                        │
│ FREE                         │
│ IMAGE                        │
└─────────────────────────────┘

┌─────────────────────────────┐
│    AnswerOption             │
├─────────────────────────────┤
│ - id: int                   │
│ - questionId: int           │
│ - answerText: String        │
│ - isCorrect: boolean        │
│ - partialValue: double      │
├─────────────────────────────┤
│ + getId(): int              │
│ + getOptionText(): String   │
└─────────────────────────────┘

┌─────────────────────────────┐
│       Attempt               │
├─────────────────────────────┤
│ - id: int                   │
│ - userId: int               │
│ - totalPoints: double       │
│ - maxPoints: double         │
│ - grade: String             │
│ - durationSeconds: int      │
│ - createdAt: OffsetDateTime │
├─────────────────────────────┤
│ + getId(): int              │
│ + getScore(): int           │
│ + getGrade(): int           │
│ + getAnswers(): List        │
└─────────────────────────────┘

┌─────────────────────────────┐
│    AttemptAnswer            │
├─────────────────────────────┤
│ - id: int                   │
│ - attemptId: int            │
│ - questionId: int           │
│ - givenAnswer: String       │
│ - pointsAwarded: double     │
├─────────────────────────────┤
│ + getGivenAnswer(): String  │
│ + isCorrect(): boolean      │
└─────────────────────────────┘

┌─────────────────────────────┐
│     ClozeToken              │
├─────────────────────────────┤
│ - id: int                   │
│ - questionId: int           │
│ - expectedText: String      │
│ - tokenIndex: int           │
├─────────────────────────────┤
│ + getTokenText(): String    │
│ + getPosition(): int        │
└─────────────────────────────┘
```

---

## 2. DAO Layer - Datenzugriff

### Interface & Implementation Pattern

```
┌──────────────────────────────┐
│   <<interface>>              │
│       UserDao                │
├──────────────────────────────┤
│ + findById(id): User         │
│ + findByUsername(un): User   │
│ + create(user): void         │
│ + update(user): void         │
│ + delete(id): void           │
│ + findAll(): List<User>      │
└──────────────────────────────┘
         ↑
         │ implements
         │
┌──────────────────────────────┐
│    JdbcUserDao               │
├──────────────────────────────┤
│ - connectionManager: Mgr     │
├──────────────────────────────┤
│ + findById(id): User         │
│ + findByUsername(un): User   │
│ + create(user): void         │
│ + update(user): void         │
│ + delete(id): void           │
│ + findAll(): List<User>      │
│ - mapResultSet(rs): User     │
└──────────────────────────────┘

        Similar Pattern for:
     - QuestionRepository / JdbcQuestionRepository (JdbcQuestionDao = Alias)
   - AttemptDao / JdbcAttemptDao
   - AnswerDao / JdbcAnswerDao
   - ClozeTokenDao / JdbcClozeTokenDao
```

### DAO Zusammenhang
```
     JdbcUserDao
          │
          ├─→ queries: users table
          │
     JdbcQuestionDao
          │
          ├─→ queries: questions table
          ├─→ uses: JdbcAnswerDao (für Options)
          ├─→ uses: JdbcClozeTokenDao (für Lücken)
          │
     JdbcAttemptDao
          │
          ├─→ queries: attempts & attempt_answers
          │
     JdbcAnswerDao
          │
          └─→ queries: answers table
```

---

## 3. Service Layer - Business Logik

```
┌──────────────────────────────┐
│    AuthService               │
├──────────────────────────────┤
│ - userDao: UserDao           │
│ - passwordUtils: PasswordUtil│
├──────────────────────────────┤
│ + register(un, email, pwd)   │
│ + login(un, pwd): User       │
│ + validatePassword(pwd): bool│
│ + hashPassword(pwd): String  │
└──────────────────────────────┘

┌──────────────────────────────┐
│    TestService               │
├──────────────────────────────┤
│ - questionDao: QuestionDao   │
│ - attemptDao: AttemptDao     │
│ - answerDao: AnswerDao       │
├──────────────────────────────┤
│ + getRandomQuestions(n): []  │
│ + evaluateAnswer(q, a): bool │
│ + calculateScore(attempt): # │
│ + assignGrade(score): int    │
│ + saveAttempt(attempt): void │
└──────────────────────────────┘

┌──────────────────────────────┐
│   ProgressionService         │
├──────────────────────────────┤
│ - attemptDao: AttemptDao     │
│ - userDao: UserDao           │
├──────────────────────────────┤
│ + getAttemptHistory(userId)  │
│ + getAverageScore(userId): # │
│ + getGradeDistribution(): {} │
│ + isProgressMade(userId): bo │
└──────────────────────────────┘

┌──────────────────────────────┐
│    AdminService              │
├──────────────────────────────┤
│ - questionDao: QuestionDao   │
│ - userDao: UserDao           │
│ - attemptDao: AttemptDao     │
├──────────────────────────────┤
│ + createQuestion(q): void    │
│ + updateQuestion(q): void    │
│ + deleteQuestion(id): void   │
│ + deactivateUser(id): void   │
│ + getStatistics(): Map       │
│ + getAllAttempts(): List     │
└──────────────────────────────┘
```

---

## 4. Web/Servlet Layer - HTTP Handler

```
┌──────────────────────────────┐
│  HttpServlet (javax)         │
└──────────────┬───────────────┘
               │ extends
               │
      ┌────────┴────────┐
      │                 │
┌─────────────────┐  ┌──────────────────┐
│  AuthServlet    │  │  TestServlet     │
├─────────────────┤  ├──────────────────┤
│ - authSvc: AS   │  │ - testSvc: TS    │
│ - jsonUtil: JU  │  │ - progressSvc: PS│
├─────────────────┤  ├──────────────────┤
│ + doPost()      │  │ + doGet()        │
│   - /register   │  │   - /test/list   │
│   - /login      │  │   - /test/start  │
│ + doGet()       │  │ + doPost()       │
│   - /logout     │  │   - /test/answer │
├─────────────────┤  └──────────────────┘
│Requests        │
│{json}          │  ┌──────────────────┐
└─────────────────┘  │ AdminServlet     │
                     ├──────────────────┤
                     │ - adminSvc: AS   │
                     │ - authSvc: AS    │
                     ├──────────────────┤
                     │ + doGet()        │
                     │   - /admin/stats │
                     │ + doPost()       │
                     │   - /admin/q/add │
                     │   - /admin/q/del │
                     └──────────────────┘

         All Servlets
         └─→ use CorsFilter
            └─→ use JsonUtil
            └─→ use ServletUtils
```

---

## 5. Abhängigkeitsgraf (Dependency Graph)

```
Web Layer
  │
  ├─→ AuthServlet → AuthService
  ├─→ TestServlet → TestService, ProgressionService
  └─→ AdminServlet → AdminService, AuthService
            │
            ↓
Service Layer
  │
  ├─→ AuthService → UserDao, PasswordUtils
  ├─→ TestService → QuestionDao, AttemptDao, AnswerDao
  ├─→ ProgressionService → AttemptDao, UserDao
  └─→ AdminService → QuestionDao, UserDao, AttemptDao
            │
            ↓
DAO Layer
  │
  ├─→ UserDao (Interface)
  │   └─→ JdbcUserDao (Implementation)
  ├─→ QuestionDao (Interface)
  │   └─→ JdbcQuestionDao (Implementation)
  │       ├─→ uses JdbcAnswerDao
  │       └─→ uses JdbcClozeTokenDao
  ├─→ AttemptDao (Interface)
  │   └─→ JdbcAttemptDao (Implementation)
  │       └─→ uses JdbcAttemptAnswerDao
  ├─→ AnswerDao (Interface)
  │   └─→ JdbcAnswerDao (Implementation)
  └─→ ClozeTokenDao (Interface)
      └─→ JdbcClozeTokenDao (Implementation)
            │
            ↓
Model Layer + Utilities
  │
  ├─→ Model Classes: User, Question, Attempt, etc.
  ├─→ DbConnectionManager (Datenbankverbindung)
  └─→ PasswordUtils (Passwort-Hashing)
            │
            ↓
Database Layer
  │
  └─→ PostgreSQL 15 (SQL Queries)
```

---

## 6. Sequenzdiagramm - Kompletter Test-Ablauf

```
Browser          Frontend        AuthServlet    TestServlet    Service Layer    DAO Layer    Database
  │                 │                 │              │              │              │            │
  │─ Login ────────→│                 │              │              │              │            │
  │                 │─ POST /login ───→│              │              │              │            │
  │                 │                 │─ AuthService─→│              │              │            │
  │                 │                 │              │─ findUser(). │              │            │
  │                 │                 │              │              │─ SQL Query ──→│            │
  │                 │                 │              │              │              │─ SELECT ──→│
  │                 │                 │              │              │              │← rows ─────│
  │                 │                 │              │              │← User obj ───│            │
  │                 │                 │← verify pwd ←│              │              │            │
  │                 │← JSON {token} ───│              │              │              │            │
  │← login OK ──────│                 │              │              │              │            │
  │                 │                 │              │              │              │            │
  │─ Get Test ─────→│                 │              │              │              │            │
  │                 │─ GET /test/list──────────────→│              │              │            │
  │                 │                 │              │─ TestService │              │            │
  │                 │                 │              │              │─ getQuest() ─→│            │
  │                 │                 │              │              │              │─ SELECT ──→│
  │                 │                 │              │              │              │← questions │
  │                 │← JSON [questions]──────────────│              │              │            │
  │← show quiz ────→│                 │              │              │              │            │
  │                 │                 │              │              │              │            │
  │─ Answer ───────→│                 │              │              │              │            │
  │                 │─ POST /test/ans ────────────→│              │              │            │
  │                 │                 │              │─ TestService │              │            │
  │                 │                 │              │              │─ evaluate() ─│            │
  │                 │                 │              │              │─ calcScore() │            │
  │                 │                 │              │              │─ saveAttempt ─→│          │
  │                 │                 │              │              │              │─ INSERT ──→│
  │                 │                 │              │              │              │← success ──│
  │                 │← JSON {score} ───────────────│              │              │            │
  │← show result ──→│                 │              │              │              │            │
  │                 │                 │              │              │              │            │
```

---

## 7. Fehlerbaumdiagramm (Deployment/Testen)

```
Deployment erfolgreich?
│
├─ Nein: Fehler in Compilation?
│  ├─ Nein: Fehler in Dependencies?
│  │  ├─ Nein: Fehler in Konfiguration?
│  │  │  └─ db.properties korrekt?
│  │  │     └─ PostgreSQL läuft?
│  │  └─ Ja: Maven-Update ausführen
│  └─ Ja: Fehler in Code beheben
│
└─ Ja: Runtime erfolgreich?
   ├─ Nein: Fehler in DB-Verbindung?
   │  └─ Connection-String prüfen
   └─ Ja: Tests erfolgreich?
      ├─ Nein: Fehler in Test?
      │  └─ TestUtils verwenden für Daten
      └─ Ja: Production-ready!
```
