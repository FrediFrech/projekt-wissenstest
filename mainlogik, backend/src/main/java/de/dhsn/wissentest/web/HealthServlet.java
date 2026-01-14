/*
 * Datei: HealthServlet.java
 * Dieses Servlet liefert einen sehr einfachen Status-Check, damit man schnell sieht, ob die Anwendung
 * erreichbar ist. Es ist besonders hilfreich nach dem Deployment auf Tomcat.
 * Verbindung: In web.xml auf /health gemappt.
 */
package de.dhsn.wissentest.web;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class HealthServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ServletUtils.writeJson(resp, new Status("ok"));
    }

    private static class Status {
        private final String status;

        private Status(String status) {
            this.status = status;
        }
    }
}
