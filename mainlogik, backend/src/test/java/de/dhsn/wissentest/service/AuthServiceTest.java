/*
 * Datei: AuthServiceTest.java
 * Dieser Test zeigt, dass Registrierung und Login funktionieren und dass falsche Passwörter sauber
 * abgefangen werden. Er nutzt eine InMemoryUserDao, damit die Tests ohne echte Datenbank laufen.
 * Verbindung: Testet AuthService, aber nicht die JDBC-Schicht.
 */
package de.dhsn.wissentest.service;

import de.dhsn.wissentest.dao.UserDao;
import de.dhsn.wissentest.model.User;
import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

class AuthServiceTest {
    @Test
    void registerAndLoginSuccess() {
        InMemoryUserDao dao = new InMemoryUserDao();
        AuthService service = new AuthService(dao);

        User registered = service.register("testuser", "test@example.com", "secret");
        assertTrue(registered.getId() > 0);

        User loggedIn = service.login("testuser", "secret");
        assertEquals("testuser", loggedIn.getUsername());
    }

    @Test
    void loginFailsOnWrongPassword() {
        InMemoryUserDao dao = new InMemoryUserDao();
        AuthService service = new AuthService(dao);
        service.register("testuser", "test@example.com", "secret");

        assertThrows(IllegalArgumentException.class, () -> service.login("testuser", "wrong"));
    }

    private static class InMemoryUserDao implements UserDao {
        private final Map<String, User> users = new HashMap<>();
        private int seq = 1;

        @Override
        public int create(User user) {
            user.setId(seq++);
            users.put(user.getUsername(), user);
            return user.getId();
        }

        @Override
        public Optional<User> findByUsername(String username) {
            return Optional.ofNullable(users.get(username));
        }

        @Override
        public Optional<User> findById(int id) {
            return users.values().stream().filter(u -> u.getId() == id).findFirst();
        }
    }
}
