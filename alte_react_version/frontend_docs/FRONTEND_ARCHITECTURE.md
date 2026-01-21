# Frontend Architektur - React Komponentenbaum

## 1. Komponentenhierarchie

```
┌─────────────────────────────────────────────────────────┐
│                       App.jsx                           │
│        (Main App Container + Routing Logic)             │
├─────────────────────────────────────────────────────────┤
│ Props: none                                             │
│ State: currentUser, currentPage, notifications          │
│ Functions: handleNavigation(), handleLogout()           │
└────────────┬──────────────────────────────────────────────┘
             │
       ┌─────┴─────┬───────────┬──────────┬─────────┐
       │           │           │          │         │
       ▼           ▼           ▼          ▼         ▼
   LandingPage  Login      Register   TestList  TestRunner
   (Landing)    (Auth)     (Auth)     (Main)    (Main)
   
       │           │           │          │         │
       │           │           │          │         │
       ├───────────┼───────────┘          ├─────────┤
       │           │                      │         │
       ▼           ▼                      ▼         ▼
   Features   AuthForm          Results    Result
   (Display)  (Reusable)      (List/Grid) (Detail)
   
                                │         │
                                ▼         ▼
                            Result    FlipCard
                            Card      (Learning)
                          (Design)
                          
   ┌─────────────────────────────────────┐
   │        AdminPanel (Admin-Only)      │
   ├─────────────────────────────────────┤
   │ - Create Question Form              │
   │ - Delete Question Button            │
   │ - User Management Controls          │
   │ - Statistics Dashboard              │
   └─────────────────────────────────────┘
   
   ┌─────────────────────────────────────┐
   │     LearnMode (Study/Übung)         │
   ├─────────────────────────────────────┤
   │ - FlipCard Components (Liste)       │
   │ - Navigation Buttons                │
   │ - Progress Tracker                  │
   └─────────────────────────────────────┘
```

---

## 2. Detaillierte Komponentenbeschreibung

### App.jsx (Root)
```
┌─────────────────────────────────────────┐
│           App.jsx                       │
├─────────────────────────────────────────┤
│ State:                                  │
│  - currentUser: User | null             │
│  - currentPage: "landing" | "login" |   │
│    "register" | "test-list" |          │
│    "test-runner" | "result" | "admin"  │
│  - notifications: Message[]             │
│                                         │
│ Functions:                              │
│  - handleNavigation(page)               │
│  - handleLogout()                       │
│  - handleTestStart(testId)              │
│  - handleTestSubmit(answers)            │
│                                         │
│ Children Rendering:                     │
│  {currentUser ? <MainApp /> : <Auth />} │
└─────────────────────────────────────────┘
         │
         ├─ <LandingPage />        (if !user)
         ├─ <Login />              (if !user)
         ├─ <Register />           (if !user)
         ├─ <TestList />           (if user)
         ├─ <TestRunner />         (if user + active test)
         ├─ <Result />             (if user + test complete)
         ├─ <LearnMode />          (if user + learning)
         └─ <AdminPanel />         (if user + isAdmin)
```

### Komponenten-Matrix

| Komponente | Typ | Props | State | Funktion |
|-----------|-----|-------|-------|----------|
| **LandingPage** | Präsentation | onNavigate | none | Features anzeigen |
| **Login** | Form | onSuccess, onError | loading, error | User-Login |
| **Register** | Form | onSuccess, onError | loading, error | Registrierung |
| **TestList** | Container | userId | tests, loading | Test-Übersicht |
| **TestRunner** | Smart | testId, questions | answers, currentQ, score | Test-Durchführung |
| **Result** | Präsentation | attempt, test | none | Ergebnis-Anzeige |
| **AdminPanel** | Container | userId | stats, users, questions | Admin-Dashboard |
| **LearnMode** | Smart | questionSet | currentCard, progress | Flip-Card Lernen |
| **FlipCard** | Präsentation | question, onAnswer | isFlipped | Einzelne Karte |

---

## 3. Props-Datenfluss (Unidirektional)

```
App.jsx (State)
  │
  ├─→ onNavigate ──→ LandingPage
  ├─→ onLogin ──→ Login
  │   └─→ currentUser ──→ TestList
  │       └─→ userId ──→ TestList.questions
  │
  ├─→ testId ──→ TestRunner
  │   └─→ questions, onAnswer ──→ TestRunner.children
  │
  ├─→ attempt ──→ Result
  │   └─→ score, grade ──→ Result.display
  │
  ├─→ userId ──→ AdminPanel
  │   └─→ onCreateQuestion ──→ AdminPanel.form
  │
  └─→ questionSet ──→ LearnMode
      └─→ question ──→ FlipCard (einzeln)
```

---

## 4. Service-Integration (apiClient.js)

```
┌─────────────────────────────────────────────┐
│           apiClient.js                      │
│   (REST API Wrapper / HTTP Client)          │
├─────────────────────────────────────────────┤
│ BaseURL: "http://localhost:8080/api"        │
│                                             │
│ Methods:                                    │
│  + post(endpoint, data): Promise            │
│  + get(endpoint): Promise                   │
│  + put(endpoint, data): Promise             │
│  + delete(endpoint): Promise                │
│                                             │
│ Endpoints:                                  │
│  /auth/register  (POST)                     │
│  /auth/login     (POST)                     │
│  /auth/logout    (GET)                      │
│  /tests/list     (GET)                      │
│  /tests/{id}     (GET)                      │
│  /tests/{id}/submit (POST)                  │
│  /tests/progress (GET)                      │
│  /admin/stats    (GET)                      │
│  /admin/questions/add (POST)                │
│  /admin/questions/delete (DELETE)           │
│  /learn/questions (GET)                     │
└─────────────────────────────────────────────┘
         ↑ called by
         │
  ┌──────┴──────┬──────────┬────────────────┐
  │             │          │                │
  Login    TestRunner   LearnMode       AdminPanel
  (forms)  (actions)   (load cards)     (CRUD)
```

---

## 5. State-Management-Konzept

```
App.jsx (Global State)
│
├─ currentUser: User
│  ├─ id: number
│  ├─ username: string
│  ├─ email: string
│  └─ isAdmin: boolean
│
├─ currentPage: string
│
├─ notifications: Message[]
│  ├─ id: string
│  ├─ message: string
│  ├─ type: "error" | "success" | "info"
│  └─ timestamp: Date
│
└─ sessionData: object
   ├─ currentTest: Test (if active)
   ├─ currentAnswer: string (temp)
   └─ testStart: Date
```

**Lokal in Komponenten (wo nötig):**
- `TestRunner`: currentQuestionIndex, selectedAnswers
- `Login`: email, password, loading
- `AdminPanel`: selectedQuestion, formData

---

## 6. Event-Fluss (User-Interaktion)

```
User klickt → React Event Handler → State Update → Re-render
    │            │                     │              │
    ├─ "Login"   └─ handleLogin()     ├─ apiCall()  └─ <Login/>
    │                                 │               updates
    │                                 └─→ setState()   UI
    │
    ├─ "Submit Answer" → handleAnswer() → calcScore()
    │                   → saveAttempt()  → show Result
    │
    └─ "Start Test" → handleTestStart() → <TestRunner/>
                    → loadQuestions()   → display Q1
```

---

## 7. Styling-Architektur

```
┌─ styles/
│
└─ main.css
   ├─ CSS Variables (Farben, Abstände)
   ├─ Base Styles (Reset, Fonts)
   ├─ Layout (Grid, Flexbox)
   ├─ Components (Button, Card, Form)
   └─ Responsive Media Queries
   
Zusätzlich:
├─ Framer Motion (Animations in JSX)
│  ├─ transition: { duration: 0.6 }
│  ├─ initial: { opacity: 0 }
│  └─ animate: { opacity: 1 }
│
└─ Inline Styles in JSX
   ├─ Dynamic Backgrounds
   ├─ Conditional Colors
   └─ Responsive Padding
```

---

## 8. Rendering-Ablauf (Beispiel: Test starten)

```
Browser
  │
  ├─ User klickt "Start Test"
  │
  └─→ TestList.jsx
      ├─ onClick: handleTestStart(testId)
      │
      ├─→ App.jsx
      │   └─ setState({ currentPage: "test-runner", testId })
      │
      ├─→ React re-renders App
      │   └─ conditionalRender: <TestRunner testId={testId} />
      │
      ├─→ TestRunner.jsx mounted
      │   ├─ useEffect(() => loadQuestions(testId))
      │   │
      │   ├─→ apiClient.get("/tests/{testId}")
      │   │   ├─ HTTP GET to Backend
      │   │   └─ Backend fetches from DB
      │   │
      │   ├─→ setState({ questions: [...], currentIndex: 0 })
      │   │
      │   └─→ React renders <TestQuestion {...question} />
      │
      └─→ Display Question 1
          ├─ Framer Motion animation
          ├─ Input fields for answers
          └─ "Next" button
```

---

## 9. Performance-Optimierung

```
Optimierungen implementiert:
│
├─ Component Memoization (React.memo)
│  └─ FlipCard, Result (reine Präsentations-komponenten)
│
├─ useCallback für Event Handlers
│  └─ vermeidet unnötige Child-Renders
│
├─ useMemo für expensive calculations
│  └─ Score-Berechnung nur bei Bedarf
│
├─ Code Splitting mit Vite
│  └─ lazy loading von großen Komponenten
│
└─ API Caching
   └─ questions gecacht nach Load
```

---

## 10. Error Handling & Fallbacks

```
Try-Catch in API Calls:
│
├─ apiClient.get() fails
│  └─ catch(error) → setState({ error })
│  └─ Display: <ErrorMessage error={error} />
│
├─ DB Connection fails
│  └─ Backend returns 500
│  └─ Frontend shows "Server Error"
│
├─ Validation fails (Frontend)
│  └─ Display red border + warning
│
└─ Session expires
   └─ Redirect to Login
```
