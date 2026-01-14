/*
 * Datei: TestServlet.java
 * Dieses Servlet startet Tests und nimmt Antworten entgegen. Es liefert die Fragen inkl. Optionen
 * oder Tokens zurück und speichert den ausgewerteten Versuch nach dem Submit.
 * Verbindung: Nutzt TestService; bei /submit ist eine gültige Session erforderlich.
 */
package de.dhsn.wissentest.web;

import de.dhsn.wissentest.dao.*;
import de.dhsn.wissentest.model.Attempt;
import de.dhsn.wissentest.model.Question;
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
            new JdbcAttemptDao()
    );
    private final AnswerDao answerDao = new JdbcAnswerDao();
    private final ClozeTokenDao clozeTokenDao = new JdbcClozeTokenDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        String body = ServletUtils.readBody(req);

        try {
            if (path.equals("/start")) {
                StartRequest r = JsonUtil.gson().fromJson(body, StartRequest.class);
                List<Question> questions = testService.startTest(r.difficulty, r.limit);
                List<QuestionView> view = buildQuestionView(questions);
                ServletUtils.writeJson(resp, view);
                return;
            }

            if (path.equals("/submit")) {
                SubmitRequest r = JsonUtil.gson().fromJson(body, SubmitRequest.class);
                int userId = getUserId(req);
                java.util.Map<Integer, Object> normalized = normalizeAnswerKeys(r.answers);
                Attempt attempt = testService.submitAttempt(userId, r.difficulty, r.questionIds, normalized);
                ServletUtils.writeJson(resp, attempt);
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

    private static class StartRequest {
        int difficulty;
        int limit;
    }

    private static class SubmitRequest {
        int difficulty;
        List<Integer> questionIds;
        Map<String, Object> answers;
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
            v.prompt = q.getPrompt();
            v.difficulty = q.getDifficulty();
            v.points = q.getPoints();
            if (q.getType().name().equals("MC")) {
                v.options = answerDao.findByQuestion(q.getId());
            } else {
                v.tokens = clozeTokenDao.findByQuestion(q.getId());
            }
            view.add(v);
        }
        return view;
    }

    private static class QuestionView {
        int id;
        String type;
        String prompt;
        int difficulty;
        int points;
        List<de.dhsn.wissentest.model.AnswerOption> options;
        List<de.dhsn.wissentest.model.ClozeToken> tokens;
    }
}
