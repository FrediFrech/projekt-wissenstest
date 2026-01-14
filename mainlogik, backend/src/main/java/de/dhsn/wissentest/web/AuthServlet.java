/*
 * Datei: AuthServlet.java
 * Dieses Servlet stellt die HTTP-Endpunkte für Registrierung, Login und Logout bereit. Es liest
 * JSON-Daten aus dem Request, ruft AuthService auf und speichert den eingeloggten User in der Session.
 * Verbindung: Nutzt AuthService; Session-Attribute userId und role werden gesetzt.
 */
package de.dhsn.wissentest.web;

import de.dhsn.wissentest.dao.JdbcUserDao;
import de.dhsn.wissentest.model.User;
import de.dhsn.wissentest.service.AuthService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthServlet extends HttpServlet {
    private final AuthService authService = new AuthService(new JdbcUserDao());

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo() == null ? "" : req.getPathInfo();
        String body = ServletUtils.readBody(req);
        try {
            if (path.equals("/register")) {
                RegisterRequest r = JsonUtil.gson().fromJson(body, RegisterRequest.class);
                User user = authService.register(r.username, r.email, r.password);
                setSession(req.getSession(true), user);
                ServletUtils.writeJson(resp, new UserResponse(user.getId(), user.getUsername(), user.getRole()));
                return;
            }
            if (path.equals("/login")) {
                LoginRequest r = JsonUtil.gson().fromJson(body, LoginRequest.class);
                User user = authService.login(r.username, r.password);
                setSession(req.getSession(true), user);
                ServletUtils.writeJson(resp, new UserResponse(user.getId(), user.getUsername(), user.getRole()));
                return;
            }
            if (path.equals("/logout")) {
                HttpSession session = req.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                ServletUtils.writeJson(resp, new Message("ok"));
                return;
            }
            ServletUtils.writeError(resp, 404, "Unknown auth endpoint");
        } catch (IllegalArgumentException ex) {
            ServletUtils.writeError(resp, 400, ex.getMessage());
        }
    }

    private void setSession(HttpSession session, User user) {
        session.setAttribute("userId", user.getId());
        session.setAttribute("role", user.getRole());
    }

    private static class LoginRequest {
        String username;
        String password;
    }

    private static class RegisterRequest {
        String username;
        String email;
        String password;
    }

    private static class UserResponse {
        int id;
        String username;
        String role;

        UserResponse(int id, String username, String role) {
            this.id = id;
            this.username = username;
            this.role = role;
        }
    }

    private static class Message {
        String status;

        Message(String status) {
            this.status = status;
        }
    }
}
