/*
 * Datei: JdbcConfigDao.java
 * JDBC-Implementierung für das Lesen von Konfiguration aus der Tabelle "config".
 * Verbindung: Nutzt DbConnectionManager; wird in Services für Progression verwendet.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.util.DbConnectionManager;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

public class JdbcConfigDao implements ConfigDao {
    private final DataSource dataSource;

    public JdbcConfigDao() {
        this(DbConnectionManager.getDataSource());
    }

    public JdbcConfigDao(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public Optional<String> findValue(String key) {
        String sql = "SELECT value FROM config WHERE key = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.ofNullable(rs.getString("value"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to load config value: " + key, e);
        }
        return Optional.empty();
    }
}
