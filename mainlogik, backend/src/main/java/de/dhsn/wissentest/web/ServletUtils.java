/*
 * Datei: ServletUtils.java
 * Diese Klasse enthält einfache Hilfsmethoden, damit die Servlets weniger Boilerplate-Code haben.
 * Sie liest Request-Bodies ein und gibt JSON-Antworten zurück, inklusive einheitlicher Fehlerformate.
 * Verbindung: Wird in AuthServlet, AdminServlet, TestServlet und HealthServlet genutzt.
 */
package de.dhsn.wissentest.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

public final class ServletUtils {
    private ServletUtils() {
    }

    public static String readBody(HttpServletRequest request) throws IOException {
        return new String(request.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
    }

    public static void writeJson(HttpServletResponse response, Object payload) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(JsonUtil.gson().toJson(payload));
    }

    public static void writeError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        writeJson(response, new ErrorResponse(message));
    }

    private static class ErrorResponse {
        private final String error;

        private ErrorResponse(String error) {
            this.error = error;
        }
    }
}
