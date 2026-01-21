/*
 * Datei: DbConnectionManager.java
 * Diese Klasse ist der zentrale Einstieg für Datenbankverbindungen. Sie liest die Einstellungen aus
 * der Datei db.properties und baut daraus einen Connection-Pool (HikariCP), damit nicht für jede SQL-
 * Anfrage eine neue Verbindung erstellt werden muss. Das macht die Anwendung schneller und stabiler.
 * Verbindung: Alle JDBC-Repositories/DAOs holen hier ihre DataSource.
 */
package de.dhsn.wissentest.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class DbConnectionManager {
    private static final String PROPERTIES_FILE = "/db.properties";
    private static HikariDataSource dataSource;

    private DbConnectionManager() {
    }

    public static synchronized DataSource getDataSource() {
        if (dataSource == null) {
            Properties props = new Properties();
            try (InputStream in = DbConnectionManager.class.getResourceAsStream(PROPERTIES_FILE)) {
                if (in == null) {
                    throw new IllegalStateException("db.properties not found on classpath");
                }
                props.load(in);
            } catch (IOException e) {
                throw new IllegalStateException("Failed to load db.properties", e);
            }

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.user"));
            config.setPassword(props.getProperty("db.password"));
            config.setDriverClassName("org.postgresql.Driver");
            config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.pool.maxSize", "10")));
            config.setPoolName("WissenstestPool");

            dataSource = new HikariDataSource(config);
        }
        return dataSource;
    }
}
