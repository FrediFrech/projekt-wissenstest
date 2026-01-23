/*
 * Datei: QuestionImage.java
 * Enthält die im DB gespeicherten Bilddaten für Fragen.
 * Verbindung: JdbcQuestionImageDao und ImageServlet/AdminServlet.
 */
package de.dhsn.wissentest.model;

public class QuestionImage {
    private int id;
    private String contentType;
    private byte[] data;

    public QuestionImage() {
    }

    public QuestionImage(int id, String contentType, byte[] data) {
        this.id = id;
        this.contentType = contentType;
        this.data = data;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public byte[] getData() {
        return data;
    }

    public void setData(byte[] data) {
        this.data = data;
    }
}
