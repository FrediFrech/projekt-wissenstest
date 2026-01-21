/*
 * Datei: QuestionType.java
 * Dieses Enum definiert, welche Fragetypen es im System gibt. So vermeiden wir Tippfehler und sorgen
 * dafür, dass überall dieselben Werte verwendet werden. Aktuell gibt es Multiple-Choice (MC) und
 * Lückentext (CLOZE).
 * Verbindung: Wird in Question sowie in Admin- und Test-Logik verwendet.
 */
package de.dhsn.wissentest.model;

public enum QuestionType {
    MC,
    CLOZE,
    FREE,
    IMAGE
}
