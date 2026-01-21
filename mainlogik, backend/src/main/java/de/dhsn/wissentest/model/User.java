/*
 * Datei: User.java
 * Diese Klasse beschreibt einen Benutzer im System. Sie enthält Name, E-Mail, Rolle sowie Hash und
 * Salt des Passworts. Die eigentliche Logik ist nicht hier, sondern in AuthService – dieses Objekt ist
 * nur der Datencontainer.
 * Verbindung: Wird von UserDao/Repository geladen und in AuthService sowie AuthServlet genutzt.
 */
package de.dhsn.wissentest.model;

public class User {
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private String passwordSalt;
    private String role;
    private boolean resetRequested;

    public User() {
    }

    public User(int id, String username, String email, String passwordHash, String passwordSalt, String role) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.passwordSalt = passwordSalt;
        this.role = role;
    }

    public boolean isResetRequested() {
        return resetRequested;
    }

    public void setResetRequested(boolean resetRequested) {
        this.resetRequested = resetRequested;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getPasswordSalt() {
        return passwordSalt;
    }

    public void setPasswordSalt(String passwordSalt) {
        this.passwordSalt = passwordSalt;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
