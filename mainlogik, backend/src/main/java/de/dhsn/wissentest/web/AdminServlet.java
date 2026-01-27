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
import de.dhsn.wissentest.model.User;
import de.dhsn.wissentest.service.AdminService;
import de.dhsn.wissentest.util.PasswordUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@MultipartConfig(maxFileSize = 5_000_000, maxRequestSize = 6_000_000)
public class AdminServlet extends HttpServlet {
    private final UserDao userDao = new JdbcUserDao();
    private final QuestionRepository questionDao = new JdbcQuestionRepository();
    private final AnswerDao answerDao = new JdbcAnswerDao();
    private final ClozeTokenDao clozeTokenDao = new JdbcClozeTokenDao();
    private final AttemptDao attemptDao = new JdbcAttemptDao();
    private final QuestionImageDao imageDao = new JdbcQuestionImageDao();
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
        if (path.equals("/users/requests")) {
            ServletUtils.writeJson(resp, userDao.findPasswordResetRequests());
            return;
        }
        if (path.equals("/stats")) {
            java.util.Map<String, Integer> stats = new java.util.HashMap<>();
            stats.put("users", userDao.findAll().size());
            stats.put("questions", questionDao.findAll().size());
            stats.put("attempts", attemptDao.countAll());
            ServletUtils.writeJson(resp, stats);
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
        if (path.equals("/images/import")) {
            handleImageImportFromFolder(req, resp);
            return;
        }
        if (path.equals("/images")) {
            handleImageUpload(req, resp);
            return;
        }
        if (path.equals("/questions")) {
            String body = ServletUtils.readBody(req);
            QuestionPayload payload = JsonUtil.gson().fromJson(body, QuestionPayload.class);
            Question question = new Question(0, QuestionType.valueOf(payload.type), payload.prompt, payload.difficulty, payload.points, payload.metaJson, payload.imageUrl, payload.category);
            int id;
            if (question.getType() == QuestionType.CLOZE) {
                id = adminService.createClozeQuestion(question, payload.tokens);
            } else {
                id = adminService.createMultipleChoiceQuestion(question, payload.answers);
            }
            ServletUtils.writeJson(resp, new IdResponse(id));
            return;
        }
        if (path.equals("/users")) {
            String body = ServletUtils.readBody(req);
            UserPayload p = JsonUtil.gson().fromJson(body, UserPayload.class);
            if (userDao.findByUsername(p.username).isPresent()) {
                 ServletUtils.writeError(resp, 400, "Username already exists");
                 return;
            }
            String salt = PasswordUtils.generateSaltHex();
            String hash = PasswordUtils.hashPassword(p.password, salt);
            User u = new User(0, p.username, p.email, hash, salt, p.role != null ? p.role : "student");
            int id = userDao.create(u);
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
            Question question = new Question(payload.id, QuestionType.valueOf(payload.type), payload.prompt, payload.difficulty, payload.points, payload.metaJson, payload.imageUrl, payload.category);
            if (question.getType() == QuestionType.CLOZE) {
                adminService.updateClozeQuestion(question, payload.tokens);
            } else {
                adminService.updateMultipleChoiceQuestion(question, payload.answers);
            }
            ServletUtils.writeJson(resp, new Message("ok"));
            return;
        }
        if (path.equals("/users")) {
            // Handle both role toggle (via query params) AND full editing (via JSON body)
            String idStr = req.getParameter("id");
            String roleParam = req.getParameter("role");
            if (idStr != null && roleParam != null) {
                // Quick role toggle
                User u = userDao.findById(Integer.parseInt(idStr))
                        .orElseThrow(() -> new IllegalArgumentException("User not found"));
                u.setRole(roleParam);
                userDao.update(u);
                ServletUtils.writeJson(resp, new Message("ok"));
                return;
            }
            
            // Full update via Body
            String body = ServletUtils.readBody(req);
            if (body != null && !body.isEmpty()) {
                UserPayload p = JsonUtil.gson().fromJson(body, UserPayload.class);
                User u = userDao.findById(p.id)
                        .orElseThrow(() -> new IllegalArgumentException("User not found"));
                
                if (p.username != null && !p.username.isEmpty()) u.setUsername(p.username);
                if (p.email != null) u.setEmail(p.email); // allow empty?
                if (p.role != null && !p.role.isEmpty()) u.setRole(p.role);
                if (p.password != null && !p.password.isEmpty()) {
                    String salt = PasswordUtils.generateSaltHex();
                    String hash = PasswordUtils.hashPassword(p.password, salt);
                    u.setPasswordSalt(salt);
                    u.setPasswordHash(hash);
                }
                if (p.resetComplete) {
                    u.setResetRequested(false);
                }
                userDao.update(u);
                ServletUtils.writeJson(resp, new Message("ok"));
                return;
            }
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

    private static class UserPayload {
        int id;
        String username;
        String email;
        String password;
        String role;
        boolean resetComplete;
    }

    private static class QuestionPayload {
        int id;
        String type;
        String prompt;
        int difficulty;
        int points;
        String metaJson;
        String imageUrl;
        String category;
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
            v.imageUrl = q.getImageUrl();
            v.category = q.getCategory();
            if (q.getType() == QuestionType.CLOZE) {
                v.tokens = clozeTokenDao.findByQuestion(q.getId());
            } else {
                v.options = answerDao.findByQuestion(q.getId());
            }
            view.add(v);
        }
        return view;
    }

    private void handleImageUpload(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            ServletUtils.writeError(resp, 400, "No image uploaded");
            return;
        }
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            ServletUtils.writeError(resp, 400, "Invalid image type");
            return;
        }
        byte[] data = filePart.getInputStream().readAllBytes();
        int id = imageDao.create(data, contentType);
        String url = req.getContextPath() + "/api/images/" + id;
        ServletUtils.writeJson(resp, new ImageResponse(id, url));
    }

    private void handleImageImportFromFolder(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String folderParam = req.getParameter("folder");
        String folder = (folderParam == null || folderParam.isBlank()) ? "/assets/questions" : folderParam;
        String realPath = getServletContext().getRealPath(folder);
        if (realPath == null) {
            ServletUtils.writeError(resp, 500, "Import path not available");
            return;
        }
        Path dir = Paths.get(realPath);
        if (!Files.exists(dir) || !Files.isDirectory(dir)) {
            ServletUtils.writeError(resp, 404, "Import folder not found");
            return;
        }

        List<Path> files;
        try (Stream<Path> stream = Files.list(dir)) {
            files = stream
                    .filter(Files::isRegularFile)
                    .filter(this::isImageFile)
                    .sorted(Comparator.comparing(p -> p.getFileName().toString().toLowerCase(Locale.ROOT)))
                    .collect(Collectors.toList());
        }

        List<ImportImageResponse> imported = new ArrayList<>();
        for (Path file : files) {
            String contentType = guessContentType(file);
            if (contentType == null) {
                continue;
            }
            byte[] data = Files.readAllBytes(file);
            int id = imageDao.create(data, contentType);
            String url = req.getContextPath() + "/api/images/" + id;
            imported.add(new ImportImageResponse(id, url, file.getFileName().toString()));
        }

        ServletUtils.writeJson(resp, new ImportResponse(imported));
    }

    private boolean isImageFile(Path file) {
        String name = file.getFileName().toString().toLowerCase(Locale.ROOT);
        return name.endsWith(".png") || name.endsWith(".jpg") || name.endsWith(".jpeg")
                || name.endsWith(".gif") || name.endsWith(".webp") || name.endsWith(".bmp")
                || name.endsWith(".svg");
    }

    private String guessContentType(Path file) throws IOException {
        String contentType = Files.probeContentType(file);
        if (contentType != null && contentType.startsWith("image/")) {
            return contentType;
        }
        String name = file.getFileName().toString().toLowerCase(Locale.ROOT);
        if (name.endsWith(".png")) return "image/png";
        if (name.endsWith(".jpg") || name.endsWith(".jpeg")) return "image/jpeg";
        if (name.endsWith(".gif")) return "image/gif";
        if (name.endsWith(".webp")) return "image/webp";
        if (name.endsWith(".bmp")) return "image/bmp";
        if (name.endsWith(".svg")) return "image/svg+xml";
        return null;
    }

    private static class QuestionView {
        int id;
        String type;
        String prompt;
        int difficulty;
        int points;
        String metaJson;
        String imageUrl;
        String category;
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

    private static class ImageResponse {
        int id;
        String url;

        ImageResponse(int id, String url) {
            this.id = id;
            this.url = url;
        }
    }

    private static class ImportImageResponse {
        int id;
        String url;
        String name;

        ImportImageResponse(int id, String url, String name) {
            this.id = id;
            this.url = url;
            this.name = name;
        }
    }

    private static class ImportResponse {
        List<ImportImageResponse> images;

        ImportResponse(List<ImportImageResponse> images) {
            this.images = images;
        }
    }
}
