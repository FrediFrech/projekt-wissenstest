/*
 * Datei: TestServlet.java
 * Dieses Servlet startet Tests und nimmt Antworten entgegen. Es liefert die Fragen inkl. Optionen
 * oder Tokens zurück und speichert den ausgewerteten Versuch nach dem Submit.
 * Verbindung: Nutzt TestService; bei /submit ist eine gültige Session erforderlich.
 */
package de.dhsn.wissentest.web;

import de.dhsn.wissentest.dao.*;
import de.dhsn.wissentest.model.Attempt;
import de.dhsn.wissentest.model.AttemptResult;
import de.dhsn.wissentest.model.ClozeToken;
import de.dhsn.wissentest.model.Question;
import de.dhsn.wissentest.model.User;
import de.dhsn.wissentest.service.TestService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class TestServlet extends HttpServlet {
        private final TestService testService = new TestService(
            new JdbcQuestionRepository(),
            new JdbcAnswerDao(),
            new JdbcClozeTokenDao(),
            new JdbcAttemptDao(),
            new JdbcUserDao()
    );
    private final AnswerDao answerDao = new JdbcAnswerDao();
    private final ClozeTokenDao clozeTokenDao = new JdbcClozeTokenDao();
    private final UserDao userDao = new JdbcUserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        try {
            if (path.equals("/history")) {
                int userId = getUserId(req);
                List<Attempt> history = testService.getHistory(userId);
                ServletUtils.writeJson(resp, history);
                return;
            }
            if (path.equals("/categories")) {
                List<String> categories = testService.getAvailableCategories();
                List<String> normalized = new java.util.ArrayList<>();
                java.util.Set<String> seen = new java.util.HashSet<>();
                for (String c : categories) {
                    String norm = normalizeText(c);
                    if (seen.add(norm)) {
                        normalized.add(norm);
                    }
                }
                ServletUtils.writeJson(resp, normalized);
                return;
            }
            if (path.equals("/questions/all")) {
                List<Question> all = testService.getAllQuestions();
                List<LearnCard> cards = new java.util.ArrayList<>();
                for(Question q : all) {
                   if (!isLearnEnabled(q)) {
                       continue;
                   }
                   cards.add(new LearnCard(
                           q.getId(),
                           q.getPrompt(),
                           getCorrectAnswerText(q),
                           q.getType() == null ? null : q.getType().name(),
                           q.getImageUrl(),
                           q.getCategory(),
                           q.getDifficulty()
                   ));
                }
                ServletUtils.writeJson(resp, cards);
                return;
            }
             if (path.equals("/admin/stats")) {
                // Return simple stats map
                Map<String, Integer> stats = testService.getAdminStats();
                ServletUtils.writeJson(resp, stats);
                return;
            }
            ServletUtils.writeError(resp, 404, "Unknown test endpoint (GET)");
        } catch (IllegalArgumentException ex) {
            ServletUtils.writeError(resp, 400, ex.getMessage());
        } catch (Exception ex) {
            ServletUtils.writeError(resp, 500, "Test submit failed: " + ex.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        String body = ServletUtils.readBody(req);

        try {
            if (path.equals("/start")) {
                StartRequest r = JsonUtil.gson().fromJson(body, StartRequest.class);
                List<Question> questions;
                if (r.segments != null && !r.segments.isEmpty()) {
                    questions = testService.startSegmentedTest(r.segments, r.limit > 0 ? r.limit : 20);
                } else {
                    questions = testService.startTest(r.difficulty, r.limit, r.category, r.categories);
                }
                List<QuestionView> view = buildQuestionView(questions);
                ServletUtils.writeJson(resp, view);
                return;
            }

            if (path.equals("/submit")) {
                SubmitRequest r = JsonUtil.gson().fromJson(body, SubmitRequest.class);
                int userId = getUserIdForSubmit(req);
                java.util.Map<Integer, Object> normalized = normalizeAnswerKeys(r.answers);
                List<Integer> questionIds = r.questionIds;
                if (questionIds == null || questionIds.isEmpty()) {
                    questionIds = new java.util.ArrayList<>(normalized.keySet());
                }
                if (questionIds == null || questionIds.isEmpty()) {
                    throw new IllegalArgumentException("No questions submitted");
                }
                int difficulty = (r.difficulty >= 1 && r.difficulty <= 3) ? r.difficulty : 2;
                int durationSeconds = Math.max(0, r.durationSeconds);
                AttemptResult result = testService.submitAttempt(userId, difficulty, questionIds, normalized, durationSeconds);
                ServletUtils.writeJson(resp, result);
                return;
            }

            ServletUtils.writeError(resp, 404, "Unknown test endpoint");
        } catch (IllegalArgumentException ex) {
            ServletUtils.writeError(resp, 400, ex.getMessage());
        }
    }

    private int getUserId(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            throw new IllegalArgumentException("Not authenticated");
        }
        return (int) session.getAttribute("userId");
    }

    private int getUserIdForSubmit(HttpServletRequest req) {
        try {
            return getUserId(req);
        } catch (IllegalArgumentException ex) {
            return userDao.findByUsername("student")
                    .map(User::getId)
                    .orElseThrow(() -> ex);
        }
    }

    private static class StartRequest {
        int difficulty;
        int limit;
        String category;
        List<String> categories;
        List<de.dhsn.wissentest.service.TestService.ExamSegment> segments;
    }

    private static class SubmitRequest {
        int difficulty;
        List<Integer> questionIds;
        Map<String, Object> answers;
        int durationSeconds;
    }

    private java.util.Map<Integer, Object> normalizeAnswerKeys(Map<String, Object> raw) {
        java.util.Map<Integer, Object> result = new java.util.HashMap<>();
        if (raw == null) {
            return result;
        }
        for (Map.Entry<String, Object> entry : raw.entrySet()) {
            try {
                result.put(Integer.parseInt(entry.getKey()), entry.getValue());
            } catch (NumberFormatException ex) {
                // ignore invalid keys
            }
        }
        return result;
    }

    private List<QuestionView> buildQuestionView(List<Question> questions) {
        List<QuestionView> view = new java.util.ArrayList<>();
        for (Question q : questions) {
            QuestionView v = new QuestionView();
            v.id = q.getId();
            v.type = q.getType().name();
            v.prompt = normalizeText(q.getPrompt());
            v.difficulty = q.getDifficulty();
            v.points = q.getPoints();
            v.imageUrl = q.getImageUrl();
            if (q.getType().name().equals("MC") || q.getType().name().equals("IMAGE")) {
                v.options = answerDao.findByQuestion(q.getId());
                if (v.options != null) {
                    for (de.dhsn.wissentest.model.AnswerOption opt : v.options) {
                        opt.setAnswerText(normalizeText(opt.getAnswerText()));
                    }
                }
            } else if (q.getType().name().equals("CLOZE")) {
                v.tokens = clozeTokenDao.findByQuestion(q.getId());
                if (v.tokens != null) {
                    for (de.dhsn.wissentest.model.ClozeToken token : v.tokens) {
                        token.setExpectedText(normalizeText(token.getExpectedText()));
                    }
                }
            }
            view.add(v);
        }
        return view;
    }

    private String normalizeText(String value) {
        if (value == null) {
            return null;
        }
        return value
                .replace("ÃƒÂ¤", "ä")
                .replace("ÃƒÂ¶", "ö")
                .replace("ÃƒÂ¼", "ü")
                .replace("ÃƒÂŸ", "ß")
                .replace("ÃƒÂ„", "Ä")
                .replace("ÃƒÂ–", "Ö")
                .replace("ÃƒÂœ", "Ü")
                .replace("Ã¤", "ä")
                .replace("Ã¶", "ö")
                .replace("Ã¼", "ü")
                .replace("ÃŸ", "ß")
                .replace("Ã„", "Ä")
                .replace("Ã–", "Ö")
                .replace("Ãœ", "Ü")
                .replace("Ã¢â‚¬â€œ", "–")
                .replace("Ã¢â‚¬â€", "”")
                .replace("Ã¢â‚¬â€ž", "„")
                .replace("Ã¢â‚¬â€˜", "‘")
                .replace("Ã¢â‚¬â€™", "’");
    }

    private static class QuestionView {
        int id;
        String type;
        String prompt;
        int difficulty;
        int points;
        String imageUrl;
        List<de.dhsn.wissentest.model.AnswerOption> options;
        List<de.dhsn.wissentest.model.ClozeToken> tokens;
    }

    private static class LearnCard {
        int id;
        String q;
        String a;
        String type;
        String imageUrl;
        String category;
        int difficulty;

        LearnCard(int id, String q, String a, String type, String imageUrl, String category, int difficulty) {
            this.id = id;
            this.q = q;
            this.a = a;
            this.type = type;
            this.imageUrl = imageUrl;
            this.category = category;
            this.difficulty = difficulty;
        }
    }

    private String getCorrectAnswerText(Question q) {
        if(q.getType().name().equals("MC") || q.getType().name().equals("IMAGE") || q.getType().name().equals("FREE")) {
             List<de.dhsn.wissentest.model.AnswerOption> opts = answerDao.findByQuestion(q.getId());
             if (q.getType().name().equals("FREE")) {
                 return opts.stream().map(o -> o.getAnswerText()).reduce((a, b) -> a + " / " + b).orElse("Keine Musterlösung hinterlegt");
             }
             String byCorrect = opts.stream()
                     .filter(o -> o.isCorrect())
                     .map(o -> o.getAnswerText())
                     .reduce((a, b) -> a + ", " + b)
                     .orElse("");
             if (!byCorrect.isEmpty()) {
                 return byCorrect;
             }
             String byPartial = opts.stream()
                     .filter(o -> o.getPartialValue() > 0)
                     .map(o -> o.getAnswerText())
                     .reduce((a, b) -> a + ", " + b)
                     .orElse("");
             if (!byPartial.isEmpty()) {
                 return byPartial;
             }
             return opts.stream().map(o -> o.getAnswerText()).findFirst().orElse("Keine Antwort");
        } else {
             // Cloze
             List<ClozeToken> tokens = clozeTokenDao.findByQuestion(q.getId());
             if (tokens == null || tokens.isEmpty()) {
                 return "Keine Musterlösung hinterlegt";
             }
             tokens.sort(java.util.Comparator.comparingInt(ClozeToken::getTokenIndex));
             return tokens.stream()
                     .map(ClozeToken::getExpectedText)
                     .filter(t -> t != null && !t.trim().isEmpty())
                     .reduce((a, b) -> a + " | " + b)
                     .orElse("Keine Musterlösung hinterlegt");
        }
    }

    /**
     * LearnMode should only show questions that are explicitly enabled.
     * Stored in questions.meta JSON as {"learnEnabled": true/false}.
     * Default: enabled (so legacy data still shows up).
     */
    private boolean isLearnEnabled(Question q) {
        if (q == null) {
            return true;
        }
        String meta = q.getMetaJson();
        if (meta == null || meta.isBlank()) {
            return true;
        }
        try {
            java.util.Map<?, ?> map = JsonUtil.gson().fromJson(meta, java.util.Map.class);
            if (map == null) {
                return true;
            }
            Object v = map.get("learnEnabled");
            if (v == null) {
                return true;
            }
            if (v instanceof Boolean) {
                return (Boolean) v;
            }
            if (v instanceof Number) {
                return ((Number) v).intValue() != 0;
            }
            return Boolean.parseBoolean(String.valueOf(v));
        } catch (Exception ignored) {
            return true;
        }
    }
}
