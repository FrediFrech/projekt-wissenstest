/*
 * Datei: AttemptAnswer.java
 * Dieses Objekt speichert die Antwort eines Users auf eine konkrete Frage in einem Versuch und die
 * dafür berechneten Punkte. So kann später nachvollzogen werden, wie der Score entstanden ist.
 * Verbindung: Wird von TestService erzeugt und über AttemptDao gespeichert.
 */
package de.dhsn.wissentest.model;

public class AttemptAnswer {
    private int id;
    private int attemptId;
    private int questionId;
    private String givenAnswer;
    private double pointsAwarded;

    public AttemptAnswer() {
    }

    public AttemptAnswer(int id, int attemptId, int questionId, String givenAnswer, double pointsAwarded) {
        this.id = id;
        this.attemptId = attemptId;
        this.questionId = questionId;
        this.givenAnswer = givenAnswer;
        this.pointsAwarded = pointsAwarded;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getGivenAnswer() {
        return givenAnswer;
    }

    public void setGivenAnswer(String givenAnswer) {
        this.givenAnswer = givenAnswer;
    }

    public double getPointsAwarded() {
        return pointsAwarded;
    }

    public void setPointsAwarded(double pointsAwarded) {
        this.pointsAwarded = pointsAwarded;
    }
}
