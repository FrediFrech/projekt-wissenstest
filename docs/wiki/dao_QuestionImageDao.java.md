# dao/QuestionImageDao.java

Einfache Erklärung: Dieses Interface definiert, wie Fragebilder in der Datenbank gespeichert und geladen werden.

## Zweck
DAO-Interface für die Verwaltung von Fragebildern (CRUD-Operationen).

## Methoden
| Methode | Beschreibung |
|---------|-------------|
| `create(byte[] data, String contentType)` | Speichert ein neues Bild, gibt die ID zurück |
| `findById(int id)` | Lädt ein Bild anhand der ID |
| `delete(int id)` | Löscht ein Bild |

## Verbindungen
- Implementiert von `JdbcQuestionImageDao`.
- Genutzt von `AdminServlet` (Upload) und `ImageServlet` (Auslieferung).

## Code
```java
public interface QuestionImageDao {
    int create(byte[] data, String contentType);
    Optional<QuestionImage> findById(int id);
    boolean delete(int id);
}
```
