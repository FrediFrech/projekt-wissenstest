# model/Question.java

Einfache Erklärung: Dieses Objekt steht für eine Frage im Test. Es enthält den Text, die Schwierigkeit und die Punkte.

## Zweck
Repräsentiert eine Frage im System (Typ, Schwierigkeit, Punkte).

## Inhalt & Verantwortung
- Kernattribute: `type`, `prompt`, `difficulty`, `points`, `category`, `imageUrl`, `metaJson`.

## Verbindungen
- Persistiert via `QuestionRepository`.
- Genutzt in `AdminService` (CRUD) und `TestService` (Teststart/Scoring).
