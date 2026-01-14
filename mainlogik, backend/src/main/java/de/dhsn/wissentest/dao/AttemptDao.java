/*
 * Datei: AttemptDao.java
 * Dieses Interface definiert, wie Testversuche und Antworten gespeichert werden. Es hilft dabei,
 * die Auswertungslogik sauber von der Datenbankzugriffsschicht zu trennen.
 * Verbindung: Implementiert in JdbcAttemptDao und genutzt in TestService.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.Attempt;
import de.dhsn.wissentest.model.AttemptAnswer;

import java.util.List;

public interface AttemptDao {
    int createAttempt(Attempt attempt);
    void saveAttemptAnswers(int attemptId, List<AttemptAnswer> answers);
}
