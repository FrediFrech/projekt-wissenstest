/*
 * Datei: ClozeToken.java
 * Dieses Objekt repräsentiert ein erwartetes Wort (Token) in einer Lückentext-Frage. Über den Index
 * wird die Reihenfolge festgelegt, und über partialValue kann Teilwertung vergeben werden.
 * Verbindung: ClozeTokenDao speichert Tokens; TestService nutzt sie beim Vergleichen der Antworten.
 */
package de.dhsn.wissentest.model;

public class ClozeToken {
    private int id;
    private int questionId;
    private int tokenIndex;
    private String expectedText;
    private double partialValue;

    public ClozeToken() {
    }

    public ClozeToken(int id, int questionId, int tokenIndex, String expectedText, double partialValue) {
        this.id = id;
        this.questionId = questionId;
        this.tokenIndex = tokenIndex;
        this.expectedText = expectedText;
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

    public int getTokenIndex() {
        return tokenIndex;
    }

    public void setTokenIndex(int tokenIndex) {
        this.tokenIndex = tokenIndex;
    }

    public String getExpectedText() {
        return expectedText;
    }

    public void setExpectedText(String expectedText) {
        this.expectedText = expectedText;
    }

    public double getPartialValue() {
        return partialValue;
    }

    public void setPartialValue(double partialValue) {
        this.partialValue = partialValue;
    }
}
