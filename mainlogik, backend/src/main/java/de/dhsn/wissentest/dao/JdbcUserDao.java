/*
 * Datei: JdbcUserDao.java
 * Diese Klasse enthält den eigentlichen SQL-Code, um Benutzer zu speichern und zu laden. Damit müssen
 * andere Teile des Programms kein SQL schreiben, sondern rufen nur Methoden wie findByUsername auf.
 * Verbindung: Nutzt DbConnectionManager und wird von AuthService/AdminServlet verwendet.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.User;
import de.dhsn.wissentest.util.DbConnectionManager;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JdbcUserDao implements UserDao {
    private final DataSource dataSource;

    public JdbcUserDao() {
        this(DbConnectionManager.getDataSource());
    }

    public JdbcUserDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public int create(User user) {
        String sql = "INSERT INTO users (username, email, password_hash, password_salt, role, reset_requested) VALUES (?,?,?,?,?,?)";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getPasswordSalt());
            ps.setString(5, user.getRole());
            ps.setBoolean(6, user.isResetRequested());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create user", e);
        }
        return 0;
    }

    @Override
    public Optional<User> findByUsername(String username) {
        String sql = "SELECT id, username, email, password_hash, password_salt, role, reset_requested FROM users WHERE username = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find user by username", e);
        }
        return Optional.empty();
    }

    @Override
    public Optional<User> findById(int id) {
        String sql = "SELECT id, username, email, password_hash, password_salt, role, reset_requested FROM users WHERE id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find user by id", e);
        }
        return Optional.empty();
    }


    @Override
    public List<User> findAll() {
        String sql = "SELECT id, username, email, password_hash, password_salt, role, reset_requested FROM users ORDER BY id";
        List<User> result = new ArrayList<>();
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to list users", e);
        }
        return result;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete user", e);
        }
    }

    @Override
    public void update(User user) {
        String sql = "UPDATE users SET username=?, email=?, role=?, password_hash=?, password_salt=?, reset_requested=? WHERE id=?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getPasswordHash());
            ps.setString(5, user.getPasswordSalt());
            ps.setBoolean(6, user.isResetRequested());
            ps.setInt(7, user.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to update user", e);
        }
    }

    @Override
    public void setPasswordResetRequested(int userId, boolean requested) {
        String sql = "UPDATE users SET reset_requested = ? WHERE id = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, requested);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to set reset requested", e);
        }
    }

    @Override
    public List<User> findPasswordResetRequests() {
         String sql = "SELECT id, username, email, password_hash, password_salt, role, reset_requested FROM users WHERE reset_requested = true ORDER BY id";
        List<User> result = new ArrayList<>();
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                result.add(mapRow(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to list password reset requests", e);
        }
        return result;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User(
                rs.getInt("id"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("password_hash"),
                rs.getString("password_salt"),
                rs.getString("role")
        );
        u.setResetRequested(rs.getBoolean("reset_requested"));
        return u;
    }
}
