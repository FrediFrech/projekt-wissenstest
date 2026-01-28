# model/QuestionResultDetail.java

Einfache Erklärung: Dieses Objekt beschreibt das Ergebnis einer einzelnen Frage nach dem Test – was der User geantwortet hat, was richtig war und wie viele Punkte es gab.

## Zweck
Detailinformationen zu einer beantworteten Frage. Wird im Ergebnisbildschirm (Result.jsp) angezeigt.

## Inhalt & Verantwortung
- `questionId` – ID der Frage.
- `prompt` – Fragetext.
- `imageUrl` – Optional: Bild-URL der Frage.
- `userAnswer` – Was der Benutzer geantwortet hat.
- `correctAnswer` – Die korrekte Antwort.
- `isCorrect` – War die Antwort richtig?
- `pointsObtained` – Erreichte Punkte.
- `maxPoints` – Maximal erreichbare Punkte.

## Verbindungen
- Erstellt in `TestService.submitAttempt()`.
- Teil von `AttemptResult.details`.
- Angezeigt in `Result.jsp`.

## Code-Beispiel
```java
public class QuestionResultDetail {
    public int questionId;
    public String prompt;
    public String imageUrl;
    public String userAnswer;
    public String correctAnswer;
    public boolean isCorrect;
    public double pointsObtained;
    public double maxPoints;
}
```
