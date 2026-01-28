# web/ImageServlet.java

Einfache Erklärung: Dieses Servlet liefert Fragebilder aus der Datenbank an den Browser – z.B. für Bild-Fragen im Quiz.

## Zweck
HTTP-Endpunkt zum Abrufen von in der Datenbank gespeicherten Bildern.

## Endpunkt
| Methode | Pfad | Beschreibung |
|---------|------|-------------|
| GET | `/api/images/{id}` | Liefert Bild mit der angegebenen ID |

## Verhalten
1. Extrahiert die Bild-ID aus dem Pfad.
2. Lädt das Bild über `QuestionImageDao.findById()`.
3. Setzt `Content-Type` Header (z.B. `image/png`).
4. Setzt Cache-Header (`max-age=86400` = 1 Tag).
5. Schreibt die Bilddaten in den Response-OutputStream.

## Fehlerbehandlung
- `400 Bad Request` – Keine oder ungültige ID.
- `404 Not Found` – Bild existiert nicht.

## Verbindungen
- Nutzt `JdbcQuestionImageDao`.
- Registriert in `web.xml` unter `/api/images/*`.
- Aufgerufen von `<img>` Tags im Frontend (z.B. AdminPanel, TestRunner).

## Code-Auszug
```java
@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
    String idStr = req.getPathInfo().substring(1);
    int id = Integer.parseInt(idStr);
    
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
```
