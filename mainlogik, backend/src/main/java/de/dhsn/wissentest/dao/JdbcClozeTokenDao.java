/*
 * Datei: JdbcClozeTokenDao.java
 * Hier steckt der konkrete SQL-Zugriff für Lückentext-Tokens. Es werden Tokens nach Frage-ID
 * geladen oder gespeichert, sodass die Auswertung später zuverlässig funktioniert.
 * Verbindung: Nutzt DbConnectionManager; verwendet in AdminService/TestService.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.ClozeToken;
import de.dhsn.wissentest.util.DbConnectionManager;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JdbcClozeTokenDao implements ClozeTokenDao {
    private final DataSource dataSource;

    public JdbcClozeTokenDao() {
        this(DbConnectionManager.getDataSource());
    }

    public JdbcClozeTokenDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public int create(ClozeToken token) {
        String sql = "INSERT INTO cloze_answers (question_id, token_index, expected_text, partial_value) VALUES (?,?,?,?)";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, token.getQuestionId());
            ps.setInt(2, token.getTokenIndex());
            ps.setString(3, token.getExpectedText());
            ps.setDouble(4, token.getPartialValue());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create cloze token", e);
        }
        return 0;
    }

    @Override
    public List<ClozeToken> findByQuestion(int questionId) {
        String sql = "SELECT id, question_id, token_index, expected_text, partial_value FROM cloze_answers WHERE question_id = ? ORDER BY token_index";
        List<ClozeToken> result = new ArrayList<>();
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to load cloze tokens", e);
        }
        return result;
    }

    @Override
    public boolean deleteByQuestion(int questionId) {
        String sql = "DELETE FROM cloze_answers WHERE question_id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete cloze tokens by question", e);
        }
    }

    private ClozeToken mapRow(ResultSet rs) throws SQLException {
        return new ClozeToken(
                rs.getInt("id"),
                rs.getInt("question_id"),
                rs.getInt("token_index"),
                rs.getString("expected_text"),
                rs.getDouble("partial_value")
        );
    }
}
