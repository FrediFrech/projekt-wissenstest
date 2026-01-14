# dao/QuestionRepository.java

Einfache Erklärung: Das ist die verständliche Schnittstelle für Fragen. Sie sagt nur, welche Aktionen möglich sind (anlegen, suchen, löschen), nicht wie sie intern passieren.

## Zweck
Dieses Interface beschreibt in einfachen Worten den Zugriff auf Fragen in der Datenbank. Es ist der verständlichere Name für das frühere „QuestionDao“.

## Inhalt & Verantwortung
- Anlegen, Ändern, Löschen und Suchen von Fragen.
- Keine SQL‑Details, nur Methoden‑Signaturen.

## Verbindungen
- Implementiert durch `JdbcQuestionRepository`.
- Genutzt von `AdminService` und `TestService`.
