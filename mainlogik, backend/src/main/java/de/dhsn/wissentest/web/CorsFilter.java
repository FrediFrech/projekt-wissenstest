/*
 * Datei: CorsFilter.java
 * Dieser Filter erlaubt dem React-Frontend, auf die Backend-API zuzugreifen, auch wenn es auf einem
 * anderen Port läuft. Zusätzlich werden Credentials (Session-Cookies) erlaubt und OPTIONS-Anfragen
 * (Preflight) direkt beantwortet.
 * Verbindung: In web.xml für alle /api/*-Requests registriert.
 */
package de.dhsn.wissentest.web;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CorsFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletResponse res = (HttpServletResponse) response;
        HttpServletRequest req = (HttpServletRequest) request;
        String origin = req.getHeader("Origin");
        if (origin != null && !origin.isBlank()) {
            res.setHeader("Access-Control-Allow-Origin", origin);
        }
        res.setHeader("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
        res.setHeader("Access-Control-Allow-Credentials", "true");
        if (request instanceof HttpServletRequest
                && "OPTIONS".equalsIgnoreCase(((HttpServletRequest) request).getMethod())) {
            res.setStatus(HttpServletResponse.SC_OK);
            return;
        }
        chain.doFilter(request, response);
    }
}
