/*
 * Datei: QuestionDao.java
 * Dieses Interface war der alte Name für den Zugriff auf Fragen in der Datenbank.
 * Viele Studierende kennen "DAO" nicht, deshalb heißt die neue Variante jetzt
 * verständlicher "QuestionRepository". Dieses Interface bleibt nur als Alias
 * erhalten, damit alte Referenzen nicht sofort brechen.
 * Verbindung: Erweitert QuestionRepository und ist damit vollständig kompatibel.
 */
package de.dhsn.wissentest.dao;

@Deprecated
public interface QuestionDao extends QuestionRepository {
}
