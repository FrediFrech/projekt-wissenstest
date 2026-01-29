# PowerShell Script zum Download von PlantUML JAR
# Führe dieses Script aus, um plantuml.jar herunterzuladen

$url = "https://github.com/plantuml/plantuml/releases/download/v1.2024.7/plantuml-1.2024.7.jar"
$output = "$PSScriptRoot\plantuml.jar"

Write-Host "Downloading PlantUML from $url..."
Write-Host "Target: $output"

try {
    # Verwende Invoke-WebRequest für den Download
    Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing
    
    if (Test-Path $output) {
        $size = (Get-Item $output).Length / 1MB
        Write-Host "Download erfolgreich! Dateigröße: $([math]::Round($size, 2)) MB" -ForegroundColor Green
    }
} catch {
    Write-Host "Fehler beim Download: $_" -ForegroundColor Red
    
    # Alternative mit System.Net.WebClient
    Write-Host "Versuche alternativen Download..." -ForegroundColor Yellow
    try {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($url, $output)
        Write-Host "Alternativer Download erfolgreich!" -ForegroundColor Green
    } catch {
        Write-Host "Auch alternativer Download fehlgeschlagen: $_" -ForegroundColor Red
    }
}
