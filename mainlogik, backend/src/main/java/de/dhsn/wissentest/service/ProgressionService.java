/*
 * Datei: ProgressionService.java
 * Diese Klasse enthält einfache, gut erklärbare Regeln, wann ein Nutzer in eine höhere oder
 * niedrigere Schwierigkeitsstufe wechseln soll. Die Schwellenwerte sind aktuell Platzhalter und
 * können später aus der Datenbank gelesen werden.
 * Verbindung: Wird optional im Testablauf verwendet; Schwellwerte in der config-Tabelle.
 */
package de.dhsn.wissentest.service;

public class ProgressionService {
    private final double promoteThreshold;
    private final double demoteThreshold;
    private final int windowSize;

    public ProgressionService() {
        this(0.70, 0.40, 3);
    }

    public ProgressionService(double promoteThreshold, double demoteThreshold, int windowSize) {
        this.promoteThreshold = promoteThreshold;
        this.demoteThreshold = demoteThreshold;
        this.windowSize = windowSize;
    }

    public boolean shouldPromote(double lastScoreRatio) {
        return lastScoreRatio >= promoteThreshold;
    }

    public boolean shouldDemote(double averageRecentRatio) {
        return averageRecentRatio <= demoteThreshold;
    }

    public int getWindowSize() {
        return windowSize;
    }
}
