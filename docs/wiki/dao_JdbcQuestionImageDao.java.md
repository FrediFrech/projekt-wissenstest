# dao/JdbcQuestionImageDao.java

Einfache Erklärung: Diese Klasse speichert und lädt Fragebilder aus der PostgreSQL-Datenbank als Byte-Arrays.

## Zweck
JDBC-Implementierung des `QuestionImageDao`-Interfaces. Speichert Bilder direkt in der Datenbank (BYTEA-Spalte).

## Inhalt & Verantwortung
- `create()` – INSERT eines neuen Bildes, gibt auto-generierte ID zurück.
- `findById()` – SELECT eines Bildes anhand der ID.
- `delete()` – DELETE eines Bildes.

## Verbindungen
- Implementiert `QuestionImageDao`.
- Nutzt `DbConnectionManager` für DB-Connections.
- Genutzt von `AdminServlet` und `ImageServlet`.

## SQL-Operationen
```sql
-- Create
INSERT INTO question_images (content_type, data) VALUES (?, ?) RETURNING id

-- Find
SELECT id, content_type, data FROM question_images WHERE id = ?

-- Delete
DELETE FROM question_images WHERE id = ?
```

## Hinweise
- Bilder werden als `BYTEA` gespeichert (PostgreSQL).
- Maximal 5 MB pro Bild (konfiguriert in `AdminServlet` via `@MultipartConfig`).
