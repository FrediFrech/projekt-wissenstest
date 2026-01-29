[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$RepoRoot = "c:\Users\Micro\Projekt Wissenstest\projekt-wissenstest"
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$doku = Join-Path $RepoRoot "Doku"

$targets = @(
    (Join-Path $doku "Diagramme"),
    (Join-Path $doku "Diagramme - Kopie\Deployment"),
    (Join-Path $RepoRoot "PlantUML_Deployment_Diagram.svg")
)

foreach ($t in $targets) {
    if (-not (Test-Path $t)) {
        Write-Host "Skip (not found): $t" -ForegroundColor DarkGray
        continue
    }

    if ((Get-Item -LiteralPath $t).PSIsContainer) {
        $count = (Get-ChildItem -Path $t -Recurse -File -ErrorAction SilentlyContinue | Measure-Object).Count
        Write-Host ("Remove folder: {0} ({1} files)" -f $t, $count) -ForegroundColor Yellow
        if ($PSCmdlet.ShouldProcess($t, "Remove-Item -Recurse -Force")) {
            Remove-Item -LiteralPath $t -Recurse -Force
        }
    } else {
        Write-Host "Remove file: $t" -ForegroundColor Yellow
        if ($PSCmdlet.ShouldProcess($t, "Remove-Item -Force")) {
            Remove-Item -LiteralPath $t -Force
        }
    }
}

Write-Host "Done." -ForegroundColor Green
