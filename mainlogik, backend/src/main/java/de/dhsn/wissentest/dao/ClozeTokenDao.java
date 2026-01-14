/*
 * Datei: ClozeTokenDao.java
 * Dieses Interface beschreibt den Zugriff auf erwartete Lückentext-Tokens. Damit bleibt die
 * Testlogik übersichtlich und unabhängig vom Datenbankschema.
 * Verbindung: Wird durch JdbcClozeTokenDao implementiert und von AdminService/TestService genutzt.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.ClozeToken;

import java.util.List;

public interface ClozeTokenDao {
    int create(ClozeToken token);
    List<ClozeToken> findByQuestion(int questionId);
    boolean deleteByQuestion(int questionId);
}
