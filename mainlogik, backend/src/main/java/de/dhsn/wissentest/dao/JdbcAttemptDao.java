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
        String sql = "INSERT INTO attempts (user_id, total_points, max_points, difficulty, grade, duration_seconds) VALUES (?,?,?,?,?,?)";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, attempt.getUserId());
            ps.setDouble(2, attempt.getTotalPoints());
            ps.setDouble(3, attempt.getMaxPoints());
            ps.setInt(4, attempt.getDifficulty());
            ps.setString(5, attempt.getGrade());
            ps.setInt(6, attempt.getDurationSeconds());
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

    @Override
    public List<Attempt> findByUser(int userId) {
        List<Attempt> list = new java.util.ArrayList<>();
        String sql = "SELECT id, user_id, total_points, max_points, difficulty, created_at, grade, duration_seconds FROM attempts WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Attempt a = new Attempt();
                    a.setId(rs.getInt("id"));
                    a.setUserId(rs.getInt("user_id"));
                    a.setTotalPoints(rs.getDouble("total_points"));
                    a.setMaxPoints(rs.getDouble("max_points"));
                    a.setDifficulty(rs.getInt("difficulty"));
                    a.setGrade(rs.getString("grade"));
                    a.setDurationSeconds(rs.getInt("duration_seconds"));
                    // created_at is default now() in DB, but we want to read it back
                    // Assuming created_at is TIMESTAMP WITH TIME ZONE
                    java.sql.Timestamp ts = rs.getTimestamp("created_at");
                    if (ts != null) {
                        a.setCreatedAt(ts.toInstant().atOffset(java.time.ZoneOffset.UTC)); 
                    }
                    
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to load user attempts", e);
        }
        return list;
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM attempts";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to count attempts", e);
        }
        return 0;
    }
}
