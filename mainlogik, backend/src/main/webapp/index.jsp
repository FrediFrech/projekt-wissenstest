<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% 
    boolean isLoggedIn = session.getAttribute("user") != null; 
    String userRole = (session.getAttribute("role") != null) ? session.getAttribute("role").toString() : "student";
    boolean isAdmin = "admin".equalsIgnoreCase(userRole);
%>
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wissenstest Native</title>
    <!-- High End CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css_native/style.css">
    <!-- Google Fonts for High End Look -->
    <script>
        // Inject Session Info for JS
        window.USER_ROLE = "<%= session.getAttribute("role") != null ? session.getAttribute("role") : "guest" %>";
        window.IS_LOGGED_IN = <%= isLoggedIn %>;
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
</head>
<body>
    <% 
       String pageParamInfo = request.getParameter("page");
       boolean isWidePage = "adminPanel".equals(pageParamInfo) || "learnMode".equals(pageParamInfo);
       String containerStyle = "padding-top: 1rem;";
       if (isWidePage) {
           containerStyle += " max-width: 98%;";
       }
    %>
    <div class="container" style="<%= containerStyle %>">
        <!-- Navigation -->
        <nav class="navbar" style="margin-bottom: 1rem;">
            <a href="?page=landingPage" style="text-decoration:none;">
                <div class="logo">✨ UML Wissenstest</div>
            </a>
            <div class="nav-links">
                <% if (!isLoggedIn) { %>
                    <a href="?page=login" class="btn btn-ghost">Login</a>
                    <a href="?page=register" class="btn btn-primary">Registrieren</a>
                <% } else { %>
                    <a href="?page=testList" class="btn btn-ghost">Tests</a>
                    <a href="?page=examMode" class="btn btn-ghost" style="color: #dc2626;">Pruefung (Exam)</a>
                    <a href="?page=learnMode" class="btn btn-ghost">Lernen</a>
                    <% if (session.getAttribute("role") != null && session.getAttribute("role").toString().equalsIgnoreCase("admin")) { %>
                        <a href="?page=adminPanel" class="btn btn-ghost" style="color:#ef4444;">Admin Panel</a>
                    <% } %>
                    <button onclick="logout()" class="btn btn-ghost">Logout</button>
                <% } %>
            </div>
        </nav>

        <!-- Dynamic Content Loading (SPA-like feel via JSP Includes) -->
        <main id="main-content">
            <% 
               String pageParam = request.getParameter("page");
               if (pageParam == null || pageParam.isEmpty()) {
                   pageParam = "landingPage";
               }
               
               // Security: Only allow specific pages to prevent arbitrary file inclusion
               // Mapping: Param -> React-Matched JSP Component
               if(pageParam.equals("landingPage")) {
            %>
                <jsp:include page="jsp_native/LandingPage.jsp" />
            <% } else if(pageParam.equals("login")) { %>
                <jsp:include page="jsp_native/Login.jsp" />
            <% } else if(pageParam.equals("register")) { %>
                <jsp:include page="jsp_native/Register.jsp" />
            <% } else if(pageParam.equals("testList")) { %>
                <jsp:include page="jsp_native/TestList.jsp" />
            <% } else if(pageParam.equals("testRunner")) { %>
                <jsp:include page="jsp_native/TestRunner.jsp" />
            <% } else if(pageParam.equals("adminPanel")) { %>
                <% if (isAdmin) { %>
                    <jsp:include page="jsp_native/AdminPanel.jsp" />
                <% } else { %>
                    <jsp:include page="jsp_native/AccessDenied.jsp" />
                <% } %>
            <% } else if(pageParam.equals("result")) { %>
                <jsp:include page="jsp_native/Result.jsp" />
            <% } else if(pageParam.equals("learnMode")) { %>
                <jsp:include page="jsp_native/LearnMode.jsp" />
            <% } else if(pageParam.equals("examMode")) { %>
                <jsp:include page="jsp_native/ExamMode.jsp" />
            <% } else { %>
                <jsp:include page="jsp_native/LandingPage.jsp" />
            <% } %>
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/js_native/app_main.js?v=20260128-2"></script>
</body>
</html>
