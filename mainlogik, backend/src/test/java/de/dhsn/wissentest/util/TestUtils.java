package de.dhsn.wissentest.util;

import java.util.UUID;
import java.util.Random;

public class TestUtils {

    private static final Random RANDOM = new Random();

    /**
     * Erzeugt einen zufälligen Benutzernamen, z.B. "TestUser_a1b2"
     * Hilfreich, um Konflikte (Unique Constraint) in der DB zu vermeiden.
     */
    public static String randomUsername() {
        return "TestUser_" + UUID.randomUUID().toString().substring(0, 8);
    }

    /**
     * Erzeugt eine zufällige E-Mail-Adresse.
     */
    public static String randomEmail() {
        return randomUsername() + "@example.com";
    }

    /**
     * Erzeugt eine zufällige Zahl zwischen min und max.
     */
    public static int randomInt(int min, int max) {
        return RANDOM.nextInt(max - min + 1) + min;
    }
}
