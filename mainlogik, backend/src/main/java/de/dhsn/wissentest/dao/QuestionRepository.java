/*
 * Datei: QuestionRepository.java
 *
 * EINFACHE ERKLÄRUNG FÜR STUDENTEN:
 * Das ist der "Vertrag" für unsere Datenbank. Hier steht, welche Befehle es gibt 
 * (z.B. "Finde Frage X", "Lösche Frage Y"), aber nicht WIE sie funktionieren.
 * Das "Wie" steht in der Implementierung (`JdbcQuestionRepository`).
 * Das nennt man "Interface" - eine der wichtigsten Regeln in sauberem Java-Code.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.Question;

import java.util.List;
import java.util.Optional;

public interface QuestionRepository {
    int create(Question question);
    boolean update(Question question);
    boolean delete(int id);
    Optional<Question> findById(int id);
    List<Question> findByDifficulty(int difficulty, int limit);
    List<Question> findByDifficultyAndCategory(int difficulty, int limit, String category);
    List<Question> findAll();
    List<String> findAllCategories();
}
