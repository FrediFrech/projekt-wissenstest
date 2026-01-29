# PlantUML Diagramm-Generator
# Generiert SVG und PNG Dateien aus allen .puml Dateien

param(
    [string]$DiagramDir = ".\Diagramme - Kopie",
    [switch]$SVGOnly,
    [switch]$PNGOnly
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

# PlantUML JAR Pfad
$PlantUMLJar = ".\plantuml.jar"

# Prüfen ob PlantUML JAR existiert
if (-not (Test-Path $PlantUMLJar)) {
    Write-Host "PlantUML JAR nicht gefunden. Lade herunter..." -ForegroundColor Yellow
    $downloadUrl = "https://github.com/plantuml/plantuml/releases/download/v1.2024.7/plantuml-1.2024.7.jar"
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $downloadUrl -OutFile $PlantUMLJar -UseBasicParsing
        Write-Host "PlantUML heruntergeladen: $PlantUMLJar" -ForegroundColor Green
    } catch {
        Write-Host "Fehler beim Download: $_" -ForegroundColor Red
        Write-Host "Bitte manuell herunterladen:" -ForegroundColor Yellow
        Write-Host "  $downloadUrl" -ForegroundColor Cyan
        Write-Host "  und als 'plantuml.jar' in diesem Ordner speichern."
        exit 1
    }
}

# Prüfen ob Java installiert ist
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "Java gefunden: $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "Java ist nicht installiert oder nicht im PATH!" -ForegroundColor Red
    Write-Host "Bitte Java installieren: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# Alle PUML-Dateien finden
$pumlFiles = Get-ChildItem -Path $DiagramDir -Filter "*.puml" -Recurse

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "PlantUML Diagramm-Generierung" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Gefundene PUML-Dateien: $($pumlFiles.Count)" -ForegroundColor White

$successCount = 0
$errorCount = 0

foreach ($pumlFile in $pumlFiles) {
    $relativePath = $pumlFile.FullName.Replace((Get-Location).Path + "\", "")
    Write-Host "`nVerarbeite: $relativePath" -ForegroundColor Yellow
    
    $outputDir = $pumlFile.DirectoryName
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($pumlFile.Name)
    
    try {
        # SVG generieren
        if (-not $PNGOnly) {
            Write-Host "  -> Generiere SVG..." -NoNewline
            java -jar $PlantUMLJar -tsvg -o "$outputDir" $pumlFile.FullName 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host " OK" -ForegroundColor Green
            } else {
                Write-Host " FEHLER" -ForegroundColor Red
            }
        }
        
        # PNG generieren
        if (-not $SVGOnly) {
            Write-Host "  -> Generiere PNG..." -NoNewline
            java -jar $PlantUMLJar -tpng -o "$outputDir" $pumlFile.FullName 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host " OK" -ForegroundColor Green
            } else {
                Write-Host " FEHLER" -ForegroundColor Red
            }
        }
        
        $successCount++
    } catch {
        Write-Host "  FEHLER: $_" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Zusammenfassung" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Erfolgreich: $successCount" -ForegroundColor Green
Write-Host "Fehler:      $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })

# Liste generierte Dateien
Write-Host "`nGenerierte Dateien:" -ForegroundColor Yellow
Get-ChildItem -Path $DiagramDir -Include "*.svg","*.png" -Recurse | 
    Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-5) } |
    ForEach-Object {
        $rel = $_.FullName.Replace((Get-Location).Path + "\", "")
        Write-Host "  $rel" -ForegroundColor Gray
    }

Write-Host "`nFertig!" -ForegroundColor Green
