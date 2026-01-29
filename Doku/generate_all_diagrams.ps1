# PlantUML Diagramm-Generator mit Verifikation
# Generiert SVG und PNG Dateien aus allen .puml Dateien
# Inklusive automatischem PlantUML-Download

[CmdletBinding()]
param(
    # File or directory to render. Relative paths are resolved against this script folder.
    [string]$InputPath = "Diagramme - Kopie",

    # Which formats to generate.
    [ValidateSet("both", "svg", "png", "pdf")]
    [string]$Format = "both",

    # Also render root-level PlantUML_Deployment*.puml files (repo root) into Diagramme - Kopie\Deployment-Diagramm
    [switch]$IncludeRootDeployment,

    # Delete existing .svg/.png outputs for the selected diagrams before rendering.
    [switch]$CleanOutputs
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ScriptDir

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  PlantUML Diagramm-Generator" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# PlantUML JAR Pfad
$PlantUMLJar = Join-Path $ScriptDir "plantuml.jar"

# Repo root (one level above Doku)
$RepoRoot = Split-Path -Parent $ScriptDir

# 1. PlantUML herunterladen falls nicht vorhanden
if (-not (Test-Path $PlantUMLJar)) {
    Write-Host "[1/4] PlantUML JAR wird heruntergeladen..." -ForegroundColor Yellow
    $downloadUrl = "https://github.com/plantuml/plantuml/releases/download/v1.2024.7/plantuml-1.2024.7.jar"
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $downloadUrl -OutFile $PlantUMLJar -UseBasicParsing
        $ProgressPreference = 'Continue'
        Write-Host "   PlantUML erfolgreich heruntergeladen!" -ForegroundColor Green
    } catch {
        Write-Host "   FEHLER beim Download: $_" -ForegroundColor Red
        Write-Host "`n   Bitte manuell herunterladen:" -ForegroundColor Yellow
        Write-Host "   $downloadUrl" -ForegroundColor Cyan
        Write-Host "   und als 'plantuml.jar' in diesem Ordner speichern.`n"
        exit 1
    }
} else {
    Write-Host "[1/4] PlantUML JAR vorhanden: $PlantUMLJar" -ForegroundColor Green
}

# 2. Java prüfen
Write-Host "[2/4] Java-Installation prüfen..." -ForegroundColor Yellow

$JAVA_EXE = "java"
if ($env:JAVA_HOME -and (Test-Path "$env:JAVA_HOME\bin\java.exe")) {
    $JAVA_EXE = "$env:JAVA_HOME\bin\java.exe"
}
Write-Host "   DEBUG: JAVA_EXE set to: '$JAVA_EXE'" -ForegroundColor Gray

$ErrorActionPreference = "Continue"
$javaResult = & $JAVA_EXE -version 2>&1 
$ErrorActionPreference = "Stop"

if ($javaResult) {
    $verStr = $javaResult | Select-Object -First 1
    Write-Host "   Java gefunden: $verStr" -ForegroundColor Green
    Write-Host "   Nutze Java: $JAVA_EXE" -ForegroundColor Gray
} else {
    Write-Host "   FEHLER: Java Konnte nicht ausgeführt werden." -ForegroundColor Red
    Write-Host "   Bitte Java installieren: https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# 3. Input-Pfad auflösen
$DiagramDir = Join-Path $ScriptDir "Diagramme - Kopie"
if (-not (Test-Path $DiagramDir)) {
    Write-Host "   FEHLER: Diagramm-Verzeichnis nicht gefunden: $DiagramDir" -ForegroundColor Red
    exit 1
}

$ResolvedInputPath = $InputPath
if (-not [System.IO.Path]::IsPathRooted($ResolvedInputPath)) {
    $ResolvedInputPath = Join-Path $ScriptDir $ResolvedInputPath
}

if (-not (Test-Path $ResolvedInputPath)) {
    Write-Host "   FEHLER: InputPath nicht gefunden: $ResolvedInputPath" -ForegroundColor Red
    Write-Host "   Tipp: Nutze z.B. -InputPath 'Diagramme - Kopie' oder einen konkreten .puml Pfad." -ForegroundColor Yellow
    exit 1
}

# 4. PUML-Dateien finden und verarbeiten
Write-Host "[3/4] Suche nach .puml Dateien..." -ForegroundColor Yellow

$pumlFiles = @()
$inputItem = Get-Item -LiteralPath $ResolvedInputPath
if ($inputItem.PSIsContainer) {
    $pumlFiles += Get-ChildItem -Path $inputItem.FullName -Filter "*.puml" -Recurse
} else {
    if ($inputItem.Extension -ne ".puml") {
        Write-Host "   FEHLER: InputPath ist keine .puml Datei: $($inputItem.FullName)" -ForegroundColor Red
        exit 1
    }
    $pumlFiles += $inputItem
}

if ($IncludeRootDeployment) {
    $deploy = Get-ChildItem -Path $RepoRoot -Filter "PlantUML_Deployment*.puml" -File -ErrorAction SilentlyContinue
    if ($deploy) {
        $pumlFiles += $deploy
    }
}

$pumlFiles = $pumlFiles | Sort-Object FullName -Unique
Write-Host "   Gefunden: $($pumlFiles.Count) Dateien`n" -ForegroundColor Green

$successCount = 0
$errorCount = 0
$generatedFiles = @()

Write-Host "[4/4] Generiere Diagramme...`n" -ForegroundColor Yellow

function Invoke-PlantUmlPipeToFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$PlantUmlArgs,

        [Parameter(Mandatory=$true)]
        [string]$InputText,

        [Parameter(Mandatory=$true)]
        [string]$OutFile
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $JAVA_EXE
    $psi.Arguments = "-jar `"$PlantUMLJar`" $PlantUmlArgs -pipe"
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true

    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $psi

    $null = $p.Start()

    # Write PUML to stdin as UTF-8 (no BOM)
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $sw = New-Object System.IO.StreamWriter($p.StandardInput.BaseStream, $utf8NoBom)
    $sw.Write($InputText)
    $sw.Flush()
    $sw.Close()

    # Read stderr concurrently to avoid blocking on large error output
    $stderrTask = $p.StandardError.ReadToEndAsync()

    # Stream stdout bytes directly to output file (IMPORTANT for PNG)
    $outDir = Split-Path -Parent $OutFile
    if ($outDir -and -not (Test-Path $outDir)) {
        New-Item -ItemType Directory -Path $outDir | Out-Null
    }

    $fs = [System.IO.File]::Open($OutFile, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
    try {
        $p.StandardOutput.BaseStream.CopyTo($fs)
    } finally {
        $fs.Dispose()
    }

    $p.WaitForExit()
    $stderr = $stderrTask.Result

    return [PSCustomObject]@{
        ExitCode = $p.ExitCode
        StdErr   = $stderr
    }
}

function Test-PngSignature {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) { return $false }
    $fs = [System.IO.File]::OpenRead($Path)
    try {
        $sig = New-Object byte[] 8
        if ($fs.Read($sig, 0, 8) -ne 8) { return $false }
        # 89 50 4E 47 0D 0A 1A 0A
        return ($sig[0] -eq 137 -and $sig[1] -eq 80 -and $sig[2] -eq 78 -and $sig[3] -eq 71 -and $sig[4] -eq 13 -and $sig[5] -eq 10 -and $sig[6] -eq 26 -and $sig[7] -eq 10)
    } finally {
        $fs.Dispose()
    }
}

function Test-PdfSignature {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) { return $false }
    $fs = [System.IO.File]::OpenRead($Path)
    try {
        $sig = New-Object byte[] 4
        if ($fs.Read($sig, 0, 4) -ne 4) { return $false }
        # %PDF
        return ($sig[0] -eq 0x25 -and $sig[1] -eq 0x50 -and $sig[2] -eq 0x44 -and $sig[3] -eq 0x46)
    } finally {
        $fs.Dispose()
    }
}

function Get-TextFileContentAutoEncoding {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    $bytes = [System.IO.File]::ReadAllBytes($Path)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        # UTF-8 BOM
        return ([System.Text.Encoding]::UTF8.GetString($bytes, 3, $bytes.Length - 3))
    }
    if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
        # UTF-16 LE BOM
        return ([System.Text.Encoding]::Unicode.GetString($bytes, 2, $bytes.Length - 2))
    }
    if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) {
        # UTF-16 BE BOM
        return ([System.Text.Encoding]::BigEndianUnicode.GetString($bytes, 2, $bytes.Length - 2))
    }

    # No BOM: try UTF-8 (most editors save PlantUML as UTF-8; avoids Ã¶/Ã¼ issues).
    # If the file is actually ANSI/Windows-1252, strict UTF-8 will throw and we fall back.
    try {
        $utf8Strict = New-Object System.Text.UTF8Encoding($false, $true)
        return $utf8Strict.GetString($bytes)
    } catch {
        # Fallback for legacy Windows-encoded files
        $win1252 = [System.Text.Encoding]::GetEncoding(1252)
        return $win1252.GetString($bytes)
    }
}

foreach ($pumlFile in $pumlFiles) {
    $relativePath = $pumlFile.FullName.Replace($ScriptDir + "\", "")
    $outputDir = $pumlFile.DirectoryName
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($pumlFile.Name)

    # If deployment diagrams are rendered from repo root, keep outputs inside Diagramme - Kopie to avoid cluttering the repo root.
    if ($IncludeRootDeployment -and -not ($pumlFile.FullName.StartsWith($DiagramDir, [System.StringComparison]::OrdinalIgnoreCase))) {
        $outputDir = Join-Path $DiagramDir "Deployment-Diagramm"
        if (-not (Test-Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir | Out-Null
        }
    }
    
    Write-Host "   $relativePath" -ForegroundColor White
    
    try {
        if ($CleanOutputs) {
            $maybeSvg = Join-Path $outputDir "$baseName.svg"
            $maybePng = Join-Path $outputDir "$baseName.png"
            if (Test-Path $maybeSvg) { Remove-Item -Force -ErrorAction SilentlyContinue $maybeSvg }
            if (Test-Path $maybePng) { Remove-Item -Force -ErrorAction SilentlyContinue $maybePng }
        }

        # SVG generieren
        # Use piping to ensure the output filename is exactly what we expect, ignoring internal @startuml names
        # IMPORTANT: read PUML as bytes with BOM-aware decoding (PowerShell default encoding can corrupt umlauts)
        $pumlContent = Get-TextFileContentAutoEncoding -Path $pumlFile.FullName

        if ($Format -eq "both" -or $Format -eq "svg") {
            Write-Host "      -> SVG..." -NoNewline -ForegroundColor Gray
            $svgFile = Join-Path $outputDir "$baseName.svg"
            $svgResult = Invoke-PlantUmlPipeToFile -PlantUmlArgs "-tsvg -charset UTF-8" -InputText $pumlContent -OutFile $svgFile
            $svgLooksOk = $false
            if ((Test-Path $svgFile) -and (Get-Item $svgFile).Length -gt 0) {
                $head = (Get-Content -Path $svgFile -TotalCount 15 | Out-String)
                if ($head -match "<svg") { $svgLooksOk = $true }
            }
            if ($svgResult.ExitCode -eq 0 -and $svgLooksOk) {
                Write-Host " OK" -ForegroundColor Green
                $generatedFiles += $svgFile
            } else {
                Write-Host " FEHLER" -ForegroundColor Red
                if ($svgResult.StdErr) {
                    $errPreview = ($svgResult.StdErr -split "`r?`n" | Select-Object -First 5) -join " | "
                    Write-Host "         $errPreview" -ForegroundColor Red
                } elseif (Test-Path $svgFile) {
                    Write-Host "         (Size: $((Get-Item $svgFile).Length))" -ForegroundColor Red
                }
                $errorCount++
                continue
            }
        }
        
        # PNG generieren
        if ($Format -eq "both" -or $Format -eq "png") {
            Write-Host "      -> PNG..." -NoNewline -ForegroundColor Gray
            $pngFile = Join-Path $outputDir "$baseName.png"
            $pngResult = Invoke-PlantUmlPipeToFile -PlantUmlArgs "-tpng -charset UTF-8" -InputText $pumlContent -OutFile $pngFile
            if ($pngResult.ExitCode -eq 0 -and (Test-Path $pngFile) -and (Get-Item $pngFile).Length -gt 0 -and (Test-PngSignature -Path $pngFile)) {
                Write-Host " OK" -ForegroundColor Green
                $generatedFiles += $pngFile
            } else {
                Write-Host " FEHLER" -ForegroundColor Red
                if ($pngResult.StdErr) {
                    $errPreview = ($pngResult.StdErr -split "`r?`n" | Select-Object -First 5) -join " | "
                    Write-Host "         $errPreview" -ForegroundColor Red
                } elseif (Test-Path $pngFile) {
                    Write-Host "         (Size: $((Get-Item $pngFile).Length))" -ForegroundColor Red
                    if (-not (Test-PngSignature -Path $pngFile)) {
                        Write-Host "         (PNG signature check failed - likely corrupted output)" -ForegroundColor Red
                    }
                }
                $errorCount++
                continue
            }
        }

        # PDF generieren (optional, ideal zum Drucken)
        if ($Format -eq "pdf") {
            Write-Host "      -> PDF..." -NoNewline -ForegroundColor Gray
            $pdfFile = Join-Path $outputDir "$baseName.pdf"
            $pdfResult = Invoke-PlantUmlPipeToFile -PlantUmlArgs "-tpdf -charset UTF-8" -InputText $pumlContent -OutFile $pdfFile
            if ($pdfResult.ExitCode -eq 0 -and (Test-Path $pdfFile) -and (Get-Item $pdfFile).Length -gt 0 -and (Test-PdfSignature -Path $pdfFile)) {
                Write-Host " OK" -ForegroundColor Green
                $generatedFiles += $pdfFile
            } else {
                Write-Host " FEHLER" -ForegroundColor Red
                if ($pdfResult.StdErr) {
                    $errPreview = ($pdfResult.StdErr -split "`r?`n" | Select-Object -First 5) -join " | "
                    Write-Host "         $errPreview" -ForegroundColor Red
                } elseif (Test-Path $pdfFile) {
                    Write-Host "         (Size: $((Get-Item $pdfFile).Length))" -ForegroundColor Red
                    if (-not (Test-PdfSignature -Path $pdfFile)) {
                        Write-Host "         (PDF signature check failed - likely corrupted output)" -ForegroundColor Red
                    }
                }
                $errorCount++
                continue
            }
        }
        
        $successCount++
    } catch {
        Write-Host "      FEHLER: $_" -ForegroundColor Red
        $errorCount++
    }
}

# Zusammenfassung
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Zusammenfassung" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Erfolgreich: $successCount von $($pumlFiles.Count)" -ForegroundColor $(if ($successCount -eq $pumlFiles.Count) { "Green" } else { "Yellow" })
if ($errorCount -gt 0) {
    Write-Host "  Fehler:      $errorCount" -ForegroundColor Red
}

Write-Host "`n  Generierte Dateien:" -ForegroundColor Yellow
foreach ($file in $generatedFiles) {
    $rel = $file.Replace($ScriptDir + "\", "")
    Write-Host "    - $rel" -ForegroundColor Gray
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Fertig!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan
