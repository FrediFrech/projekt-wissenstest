[CmdletBinding()]
param(
    [string]$RepoRoot = "c:\Users\Micro\Projekt Wissenstest\projekt-wissenstest"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$doku = Join-Path $RepoRoot "Doku"

# Where we expect outputs to live
$scanRoots = @(
    (Join-Path $doku "Diagramme - Kopie"),
    (Join-Path $doku "Diagramme")
) | Where-Object { Test-Path $_ }

# Also scan root-level PlantUML deployment exports if present
$rootExports = @(
    Get-ChildItem -Path $RepoRoot -Filter "PlantUML_Deployment*.png" -File -ErrorAction SilentlyContinue
    Get-ChildItem -Path $RepoRoot -Filter "PlantUML_Deployment*.svg" -File -ErrorAction SilentlyContinue
)

Add-Type -AssemblyName System.Drawing
$replacementChar = [char]0xFFFD

$issues = New-Object System.Collections.Generic.List[string]

function Add-Issue([string]$msg) {
    $issues.Add($msg)
}

# Collect outputs
$pngs = @()
$svgs = @()
foreach ($r in $scanRoots) {
    $pngs += Get-ChildItem -Path $r -Recurse -Filter "*.png" -File -ErrorAction SilentlyContinue
    $svgs += Get-ChildItem -Path $r -Recurse -Filter "*.svg" -File -ErrorAction SilentlyContinue
}
$pngs += $rootExports | Where-Object { $_ -and $_.Extension -ieq ".png" }
$svgs += $rootExports | Where-Object { $_ -and $_.Extension -ieq ".svg" }

$pngs = $pngs | Sort-Object FullName -Unique
$svgs = $svgs | Sort-Object FullName -Unique

# PNG validity check
foreach ($f in $pngs) {
    try {
        $img = [System.Drawing.Image]::FromFile($f.FullName)
        try {
            $w = $img.Width
            $h = $img.Height
        } finally {
            $img.Dispose()
        }

        if ($w -lt 50 -or $h -lt 50) {
            Add-Issue ("PNG suspicious size {0}x{1}: {2}" -f $w, $h, $f.FullName)
        }
    } catch {
        Add-Issue ("PNG open failed: {0} :: {1}" -f $f.FullName, $_.Exception.Message)
    }
}

# SVG sanity / encoding checks
foreach ($f in $svgs) {
    try {
        $head = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction Stop
        $sample = if ($head.Length -gt 4000) { $head.Substring(0, 4000) } else { $head }

        if ($sample -notmatch "<svg") {
            Add-Issue ("SVG missing '<svg>': {0}" -f $f.FullName)
        }

        if ($sample.Contains("Ã")) {
            Add-Issue ("SVG contains mojibake 'Ã': {0}" -f $f.FullName)
        }

        if ($sample.Contains($replacementChar) -or $sample.Contains("&#65533;")) {
            Add-Issue ("SVG contains replacement character (\uFFFD): {0}" -f $f.FullName)
        }

        # Avoid false positives (many diagrams legitimately contain words like "error" or "ErrorResponse").
        # Only flag typical PlantUML render error markers.
        $hit = Select-String -LiteralPath $f.FullName -SimpleMatch -Pattern "Syntax Error" -ErrorAction SilentlyContinue
        if ($hit) {
            Add-Issue ("SVG contains error text: {0}" -f $f.FullName)
        }
    } catch {
        Add-Issue ("SVG read failed: {0} :: {1}" -f $f.FullName, $_.Exception.Message)
    }
}

Write-Host ("Checked PNG: {0} | SVG: {1}" -f $pngs.Count, $svgs.Count)

if ($issues.Count -gt 0) {
    Write-Host "ISSUES:" -ForegroundColor Red
    $issues | Sort-Object -Unique | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
    exit 2
}

Write-Host "No issues detected (binary validity / obvious encoding markers / error renders)." -ForegroundColor Green
exit 0
