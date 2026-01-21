/*
 * Datei: QuestionRepository.java
 * Diese Schnittstelle beschreibt in einfachen Worten, wie der Code mit Fragen in der Datenbank arbeitet.
 * Sie kapselt die typischen Aktionen wie Anlegen, Ändern, Löschen und Suchen von Fragen,
 * damit andere Klassen nur die Methoden aufrufen müssen und nicht wissen müssen, wie SQL genau aussieht.
 * Verbindungen: Wird von JdbcQuestionRepository implementiert und in AdminService sowie TestService verwendet.
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
