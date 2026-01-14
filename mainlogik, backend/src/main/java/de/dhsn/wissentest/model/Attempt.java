/*
 * Datei: Attempt.java
 * Dieses Objekt beschreibt einen abgeschlossenen Testversuch. Es enthält, wie viele Punkte erreicht
 * wurden, wie viele maximal möglich waren und mit welcher Schwierigkeit der Test gestartet wurde.
 * Verbindung: AttemptDao speichert diese Daten; TestService erzeugt sie nach der Auswertung.
 */
package de.dhsn.wissentest.model;

import java.time.OffsetDateTime;

public class Attempt {
    private int id;
    private int userId;
    private double totalPoints;
    private double maxPoints;
    private int difficulty;
    private OffsetDateTime createdAt;

    public Attempt() {
    }

    public Attempt(int id, int userId, double totalPoints, double maxPoints, int difficulty, OffsetDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.totalPoints = totalPoints;
        this.maxPoints = maxPoints;
        this.difficulty = difficulty;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(double totalPoints) {
        this.totalPoints = totalPoints;
    }

    public double getMaxPoints() {
        return maxPoints;
    }

    public void setMaxPoints(double maxPoints) {
        this.maxPoints = maxPoints;
    }

    public int getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(int difficulty) {
        this.difficulty = difficulty;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(OffsetDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
