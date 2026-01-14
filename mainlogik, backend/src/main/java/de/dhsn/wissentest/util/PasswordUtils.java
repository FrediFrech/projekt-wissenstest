/*
 * Datei: PasswordUtils.java
 * Diese Hilfsklasse kümmert sich darum, Passwörter sicher zu speichern. Statt Klartext wird ein
 * SHA-256 Hash mit Salt und mehreren Iterationen erzeugt, damit das Passwort nicht direkt lesbar ist.
 * Verbindung: AuthService nutzt diese Methoden bei Registrierung und Login; Hash/Salt landen in users.
 */
package de.dhsn.wissentest.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

public final class PasswordUtils {
    private static final int DEFAULT_ITERATIONS = 10_000;

    private PasswordUtils() {
    }

    public static String generateSaltHex() {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        return toHex(salt);
    }

    public static String hashPassword(String password, String saltHex) {
        return hashPassword(password, saltHex, DEFAULT_ITERATIONS);
    }

    public static String hashPassword(String password, String saltHex, int iterations) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] input = (password + saltHex).getBytes(StandardCharsets.UTF_8);
            byte[] hash = input;
            for (int i = 0; i < iterations; i++) {
                hash = digest.digest(hash);
            }
            return toHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 not available", e);
        }
    }

    public static boolean verifyPassword(String password, String saltHex, String expectedHashHex) {
        String actual = hashPassword(password, saltHex);
        return actual.equalsIgnoreCase(expectedHashHex);
    }

    private static String toHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
