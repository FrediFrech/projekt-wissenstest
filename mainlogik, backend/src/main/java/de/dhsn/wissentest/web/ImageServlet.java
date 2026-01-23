/*
 * Datei: ImageServlet.java
 * Liefert gespeicherte Fragebilder aus der DB.
 */
package de.dhsn.wissentest.web;

import de.dhsn.wissentest.dao.JdbcQuestionImageDao;
import de.dhsn.wissentest.dao.QuestionImageDao;
import de.dhsn.wissentest.model.QuestionImage;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Optional;

public class ImageServlet extends HttpServlet {
    private final QuestionImageDao imageDao = new JdbcQuestionImageDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) {
            ServletUtils.writeError(resp, 400, "Image id required");
            return;
        }
        String idStr = path.startsWith("/") ? path.substring(1) : path;
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException ex) {
            ServletUtils.writeError(resp, 400, "Invalid image id");
            return;
        }

        Optional<QuestionImage> img = imageDao.findById(id);
        if (img.isEmpty()) {
            resp.setStatus(404);
            return;
        }

        QuestionImage image = img.get();
        resp.setContentType(image.getContentType());
        resp.setHeader("Cache-Control", "public, max-age=86400");
        resp.getOutputStream().write(image.getData());
    }
}
