/*
 * Datei: AuthServiceTest.java
 * Tests für Registrierung, Login und Passwort-Reset im AuthService.
 */
package de.dhsn.wissentest.service;

import de.dhsn.wissentest.dao.UserDao;
import de.dhsn.wissentest.model.User;
import de.dhsn.wissentest.util.PasswordUtils;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class AuthServiceTest {

    @Test
    void registerCreatesUserAndHashesPassword() {
        InMemoryUserDao userDao = new InMemoryUserDao();
        AuthService authService = new AuthService(userDao);

        User created = authService.register("alice", "alice@example.com", "S3cret!pw");

        assertTrue(created.getId() > 0);
        assertNotNull(created.getPasswordSalt());
        assertNotNull(created.getPasswordHash());
        assertNotEquals("S3cret!pw", created.getPasswordHash());
        assertEquals(32, created.getPasswordSalt().length());

        User stored = userDao.findByUsername("alice").orElseThrow();
        assertEquals(created.getId(), stored.getId());
        assertTrue(PasswordUtils.verifyPassword("S3cret!pw", stored.getPasswordSalt(), stored.getPasswordHash()));
    }

    @Test
    void loginRejectsInvalidPassword() {
        InMemoryUserDao userDao = new InMemoryUserDao();
        String salt = PasswordUtils.generateSaltHex();
        String hash = PasswordUtils.hashPassword("goodPass123", salt);
        userDao.create(new User(0, "bob", "bob@example.com", hash, salt, "student"));

        AuthService authService = new AuthService(userDao);

        assertThrows(IllegalArgumentException.class, () -> authService.login("bob", "wrongPass"));
    }

    @Test
    void requestPasswordResetFlagsUser() {
        InMemoryUserDao userDao = new InMemoryUserDao();
        int id = userDao.create(new User(0, "carla", "carla@example.com", "hash", "salt", "student"));

        AuthService authService = new AuthService(userDao);
        authService.requestPasswordReset("carla");

        User stored = userDao.findById(id).orElseThrow();
        assertTrue(stored.isResetRequested());
    }

    private static class InMemoryUserDao implements UserDao {
        private final Map<Integer, User> users = new HashMap<>();
        private final Map<String, Integer> byUsername = new HashMap<>();
        private int seq = 1;

        @Override
        public int create(User user) {
            int id = seq++;
            User stored = new User(id, user.getUsername(), user.getEmail(), user.getPasswordHash(), user.getPasswordSalt(), user.getRole());
            stored.setResetRequested(user.isResetRequested());
            users.put(id, stored);
            byUsername.put(stored.getUsername(), id);
            return id;
        }

        @Override
        public Optional<User> findByUsername(String username) {
            Integer id = byUsername.get(username);
            if (id == null) {
                return Optional.empty();
            }
            return Optional.of(users.get(id));
        }

        @Override
        public Optional<User> findById(int id) {
            return Optional.ofNullable(users.get(id));
        }

        @Override
        public List<User> findAll() {
            return new ArrayList<>(users.values());
        }

        @Override
        public boolean delete(int id) {
            User removed = users.remove(id);
            if (removed != null) {
                byUsername.remove(removed.getUsername());
                return true;
            }
            return false;
        }

        @Override
        public void update(User user) {
            if (users.containsKey(user.getId())) {
                users.put(user.getId(), user);
                byUsername.put(user.getUsername(), user.getId());
            }
        }

        @Override
        public void setPasswordResetRequested(int userId, boolean requested) {
            User user = users.get(userId);
            if (user != null) {
                user.setResetRequested(requested);
            }
        }

        @Override
        public List<User> findPasswordResetRequests() {
            List<User> result = new ArrayList<>();
            for (User u : users.values()) {
                if (u.isResetRequested()) {
                    result.add(u);
                }
            }
            return result;
        }
    }
}
