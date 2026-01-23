/*
 * Datei: JdbcQuestionImageDao.java
 * JDBC-Implementierung für Bildspeicherung in der DB.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.QuestionImage;
import de.dhsn.wissentest.util.DbConnectionManager;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Optional;

public class JdbcQuestionImageDao implements QuestionImageDao {
    private final DataSource dataSource;

    public JdbcQuestionImageDao() {
        this(DbConnectionManager.getDataSource());
    }

    public JdbcQuestionImageDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public int create(byte[] data, String contentType) {
        String sql = "INSERT INTO question_images (content_type, data) VALUES (?, ?)";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, contentType);
            ps.setBytes(2, data);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create question image", e);
        }
        return 0;
    }

    @Override
    public Optional<QuestionImage> findById(int id) {
        String sql = "SELECT id, content_type, data FROM question_images WHERE id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(new QuestionImage(
                            rs.getInt("id"),
                            rs.getString("content_type"),
                            rs.getBytes("data")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to load question image", e);
        }
        return Optional.empty();
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM question_images WHERE id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete question image", e);
        }
    }
}
