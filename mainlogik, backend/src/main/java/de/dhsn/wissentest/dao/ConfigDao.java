/*
 * Datei: ConfigDao.java
 * Einfaches Interface zum Lesen von Konfigurationswerten aus der DB.
 * Verbindung: Implementiert in JdbcConfigDao und in Services genutzt.
 */
package de.dhsn.wissentest.dao;

import java.util.Optional;

public interface ConfigDao {
    Optional<String> findValue(String key);
}
