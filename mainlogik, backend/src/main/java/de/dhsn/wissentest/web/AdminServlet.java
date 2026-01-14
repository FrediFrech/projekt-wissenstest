/*
 * Datei: AdminServlet.java
 * Dieses Servlet bündelt alle Admin-Endpunkte. Admins können Fragen anlegen, ändern, löschen und
 * außerdem Benutzer auflisten oder entfernen. Beim Laden der Fragen werden auch Optionen/Tokens
 * mitgeliefert, damit das Frontend editieren kann.
 * Verbindung: Nutzt AdminService und Repositories/DAOs; prüft Session-Rolle "admin".
 */
package de.dhsn.wissentest.web;

import de.dhsn.wissentest.dao.*;
import de.dhsn.wissentest.model.AnswerOption;
import de.dhsn.wissentest.model.ClozeToken;
import de.dhsn.wissentest.model.Question;
import de.dhsn.wissentest.model.QuestionType;
import de.dhsn.wissentest.service.AdminService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AdminServlet extends HttpServlet {
    private final UserDao userDao = new JdbcUserDao();
    private final QuestionRepository questionDao = new JdbcQuestionRepository();
    private final AnswerDao answerDao = new JdbcAnswerDao();
    private final ClozeTokenDao clozeTokenDao = new JdbcClozeTokenDao();
    private final AdminService adminService = new AdminService(questionDao, answerDao, clozeTokenDao);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            ServletUtils.writeError(resp, 403, "Forbidden");
            return;
        }
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        if (path.equals("/questions")) {
            java.util.List<Question> questions = questionDao.findAll();
            java.util.List<QuestionView> view = buildQuestionView(questions);
            ServletUtils.writeJson(resp, view);
            return;
        }
        if (path.equals("/users")) {
            ServletUtils.writeJson(resp, userDao.findAll());
            return;
        }
        ServletUtils.writeError(resp, 404, "Unknown admin endpoint");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            ServletUtils.writeError(resp, 403, "Forbidden");
            return;
        }
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        if (path.equals("/questions")) {
            String body = ServletUtils.readBody(req);
            QuestionPayload payload = JsonUtil.gson().fromJson(body, QuestionPayload.class);
            Question question = new Question(0, QuestionType.valueOf(payload.type), payload.prompt, payload.difficulty, payload.points, payload.metaJson);
            int id;
            if (question.getType() == QuestionType.MC) {
                id = adminService.createMultipleChoiceQuestion(question, payload.answers);
            } else {
                id = adminService.createClozeQuestion(question, payload.tokens);
            }
            ServletUtils.writeJson(resp, new IdResponse(id));
            return;
        }
        ServletUtils.writeError(resp, 404, "Unknown admin endpoint");
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            ServletUtils.writeError(resp, 403, "Forbidden");
            return;
        }
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        if (path.equals("/questions")) {
            String body = ServletUtils.readBody(req);
            QuestionPayload payload = JsonUtil.gson().fromJson(body, QuestionPayload.class);
            Question question = new Question(payload.id, QuestionType.valueOf(payload.type), payload.prompt, payload.difficulty, payload.points, payload.metaJson);
            if (question.getType() == QuestionType.MC) {
                adminService.updateMultipleChoiceQuestion(question, payload.answers);
            } else {
                adminService.updateClozeQuestion(question, payload.tokens);
            }
            ServletUtils.writeJson(resp, new Message("ok"));
            return;
        }
        ServletUtils.writeError(resp, 404, "Unknown admin endpoint");
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            ServletUtils.writeError(resp, 403, "Forbidden");
            return;
        }
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        if (path.equals("/questions")) {
            String idParam = req.getParameter("id");
            int id = Integer.parseInt(idParam);
            questionDao.delete(id);
            ServletUtils.writeJson(resp, new Message("ok"));
            return;
        }
        if (path.equals("/users")) {
            String idParam = req.getParameter("id");
            int id = Integer.parseInt(idParam);
            userDao.delete(id);
            ServletUtils.writeJson(resp, new Message("ok"));
            return;
        }
        ServletUtils.writeError(resp, 404, "Unknown admin endpoint");
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return false;
        }
        Object role = session.getAttribute("role");
        return role != null && role.toString().equalsIgnoreCase("admin");
    }

    private static class QuestionPayload {
        int id;
        String type;
        String prompt;
        int difficulty;
        int points;
        String metaJson;
        List<AnswerOption> answers;
        List<ClozeToken> tokens;
    }

    private java.util.List<QuestionView> buildQuestionView(java.util.List<Question> questions) {
        java.util.List<QuestionView> view = new java.util.ArrayList<>();
        for (Question q : questions) {
            QuestionView v = new QuestionView();
            v.id = q.getId();
            v.type = q.getType().name();
            v.prompt = q.getPrompt();
            v.difficulty = q.getDifficulty();
            v.points = q.getPoints();
            v.metaJson = q.getMetaJson();
            if (q.getType() == QuestionType.MC) {
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
        String metaJson;
        java.util.List<AnswerOption> options;
        java.util.List<ClozeToken> tokens;
    }

    private static class IdResponse {
        int id;

        IdResponse(int id) {
            this.id = id;
        }
    }

    private static class Message {
        String status;

        Message(String status) {
            this.status = status;
        }
    }
}
