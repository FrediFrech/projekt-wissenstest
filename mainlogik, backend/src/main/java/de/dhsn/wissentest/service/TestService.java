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
import de.dhsn.wissentest.dao.UserDao;
import de.dhsn.wissentest.model.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TestService {
    private final QuestionRepository questionDao;
    private final AnswerDao answerDao;
    private final ClozeTokenDao clozeTokenDao;
    private final AttemptDao attemptDao;
    private final UserDao userDao;

    public TestService(QuestionRepository questionDao, AnswerDao answerDao, ClozeTokenDao clozeTokenDao, AttemptDao attemptDao, UserDao userDao) {
        this.questionDao = questionDao;
        this.answerDao = answerDao;
        this.clozeTokenDao = clozeTokenDao;
        this.attemptDao = attemptDao;
        this.userDao = userDao;
    }

    public List<Question> getAllQuestions() {
        return questionDao.findAll();
    }

    public Map<String, Integer> getAdminStats() {
        Map<String, Integer> stats = new HashMap<>();
        stats.put("users", userDao.findAll().size());
        stats.put("questions", questionDao.findAll().size());
        stats.put("attempts", attemptDao.countAll());
        return stats;
    }

    public List<Question> startTest(int difficulty, int limit) {
        return questionDao.findByDifficulty(difficulty, limit);
    }

    public List<Question> startTest(int difficulty, int limit, String category) {
        if (category == null || category.isEmpty() || category.equals("All")) {
            return questionDao.findByDifficulty(difficulty, limit);
        }
        return questionDao.findByDifficultyAndCategory(difficulty, limit, category);
    }

    public List<String> getAvailableCategories() {
        return questionDao.findAllCategories();
    }

    public AttemptResult submitAttempt(int userId, int difficulty, List<Integer> questionIds, Map<Integer, Object> answers, int durationSeconds) {
        double totalPoints = 0.0;
        double maxPoints = 0.0;
        List<AttemptAnswer> attemptAnswers = new ArrayList<>();
        List<QuestionResultDetail> details = new ArrayList<>();

        for (Integer qId : questionIds) {
            Question q = questionDao.findById(qId)
                    .orElseThrow(() -> new IllegalArgumentException("Question not found: " + qId));
            
            Object answerPayload = answers.get(q.getId());
            double earned = scoreQuestion(q, answerPayload); // scoreQuestion handles max points for q
            
            // Re-calculate max points for this question to be sure
            double qMax = q.getPoints();
            maxPoints += qMax;
            totalPoints += earned;
            
            attemptAnswers.add(new AttemptAnswer(0, 0, q.getId(), String.valueOf(answerPayload), earned));

            // Create Detail
            QuestionResultDetail detail = new QuestionResultDetail();
            detail.questionId = q.getId();
            detail.prompt = q.getPrompt();
            detail.imageUrl = q.getImageUrl();
            detail.userAnswer = String.valueOf(answerPayload);
            detail.correctAnswer = determineCorrectAnswerText(q);
            detail.isCorrect = earned > 0;
            detail.pointsObtained = earned;
            detail.maxPoints = qMax;
            details.add(detail);
        }

        Attempt attempt = new Attempt();
        attempt.setUserId(userId);
        attempt.setDifficulty(difficulty);
        attempt.setTotalPoints(totalPoints);
        attempt.setMaxPoints(maxPoints);
        attempt.setDurationSeconds(durationSeconds);
        attempt.setGrade(calculateGrade(totalPoints, maxPoints, difficulty));

        int attemptId = attemptDao.createAttempt(attempt);
        attemptDao.saveAttemptAnswers(attemptId, attemptAnswers);
        attempt.setId(attemptId);
        
        return new AttemptResult(attempt, details);
    }
    
    private String determineCorrectAnswerText(Question q) {
        if (q.getType() == QuestionType.MC || q.getType() == QuestionType.IMAGE) {
            List<AnswerOption> opts = answerDao.findByQuestion(q.getId());
            StringBuilder sb = new StringBuilder();
            for(AnswerOption o : opts) {
                if(o.isCorrect()) { // Use isCorrect boolean if available, or partialValue > 0
                    if(sb.length() > 0) sb.append(", ");
                    sb.append(o.getAnswerText());
                }
            }
            return sb.toString();
        } else if (q.getType() == QuestionType.FREE) {
            List<AnswerOption> opts = answerDao.findByQuestion(q.getId());
            return opts.isEmpty() ? "" : opts.get(0).getAnswerText();
        } else if (q.getType() == QuestionType.CLOZE) {
            List<ClozeToken> tokens = clozeTokenDao.findByQuestion(q.getId());
            StringBuilder sb = new StringBuilder();
            for(ClozeToken t : tokens) {
                 sb.append("[").append(t.getExpectedText()).append("] ");
            }
            return sb.toString().trim();
        }
        return "";
    }

    private String calculateGrade(double total, double max, int difficulty) {
        if (max <= 0) return "N/A";
        double percent = (total / max) * 100.0;
        
        // Difficulty 1 = Leicht (Basis: 10er Scale -> 90%, 70%, 50%, 30%, 10%)
        // Difficulty 2 = Mittel (Basis: 15er Scale -> ~93%, ~73%, ~53%, ~33%, ~13%)
        // Difficulty 3 = Schwer (Basis: 20er Scale -> 90%, 70%, 50%, 30%, 15%)
        
        if (difficulty == 1) {
            if (percent >= 90) return "1";
            if (percent >= 70) return "2";
            if (percent >= 50) return "3";
            if (percent >= 30) return "4";
            if (percent >= 10) return "5";
            return "6";
        } else if (difficulty == 2) {
            if (percent >= 93) return "1";
            if (percent >= 73) return "2";
            if (percent >= 53) return "3";
            if (percent >= 33) return "4";
            if (percent >= 13) return "5";
            return "6";
        } else {
             // Schwer
            if (percent >= 90) return "1";
            if (percent >= 70) return "2";
            if (percent >= 50) return "3";
            if (percent >= 30) return "4";
            if (percent >= 15) return "5";
            return "6";
        }
    }

    public List<Attempt> getHistory(int userId) {
        return attemptDao.findByUser(userId);
    }

    private double scoreQuestion(Question question, Object answerPayload) {
        if (question.getType() == QuestionType.MC || question.getType() == QuestionType.IMAGE) {
            return scoreMultipleChoice(question.getId(), answerPayload, question.getPoints());
        } else if (question.getType() == QuestionType.FREE) {
            return scoreFreeText(question.getId(), answerPayload, question.getPoints());
        }
        return scoreCloze(question.getId(), answerPayload, question.getPoints());
    }

    private double scoreFreeText(int questionId, Object answerPayload, int maxPoints) {
        if (answerPayload == null || String.valueOf(answerPayload).trim().isEmpty()) {
            return 0.0;
        }
        String given = String.valueOf(answerPayload).trim();
        List<AnswerOption> options = answerDao.findByQuestion(questionId);
        for(AnswerOption opt : options) {
            if(opt.getAnswerText().trim().equalsIgnoreCase(given)) {
                 // Assuming partial value 1.0 for correct free text, or we can use the partial value from DB
                 return maxPoints * opt.getPartialValue();
            }
        }
        return 0.0;
    }

    private double scoreMultipleChoice(int questionId, Object answerPayload, int maxPoints) {
        if (answerPayload == null) {
            return 0.0;
        }

        List<Integer> selectedIds = new ArrayList<>();
        if (answerPayload instanceof List) {
           for(Object o : (List<?>)answerPayload) {
               if(o instanceof Number) selectedIds.add(((Number)o).intValue());
               else if(o instanceof String) {
                   try { selectedIds.add(Integer.parseInt((String)o)); } catch(NumberFormatException e){}
               }
           }
        } else if (answerPayload instanceof Number) {
            selectedIds.add(((Number) answerPayload).intValue());
        } else if (answerPayload instanceof String) {
             try { selectedIds.add(Integer.parseInt((String)answerPayload)); } catch(NumberFormatException e){}
        }

        List<AnswerOption> allOptions = answerDao.findByQuestion(questionId);
        double totalPartial = 0.0;
        boolean pickedWrong = false;

        for (Integer id : selectedIds) {
            for (AnswerOption option : allOptions) {
                if (option.getId() == id) {
                    if (!option.isCorrect()) {
                        pickedWrong = true;
                    }
                    totalPartial += option.getPartialValue();
                }
            }
        }
        
        if (pickedWrong) {
            return 0.0;
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
