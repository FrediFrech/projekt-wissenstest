/*
 * Datei: UserDao.java
 * Dieses Interface beschreibt, welche Benutzer-Operationen die Datenbank unterstützen muss. Es ist
 * eine Art "Vertrag" zwischen Service-Schicht und Datenbankzugriff. Dadurch bleibt der Rest des
 * Programms unabhängig von SQL-Details.
 * Verbindung: Wird durch JdbcUserDao umgesetzt und von AuthService/AdminServlet genutzt.
 */
package de.dhsn.wissentest.dao;

import de.dhsn.wissentest.model.User;

import java.util.Optional;
import java.util.List;

public interface UserDao {
    int create(User user);
    Optional<User> findByUsername(String username);
    Optional<User> findById(int id);
    List<User> findAll();
    boolean delete(int id);
    void update(User user);
    void setPasswordResetRequested(int userId, boolean requested);
    List<User> findPasswordResetRequests();
}
