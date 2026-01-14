/*
 * Datei: TestService.java
 * Diese Service-Klasse enthält die Logik für Teststart, Bewertung und Speicherung. Sie lädt Fragen,
 * bewertet Antworten (inkl. Teilpunkten) und legt die Ergebnisse als Attempt ab.
 * Verbindung: Nutzt QuestionRepository, AnswerDao, ClozeTokenDao, AttemptDao; verwendet in TestServlet.
 */
package de.dhsn.wissentest.service;

import de.dhsn.wissentest.dao.AnswerDao;
import de.dhsn.wissentest.dao.AttemptDao;
import de.dhsn.wissentest.dao.ClozeTokenDao;
import de.dhsn.wissentest.dao.QuestionRepository;
import de.dhsn.wissentest.model.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class TestService {
    private final QuestionRepository questionDao;
    private final AnswerDao answerDao;
    private final ClozeTokenDao clozeTokenDao;
    private final AttemptDao attemptDao;

    public TestService(QuestionRepository questionDao, AnswerDao answerDao, ClozeTokenDao clozeTokenDao, AttemptDao attemptDao) {
        this.questionDao = questionDao;
        this.answerDao = answerDao;
        this.clozeTokenDao = clozeTokenDao;
        this.attemptDao = attemptDao;
    }

    public List<Question> startTest(int difficulty, int limit) {
        return questionDao.findByDifficulty(difficulty, limit);
    }

    public Attempt submitAttempt(int userId, int difficulty, List<Integer> questionIds, Map<Integer, Object> answers) {
        double totalPoints = 0.0;
        double maxPoints = 0.0;
        List<AttemptAnswer> attemptAnswers = new ArrayList<>();

        for (Integer qId : questionIds) {
            Question q = questionDao.findById(qId)
                    .orElseThrow(() -> new IllegalArgumentException("Question not found: " + qId));
            maxPoints += q.getPoints();
            Object answerPayload = answers.get(q.getId());
            double earned = scoreQuestion(q, answerPayload);
            totalPoints += earned;
            attemptAnswers.add(new AttemptAnswer(0, 0, q.getId(), String.valueOf(answerPayload), earned));
        }

        Attempt attempt = new Attempt();
        attempt.setUserId(userId);
        attempt.setDifficulty(difficulty);
        attempt.setTotalPoints(totalPoints);
        attempt.setMaxPoints(maxPoints);

        int attemptId = attemptDao.createAttempt(attempt);
        attemptDao.saveAttemptAnswers(attemptId, attemptAnswers);
        attempt.setId(attemptId);
        return attempt;
    }

    private double scoreQuestion(Question question, Object answerPayload) {
        if (question.getType() == QuestionType.MC) {
            return scoreMultipleChoice(question.getId(), answerPayload, question.getPoints());
        }
        return scoreCloze(question.getId(), answerPayload, question.getPoints());
    }

    private double scoreMultipleChoice(int questionId, Object answerPayload, int maxPoints) {
        if (answerPayload == null) {
            return 0.0;
        }
        @SuppressWarnings("unchecked")
        List<Double> selectedIdsRaw = (List<Double>) answerPayload;
        List<AnswerOption> allOptions = answerDao.findByQuestion(questionId);
        double totalPartial = 0.0;
        for (Double idVal : selectedIdsRaw) {
            int id = idVal.intValue();
            for (AnswerOption option : allOptions) {
                if (option.getId() == id) {
                    totalPartial += option.getPartialValue();
                }
            }
        }
        return Math.max(0.0, Math.min(1.0, totalPartial)) * maxPoints;
    }

    private double scoreCloze(int questionId, Object answerPayload, int maxPoints) {
        if (answerPayload == null) {
            return 0.0;
        }
        @SuppressWarnings("unchecked")
        List<String> tokens = (List<String>) answerPayload;
        List<ClozeToken> expected = clozeTokenDao.findByQuestion(questionId);
        double total = 0.0;
        double expectedTotal = 0.0;
        for (int i = 0; i < expected.size(); i++) {
            ClozeToken e = expected.get(i);
            expectedTotal += e.getPartialValue();
            String actual = (i < tokens.size() && tokens.get(i) != null) ? tokens.get(i).trim() : "";
            if (e.getExpectedText().equalsIgnoreCase(actual)) {
                total += e.getPartialValue();
            }
        }
        double ratio = expectedTotal == 0 ? 0 : total / expectedTotal;
        return ratio * maxPoints;
    }
}
