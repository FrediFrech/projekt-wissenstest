# web/CharacterEncodingFilter.java

Einfache Erklärung: Dieser Filter sorgt dafür, dass alle Anfragen und Antworten UTF-8 verwenden – so funktionieren Umlaute (ä, ö, ü) und Sonderzeichen zuverlässig.

## Zweck
Servlet-Filter, der für alle Requests und Responses die Zeichenkodierung auf UTF-8 setzt.

## Verhalten
1. Setzt `request.setCharacterEncoding("UTF-8")`.
2. Setzt `response.setCharacterEncoding("UTF-8")`.
3. Leitet die Anfrage an den nächsten Filter/das Servlet weiter.

## Warum nötig?
Ohne explizites Setzen der Encoding könnte der Servlet-Container ISO-8859-1 verwenden, was zu fehlerhafter Darstellung von Umlauten führt – besonders bei POST-Daten (Formulare, JSON).

## Verbindungen
- Registriert in `web.xml` als globaler Filter für alle URLs (`/*`).
- Wird vor allen Servlets ausgeführt.

## web.xml Konfiguration
```xml
<filter>
    <filter-name>CharacterEncodingFilter</filter-name>
    <filter-class>de.dhsn.wissentest.web.CharacterEncodingFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>CharacterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

## Code
```java
public class CharacterEncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        chain.doFilter(request, response);
    }
}
```
