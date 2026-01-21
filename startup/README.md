# Startup Tools

Dieser Ordner enthält Skripte zur automatisierten Einrichtung und zum Start des Projekts.

## Inhalt
- `start_project.ps1`: Das Hauptskript. Es prüft, ob Java, Maven und Tomcat vorhanden sind (und lädt sie bei Bedarf herunter), baut das Projekt und startet den Server.
- `tools/`: Hier werden die heruntergeladenen Werkzeuge (JDK, Maven, Tomcat) gespeichert.

## Nutzung
1. Öffnen Sie PowerShell.
2. Navigieren Sie in diesen Ordner.
3. Führen Sie `.\start_project.ps1` aus.

## Hinweise für das Repository
Die Binärdateien (Java, Tomcat, Maven) werden beim ersten Start in den Ordner `tools/` heruntergeladen. Diese sind standardmäßig nicht im Git-Repository enthalten, um die Repository-Größe klein zu halten. Das Skript stellt sicher, dass sie auf jeder neuen Maschine automatisch beschafft werden.
