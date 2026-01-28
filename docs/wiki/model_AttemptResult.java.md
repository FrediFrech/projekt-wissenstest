# model/AttemptResult.java

Einfache Erklärung: Dieses Objekt bündelt das Ergebnis eines abgeschlossenen Tests – es enthält den Versuch selbst plus die Details zu jeder einzelnen Frage.

## Zweck
Wrapper-Klasse, die nach dem Absenden eines Tests zurückgegeben wird. Kombiniert den gespeicherten `Attempt` mit einer Liste von `QuestionResultDetail`-Objekten.

## Inhalt & Verantwortung
- `attempt` – Der gespeicherte Versuch (Score, Datum, Dauer).
- `details` – Liste der Einzelergebnisse pro Frage (was wurde geantwortet, was war richtig).

## Verbindungen
- Erstellt von `TestService.submitAttempt()`.
- Zurückgegeben über `TestServlet` an das Frontend (Result.jsp).

## Code-Beispiel
```java
public class AttemptResult {
    private Attempt attempt;
    private List<QuestionResultDetail> details;

    public AttemptResult(Attempt attempt, List<QuestionResultDetail> details) {
        this.attempt = attempt;
        this.details = details;
    }

    public Attempt getAttempt() { return attempt; }
    public List<QuestionResultDetail> getDetails() { return details; }
}
```
