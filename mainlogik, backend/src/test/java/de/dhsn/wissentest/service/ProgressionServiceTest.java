/*
 * Datei: ProgressionServiceTest.java
 * Dieser Test prüft die Schwellenwerte der Progression, damit klar ist, wann ein Nutzer
 * hoch- oder heruntergestuft werden würde. Die Werte sind Platzhalter, aber die Logik muss stimmen.
 * Verbindung: Testet ProgressionService.
 */
package de.dhsn.wissentest.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ProgressionServiceTest {
    @Test
    void promotionAndDemotionThresholds() {
        ProgressionService service = new ProgressionService(0.7, 0.4, 3);

        assertTrue(service.shouldPromote(0.7));
        assertTrue(service.shouldPromote(0.9));
        assertFalse(service.shouldPromote(0.69));

        assertTrue(service.shouldDemote(0.4));
        assertTrue(service.shouldDemote(0.2));
        assertFalse(service.shouldDemote(0.41));

        assertEquals(3, service.getWindowSize());
    }
}
