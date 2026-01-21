/*
 * Datei: Question.java
 * Diese Klasse ist das einfache Daten-Objekt für eine einzelne Frage. Sie speichert nur die wichtigsten
 * Eigenschaften wie Typ (Multiple-Choice oder Lückentext), Schwierigkeitsgrad, Punkte und den Fragetext.
 * Die Klasse enthält keine Logik, sondern wird von anderen Teilen des Projekts benutzt, um Fragen zu
 * transportieren und in der Datenbank zu speichern oder wieder zu laden.
 * Verbindung: Wird von QuestionRepository/JdbcQuestionRepository geladen und in AdminService/TestService verarbeitet.
 */
package de.dhsn.wissentest.model;

public class Question {
    private int id;
    private QuestionType type;
    private String prompt;
    private int difficulty;
    private int points;
    private String metaJson;
    private String imageUrl;
    private String category;

    public Question() {
    }

    public Question(int id, QuestionType type, String prompt, int difficulty, int points, String metaJson, String imageUrl, String category) {
        this.id = id;
        this.type = type;
        this.prompt = prompt;
        this.difficulty = difficulty;
        this.points = points;
        this.metaJson = metaJson;
        this.imageUrl = imageUrl;
        this.category = category;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public QuestionType getType() {
        return type;
    }

    public void setType(QuestionType type) {
        this.type = type;
    }

    public String getPrompt() {
        return prompt;
    }

    public void setPrompt(String prompt) {
        this.prompt = prompt;
    }

    public int getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(int difficulty) {
        this.difficulty = difficulty;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public String getMetaJson() {
        return metaJson;
    }

    public void setMetaJson(String metaJson) {
        this.metaJson = metaJson;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}
