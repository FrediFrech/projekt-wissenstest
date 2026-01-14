/*
 * Datei: AuthService.java
 * Diese Service-Klasse bündelt die komplette Login- und Registrierung-Logik. Sie prüft, ob ein
 * Benutzername bereits existiert, erzeugt Hash + Salt und validiert die Zugangsdaten beim Login.
 * Verbindung: Nutzt UserDao und PasswordUtils; wird von AuthServlet aufgerufen.
 */
package de.dhsn.wissentest.service;

import de.dhsn.wissentest.dao.UserDao;
import de.dhsn.wissentest.model.User;
import de.dhsn.wissentest.util.PasswordUtils;

import java.util.Optional;

public class AuthService {
    private final UserDao userDao;

    public AuthService(UserDao userDao) {
        this.userDao = userDao;
    }

    public User register(String username, String email, String password) {
        Optional<User> existing = userDao.findByUsername(username);
        if (existing.isPresent()) {
            throw new IllegalArgumentException("Username already exists");
        }
        String salt = PasswordUtils.generateSaltHex();
        String hash = PasswordUtils.hashPassword(password, salt);
        User user = new User(0, username, email, hash, salt, "student");
        int id = userDao.create(user);
        user.setId(id);
        return user;
    }

    public User login(String username, String password) {
        User user = userDao.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));
        if (!PasswordUtils.verifyPassword(password, user.getPasswordSalt(), user.getPasswordHash())) {
            throw new IllegalArgumentException("Invalid credentials");
        }
        return user;
    }
}
