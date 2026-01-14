/*
 * Datei: JdbcQuestionDao.java
 * Diese Klasse war der alte Name für den JDBC-Zugriff auf Fragen. Um den Code
 * für Studierende verständlicher zu machen, heißt die eigentliche Implementierung
 * jetzt JdbcQuestionRepository. Diese Klasse bleibt nur als kompatibler Alias.
 * Verbindung: Erweitert JdbcQuestionRepository und übernimmt dessen Verhalten.
 */
package de.dhsn.wissentest.dao;

@Deprecated
public class JdbcQuestionDao extends JdbcQuestionRepository {
}
