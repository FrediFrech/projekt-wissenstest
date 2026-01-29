/*
 * Datei: TestServiceTest.java
 * Tests für zentrale Logik in TestService (Auswahl & Bewertung).
 */
package de.dhsn.wissentest.service;

import de.dhsn.wissentest.dao.*;
import de.dhsn.wissentest.model.*;
import org.junit.jupiter.api.Test;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

class TestServiceTest {

    @Test
    void startTestWithCategoryListFiltersByDifficultyAndCategory() {
        List<Question> questions = List.of(
                new Question(1, QuestionType.MC, "Q1", 2, 5, null, null, "Math"),
                new Question(2, QuestionType.MC, "Q2", 2, 5, null, null, "History"),
                new Question(3, QuestionType.MC, "Q3", 1, 5, null, null, "Math"),
                new Question(4, QuestionType.MC, "Q4", 2, 5, null, null, "Math")
        );

        InMemoryQuestionRepository questionRepo = new InMemoryQuestionRepository(questions);
        TestService service = new TestService(
                questionRepo,
                new InMemoryAnswerDao(),
                new InMemoryClozeTokenDao(),
                new InMemoryAttemptDao(),
                new InMemoryUserDao(),
                new EmptyConfigDao()
        );

        List<Question> result = service.startTest(2, 2, "All", List.of("Math"));

        assertEquals(2, result.size());
        for (Question q : result) {
            assertEquals(2, q.getDifficulty());
            assertEquals("Math", q.getCategory());
        }
        Set<Integer> ids = new HashSet<>();
        for (Question q : result) {
            ids.add(q.getId());
        }
        assertEquals(Set.of(1, 4), ids);
    }

    @Test
    void submitAttemptMultipleChoiceCorrectScoresFullPoints() {
        Question q = new Question(10, QuestionType.MC, "Capital?", 1, 10, null, null, "Geo");
        InMemoryQuestionRepository questionRepo = new InMemoryQuestionRepository(List.of(q));

        InMemoryAnswerDao answerDao = new InMemoryAnswerDao();
        answerDao.setAnswers(10, List.of(
                new AnswerOption(1, 10, "Berlin", true, 1.0),
                new AnswerOption(2, 10, "Paris", false, 0.0)
        ));

        InMemoryAttemptDao attemptDao = new InMemoryAttemptDao();

        TestService service = new TestService(
                questionRepo,
                answerDao,
                new InMemoryClozeTokenDao(),
                attemptDao,
                new InMemoryUserDao(),
                new EmptyConfigDao()
        );

        Map<Integer, Object> answers = Map.of(10, 1);
        AttemptResult result = service.submitAttempt(7, 1, List.of(10), answers, 30);

        assertNotNull(result);
        assertEquals(10.0, result.getAttempt().getTotalPoints(), 0.0001);
        assertEquals(10.0, result.getAttempt().getMaxPoints(), 0.0001);
        assertEquals("1", result.getAttempt().getGrade());
        assertEquals(1, attemptDao.lastSavedAnswers.size());
    }

    @Test
    void submitAttemptMultipleChoiceWrongScoresZero() {
        Question q = new Question(11, QuestionType.MC, "Capital?", 1, 10, null, null, "Geo");
        InMemoryQuestionRepository questionRepo = new InMemoryQuestionRepository(List.of(q));

        InMemoryAnswerDao answerDao = new InMemoryAnswerDao();
        answerDao.setAnswers(11, List.of(
                new AnswerOption(1, 11, "Berlin", true, 1.0),
                new AnswerOption(2, 11, "Paris", false, 0.0)
        ));

        InMemoryAttemptDao attemptDao = new InMemoryAttemptDao();

        TestService service = new TestService(
                questionRepo,
                answerDao,
                new InMemoryClozeTokenDao(),
                attemptDao,
                new InMemoryUserDao(),
                new EmptyConfigDao()
        );

        Map<Integer, Object> answers = Map.of(11, 2);
        AttemptResult result = service.submitAttempt(7, 1, List.of(11), answers, 45);

        assertEquals(0.0, result.getAttempt().getTotalPoints(), 0.0001);
        assertEquals("6", result.getAttempt().getGrade());
    }

    private static class InMemoryQuestionRepository implements QuestionRepository {
        private final List<Question> questions;

        private InMemoryQuestionRepository(List<Question> questions) {
            this.questions = new ArrayList<>(questions);
        }

        @Override
        public int create(Question question) {
            throw new UnsupportedOperationException();
        }

        @Override
        public boolean update(Question question) {
            throw new UnsupportedOperationException();
        }

        @Override
        public boolean delete(int id) {
            throw new UnsupportedOperationException();
        }

        @Override
        public Optional<Question> findById(int id) {
            return questions.stream().filter(q -> q.getId() == id).findFirst();
        }

        @Override
        public List<Question> findByDifficulty(int difficulty, int limit) {
            List<Question> result = new ArrayList<>();
            for (Question q : questions) {
                if (q.getDifficulty() == difficulty) {
                    result.add(q);
                }
            }
            if (result.size() > limit) {
                return new ArrayList<>(result.subList(0, limit));
            }
            return result;
        }

        @Override
        public List<Question> findByDifficultyAndCategory(int difficulty, int limit, String category) {
            List<Question> result = new ArrayList<>();
            for (Question q : questions) {
                if (q.getDifficulty() == difficulty && Objects.equals(category, q.getCategory())) {
                    result.add(q);
                }
            }
            if (result.size() > limit) {
                return new ArrayList<>(result.subList(0, limit));
            }
            return result;
        }

        @Override
        public List<Question> findAll() {
            return new ArrayList<>(questions);
        }

        @Override
        public List<String> findAllCategories() {
            Set<String> cats = new HashSet<>();
            for (Question q : questions) {
                if (q.getCategory() != null) {
                    cats.add(q.getCategory());
                }
            }
            return new ArrayList<>(cats);
        }
    }

    private static class InMemoryAnswerDao implements AnswerDao {
        private final Map<Integer, List<AnswerOption>> answers = new HashMap<>();

        void setAnswers(int questionId, List<AnswerOption> options) {
            answers.put(questionId, new ArrayList<>(options));
        }

        @Override
        public int create(AnswerOption option) {
            throw new UnsupportedOperationException();
        }

        @Override
        public List<AnswerOption> findByQuestion(int questionId) {
            return answers.getOrDefault(questionId, Collections.emptyList());
        }

        @Override
        public boolean deleteByQuestion(int questionId) {
            answers.remove(questionId);
            return true;
        }
    }

    private static class InMemoryClozeTokenDao implements ClozeTokenDao {
        private final Map<Integer, List<ClozeToken>> tokens = new HashMap<>();

        @Override
        public int create(ClozeToken token) {
            throw new UnsupportedOperationException();
        }

        @Override
        public List<ClozeToken> findByQuestion(int questionId) {
            return tokens.getOrDefault(questionId, Collections.emptyList());
        }

        @Override
        public boolean deleteByQuestion(int questionId) {
            tokens.remove(questionId);
            return true;
        }
    }

    private static class InMemoryAttemptDao implements AttemptDao {
        private int seq = 1;
        private Attempt lastAttempt;
        private List<AttemptAnswer> lastSavedAnswers = Collections.emptyList();

        @Override
        public int createAttempt(Attempt attempt) {
            int id = seq++;
            lastAttempt = attempt;
            return id;
        }

        @Override
        public void saveAttemptAnswers(int attemptId, List<AttemptAnswer> answers) {
            lastSavedAnswers = new ArrayList<>(answers);
        }

        @Override
        public List<Attempt> findByUser(int userId) {
            return Collections.emptyList();
        }

        @Override
        public List<Attempt> findRecentByUser(int userId, int limit) {
            return Collections.emptyList();
        }

        @Override
        public int countAll() {
            return 0;
        }
    }

    private static class InMemoryUserDao implements UserDao {
        @Override
        public int create(User user) { return 1; }

        @Override
        public Optional<User> findByUsername(String username) { return Optional.empty(); }

        @Override
        public Optional<User> findById(int id) { return Optional.empty(); }

        @Override
        public List<User> findAll() { return Collections.emptyList(); }

        @Override
        public boolean delete(int id) { return false; }

        @Override
        public void update(User user) { }

        @Override
        public void setPasswordResetRequested(int userId, boolean requested) { }

        @Override
        public List<User> findPasswordResetRequests() { return Collections.emptyList(); }
    }

    private static class EmptyConfigDao implements ConfigDao {
        @Override
        public Optional<String> findValue(String key) {
            return Optional.empty();
        }
    }
}
