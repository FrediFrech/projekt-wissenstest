/*
 * Datei: JdbcQuestionRepository.java
 * Diese Klasse ist die konkrete JDBC-Umsetzung für das Speichern und Laden von Fragen aus der Datenbank.
 * Sie enthält die SQL-Anweisungen und sorgt dafür, dass die Daten aus der Tabelle questions sauber in
 * Question-Objekte umgewandelt werden. Andere Teile des Programms müssen deshalb kein SQL kennen.
 * Verbindungen: Nutzt DbConnectionManager für die Verbindung und implementiert QuestionRepository.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.Question;
import de.dhsn.wissentest.model.QuestionType;
import de.dhsn.wissentest.util.DbConnectionManager;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JdbcQuestionRepository implements QuestionRepository {
    private final DataSource dataSource;

    public JdbcQuestionRepository() {
        this(DbConnectionManager.getDataSource());
    }

    public JdbcQuestionRepository(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public int create(Question question) {
        String sql = "INSERT INTO questions (type, prompt, difficulty, points, meta) VALUES (?,?,?,?,?::jsonb)";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, question.getType().name());
            ps.setString(2, question.getPrompt());
            ps.setInt(3, question.getDifficulty());
            ps.setInt(4, question.getPoints());
            ps.setString(5, question.getMetaJson() == null ? "{}" : question.getMetaJson());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create question", e);
        }
        return 0;
    }

    @Override
    public boolean update(Question question) {
        String sql = "UPDATE questions SET type=?, prompt=?, difficulty=?, points=?, meta=?::jsonb WHERE id=?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, question.getType().name());
            ps.setString(2, question.getPrompt());
            ps.setInt(3, question.getDifficulty());
            ps.setInt(4, question.getPoints());
            ps.setString(5, question.getMetaJson() == null ? "{}" : question.getMetaJson());
            ps.setInt(6, question.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update question", e);
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM questions WHERE id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete question", e);
        }
    }

    @Override
    public Optional<Question> findById(int id) {
        String sql = "SELECT id, type, prompt, difficulty, points, meta FROM questions WHERE id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find question", e);
        }
        return Optional.empty();
    }

    @Override
    public List<Question> findByDifficulty(int difficulty, int limit) {
        String sql = "SELECT id, type, prompt, difficulty, points, meta FROM questions WHERE difficulty = ? ORDER BY random() LIMIT ?";
        List<Question> result = new ArrayList<>();
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, difficulty);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find questions by difficulty", e);
        }
        return result;
    }

    @Override
    public List<Question> findAll() {
        String sql = "SELECT id, type, prompt, difficulty, points, meta FROM questions ORDER BY id";
        List<Question> result = new ArrayList<>();
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to list questions", e);
        }
        return result;
    }

    private Question mapRow(ResultSet rs) throws SQLException {
        return new Question(
                rs.getInt("id"),
                QuestionType.valueOf(rs.getString("type")),
                rs.getString("prompt"),
                rs.getInt("difficulty"),
                rs.getInt("points"),
                rs.getString("meta")
        );
    }
}
