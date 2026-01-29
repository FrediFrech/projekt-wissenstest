/*
 * Datei: PasswordUtilsTest.java
 * Tests für Salt-Generierung und Passwort-Hashing.
 */
package de.dhsn.wissentest.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class PasswordUtilsTest {

    @Test
    void generateSaltHexProducesExpectedLengthAndDifferentValues() {
        String salt1 = PasswordUtils.generateSaltHex();
        String salt2 = PasswordUtils.generateSaltHex();

        assertNotNull(salt1);
        assertNotNull(salt2);
        assertEquals(32, salt1.length());
        assertEquals(32, salt2.length());
        assertNotEquals(salt1, salt2);
    }

    @Test
    void hashPasswordIsDeterministicAndVerifiable() {
        String salt = "00112233445566778899aabbccddeeff";
        String hash1 = PasswordUtils.hashPassword("P@ssw0rd!", salt);
        String hash2 = PasswordUtils.hashPassword("P@ssw0rd!", salt);

        assertEquals(hash1, hash2);
        assertTrue(PasswordUtils.verifyPassword("P@ssw0rd!", salt, hash1));
        assertFalse(PasswordUtils.verifyPassword("wrong", salt, hash1));
    }
}
