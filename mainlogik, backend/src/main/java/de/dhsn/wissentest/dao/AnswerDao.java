/*
 * Datei: AnswerDao.java
 * Dieses Interface beschreibt den Zugriff auf Antwortoptionen in der Datenbank. Es trennt die
 * fachliche Logik (Services) von den SQL-Details der Speicherung.
 * Verbindung: Wird durch JdbcAnswerDao implementiert und in AdminService/TestService verwendet.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.AnswerOption;

import java.util.List;

public interface AnswerDao {
    int create(AnswerOption option);
    List<AnswerOption> findByQuestion(int questionId);
    boolean deleteByQuestion(int questionId);
}
