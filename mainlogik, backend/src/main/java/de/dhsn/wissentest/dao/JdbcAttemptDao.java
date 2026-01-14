/*
 * Datei: JdbcAttemptDao.java
 * Diese Klasse enthält die SQL-Befehle, um Versuche und deren Antworten zu speichern. So bleiben
 * Punktevergabe und Testlogik getrennt vom Datenbankcode.
 * Verbindung: Nutzt DbConnectionManager; wird von TestService verwendet.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.Attempt;
import de.dhsn.wissentest.model.AttemptAnswer;
import de.dhsn.wissentest.util.DbConnectionManager;

import javax.sql.DataSource;
import java.sql.*;
import java.util.List;

public class JdbcAttemptDao implements AttemptDao {
    private final DataSource dataSource;

    public JdbcAttemptDao() {
        this(DbConnectionManager.getDataSource());
    }

    public JdbcAttemptDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public int createAttempt(Attempt attempt) {
        String sql = "INSERT INTO attempts (user_id, total_points, max_points, difficulty) VALUES (?,?,?,?)";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, attempt.getUserId());
            ps.setDouble(2, attempt.getTotalPoints());
            ps.setDouble(3, attempt.getMaxPoints());
            ps.setInt(4, attempt.getDifficulty());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create attempt", e);
        }
        return 0;
    }

    @Override
    public void saveAttemptAnswers(int attemptId, List<AttemptAnswer> answers) {
        String sql = "INSERT INTO attempt_answers (attempt_id, question_id, given_answer, points_awarded) VALUES (?,?,?,?)";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (AttemptAnswer a : answers) {
                ps.setInt(1, attemptId);
                ps.setInt(2, a.getQuestionId());
                ps.setString(3, a.getGivenAnswer());
                ps.setDouble(4, a.getPointsAwarded());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to save attempt answers", e);
        }
    }
}
