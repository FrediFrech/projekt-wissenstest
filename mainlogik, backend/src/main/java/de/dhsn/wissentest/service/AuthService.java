/*
 * Datei: AuthService.java
 * 
 * EINFACHE ERKLÄRUNG FÜR STUDENTEN:
 * Dies ist der "Türsteher" der App. 
 * Hier wird entschieden, wer rein darf (Login) und wer neu dazu kommt (Register).
 * Er benutzt `UserDao`, um Daten zu holen, und `PasswordUtils`, um Passwörter sicher zu prüfen.
 * Nichts passiert im Login-Bereich ohne diese Klasse.
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
        validateLoginInput(username, password);
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
        validateLoginInput(username, password);
        User user = userDao.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("Invalid credentials"));
        if (!PasswordUtils.verifyPassword(password, user.getPasswordSalt(), user.getPasswordHash())) {
            throw new IllegalArgumentException("Invalid credentials");
        }
        return user;
    }

    private void validateLoginInput(String username, String password) {
        if (username == null || username.isBlank()) {
            throw new IllegalArgumentException("Invalid credentials");
        }
        String trimmed = username.trim();
        if (trimmed.length() < 3 || trimmed.length() > 50) {
            throw new IllegalArgumentException("Invalid credentials");
        }
        if (!trimmed.matches("[A-Za-z0-9._-]+")) {
            throw new IllegalArgumentException("Invalid credentials");
        }
        if (password == null || password.length() < 6 || password.length() > 128) {
            throw new IllegalArgumentException("Invalid credentials");
        }
    }

    public void requestPasswordReset(String username) {
        User user = userDao.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        userDao.setPasswordResetRequested(user.getId(), true);
    }
}
