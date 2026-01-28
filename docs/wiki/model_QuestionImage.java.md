# model/QuestionImage.java

Einfache Erklärung: Dieses Objekt speichert ein Bild, das zu einer Frage gehört. Das Bild wird direkt in der Datenbank als Byte-Array abgelegt.

## Zweck
Domänenmodell für in der Datenbank gespeicherte Fragebilder. Ermöglicht Bild-Fragen ohne externen Dateispeicher.

## Inhalt & Verantwortung
- `id` – Eindeutige ID des Bildes in der DB.
- `contentType` – MIME-Typ (z.B. `image/png`, `image/jpeg`).
- `data` – Die Bilddaten als Byte-Array.

## Verbindungen
- Persistiert via `QuestionImageDao` / `JdbcQuestionImageDao`.
- Ausgeliefert über `ImageServlet` (`GET /api/images/{id}`).
- Hochgeladen über `AdminServlet` (`POST /api/admin/images`).

## Code-Beispiel
```java
public class QuestionImage {
    private int id;
    private String contentType;
    private byte[] data;

    // Getter & Setter
}
```

## Datenbank-Tabelle
```sql
CREATE TABLE question_images (
    id SERIAL PRIMARY KEY,
    content_type VARCHAR(50) NOT NULL,
    data BYTEA NOT NULL
);
```
