/*
 * Datei: JdbcAnswerDao.java
 * Diese Klasse führt die SQL-Befehle aus, um Multiple-Choice-Antworten zu speichern und zu laden.
 * So können Services sich auf die Logik konzentrieren, ohne SQL direkt zu nutzen.
 * Verbindung: Nutzt DbConnectionManager und wird von AdminService/TestService aufgerufen.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.AnswerOption;
import de.dhsn.wissentest.util.DbConnectionManager;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JdbcAnswerDao implements AnswerDao {
    private final DataSource dataSource;

    public JdbcAnswerDao() {
        this(DbConnectionManager.getDataSource());
    }

    public JdbcAnswerDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public int create(AnswerOption option) {
        String sql = "INSERT INTO answers (question_id, answer_text, is_correct, partial_value) VALUES (?,?,?,?)";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, option.getQuestionId());
            ps.setString(2, option.getAnswerText());
            ps.setBoolean(3, option.isCorrect());
            ps.setDouble(4, option.getPartialValue());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create answer option", e);
        }
        return 0;
    }

    @Override
    public List<AnswerOption> findByQuestion(int questionId) {
        String sql = "SELECT id, question_id, answer_text, is_correct, partial_value FROM answers WHERE question_id = ? ORDER BY id";
        List<AnswerOption> result = new ArrayList<>();
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to load answers", e);
        }
        return result;
    }

    @Override
    public boolean deleteByQuestion(int questionId) {
        String sql = "DELETE FROM answers WHERE question_id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete answers by question", e);
        }
    }

    private AnswerOption mapRow(ResultSet rs) throws SQLException {
        return new AnswerOption(
                rs.getInt("id"),
                rs.getInt("question_id"),
                rs.getString("answer_text"),
                rs.getBoolean("is_correct"),
                rs.getDouble("partial_value")
        );
    }
}
