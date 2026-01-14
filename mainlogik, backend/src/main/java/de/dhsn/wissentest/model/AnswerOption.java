/*
 * Datei: AnswerOption.java
 * Dieses Objekt beschreibt eine einzelne Antwortmöglichkeit bei Multiple-Choice-Fragen. Neben dem
 * Text speichert es, ob die Antwort korrekt ist und wie viele Teilpunkte sie bringt. So können
 * Teilrichtigkeiten bewertet werden.
 * Verbindung: AnswerDao lädt/speichert diese Optionen; TestService verwendet die Teilwerte beim Scoring.
 */
package de.dhsn.wissentest.model;

public class AnswerOption {
    private int id;
    private int questionId;
    private String answerText;
    private boolean correct;
    private double partialValue;

    public AnswerOption() {
    }

    public AnswerOption(int id, int questionId, String answerText, boolean correct, double partialValue) {
        this.id = id;
        this.questionId = questionId;
        this.answerText = answerText;
        this.correct = correct;
        this.partialValue = partialValue;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getAnswerText() {
        return answerText;
    }

    public void setAnswerText(String answerText) {
        this.answerText = answerText;
    }

    public boolean isCorrect() {
        return correct;
    }

    public void setCorrect(boolean correct) {
        this.correct = correct;
    }

    public double getPartialValue() {
        return partialValue;
    }

    public void setPartialValue(double partialValue) {
        this.partialValue = partialValue;
    }
}
