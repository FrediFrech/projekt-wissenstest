/*
 * Datei: QuestionImageDao.java
 * DAO-Interface für gespeicherte Fragebilder.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.QuestionImage;

import java.util.Optional;

public interface QuestionImageDao {
    int create(byte[] data, String contentType);
    Optional<QuestionImage> findById(int id);
    boolean delete(int id);
}
