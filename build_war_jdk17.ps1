<#
  build_war_jdk17.ps1
  Baut das Backend-WAR garantiert mit Java 17, unabhängig davon was im System-PATH/JAVA_HOME steht.

  Nutzung (PowerShell):
    .\build_war_jdk17.ps1
    .\build_war_jdk17.ps1 -SkipTests
    .\build_war_jdk17.ps1 -JavaHome "C:\Program Files\RedHat\java-17-openjdk-17.0.9.0.9-1"

  Ergebnis:
    - erzeugt mainlogik, backend\target\wissentest.war
    - kopiert zusätzlich nach deploy\wissentest_JDK17_<timestamp>.war
    - prüft, dass alle Klassen unter WEB-INF/classes maximal Classfile-Version 61 (Java 17) haben
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $false)]
  [string]$JavaHome,

  [Parameter(Mandatory = $false)]
  [switch]$SkipTests
)

$ErrorActionPreference = 'Stop'

function Invoke-NativeCommand {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string]$Exe,
    [Parameter(Mandatory = $false)]
    [string[]]$Args = @()
  )

  # In Windows PowerShell 5.1, native tools that write to stderr can create error records.
  # We don't want to abort on stderr; we want to abort only on non-zero exit code.
  $old = $ErrorActionPreference
  $ErrorActionPreference = 'Continue'
  try {
    & $Exe @Args
    $exitCode = $LASTEXITCODE
  } finally {
    $ErrorActionPreference = $old
  }

  if ($exitCode -ne 0) {
    $argsText = ($Args -join ' ')
    throw "Command failed (exit $exitCode): $Exe $argsText"
  }
}

function Find-Jdk17Home {
  $candidates = @(
      (Join-Path $PSScriptRoot 'startup\tools\jdk-17*'),
    'C:\Program Files\RedHat\java-17-openjdk*',
    'C:\Program Files\Java\jdk-17*',
    'C:\Program Files\Eclipse Adoptium\jdk-17*',
    'C:\Program Files\Adoptium\jdk-17*',
    'C:\Program Files\BellSoft\LibericaJDK-17*'
  )

  foreach ($pattern in $candidates) {
    $dirs = Get-ChildItem -Path $pattern -Directory -ErrorAction SilentlyContinue
    foreach ($d in ($dirs | Sort-Object FullName -Descending)) {
      $javaExe = Join-Path $d.FullName 'bin\java.exe'
      if (Test-Path $javaExe) {
        return $d.FullName
      }
    }
  }

  return $null
}

function Get-ClassMajorVersion([byte[]]$bytes) {
  # Classfile header: CAFEBABE, minor(2), major(2)
  if ($bytes.Length -lt 8) { return $null }
  if ($bytes[0] -ne 0xCA -or $bytes[1] -ne 0xFE -or $bytes[2] -ne 0xBA -or $bytes[3] -ne 0xBE) { return $null }
  return [int]([BitConverter]::ToUInt16(@($bytes[7], $bytes[6]), 0))
}

function Assert-WarClassesAreJava17OrLower([string]$warPath) {
  Add-Type -AssemblyName System.IO.Compression.FileSystem

  $zip = [IO.Compression.ZipFile]::OpenRead($warPath)
  try {
     $classEntries = $zip.Entries | Where-Object { $_.FullName -like 'WEB-INF/classes/*.class' -or ($_.FullName -like 'WEB-INF/classes/*' -and $_.FullName.EndsWith('.class')) }

    $bad = New-Object System.Collections.Generic.List[string]
    $count = 0

    foreach ($e in $classEntries) {
      $ms = New-Object System.IO.MemoryStream
      try {
        $e.Open().CopyTo($ms)
        $bytes = $ms.ToArray()
        $major = Get-ClassMajorVersion -bytes $bytes
        if ($major -eq $null) {
          $bad.Add("${($e.FullName)} -> unknown class header")
        } elseif ($major -gt 61) {
          $bad.Add("${($e.FullName)} -> major ${major}")
        }
        $count++
      } finally {
        $ms.Dispose()
      }
    }

    Write-Host "Checked $count .class files in WEB-INF/classes (max major=61 expected)."

    if ($bad.Count -gt 0) {
      $preview = $bad | Select-Object -First 25
      throw ("WAR contains classes compiled for a newer Java than 17 (major>61). Examples:`n" + ($preview -join "`n"))
    }
  } finally {
    $zip.Dispose()
  }
}

$repoRoot = Split-Path -Parent $PSCommandPath
$backendPom = Join-Path $repoRoot 'mainlogik, backend\pom.xml'
$targetWar = Join-Path $repoRoot 'mainlogik, backend\target\wissentest.war'
$deployDir = Join-Path $repoRoot 'deploy'
$bundledMvn = Join-Path $repoRoot 'startup\tools\apache-maven-3.9.6\bin\mvn.cmd'

if (!(Test-Path $backendPom)) {
  throw "Cannot find backend pom.xml at: $backendPom"
}

if ([string]::IsNullOrWhiteSpace($JavaHome)) {
  $JavaHome = Find-Jdk17Home
}

if ([string]::IsNullOrWhiteSpace($JavaHome)) {
  throw "No JDK 17 found. Install JDK 17 and re-run, or pass -JavaHome <path>."
}

$javaExe = Join-Path $JavaHome 'bin\java.exe'
if (!(Test-Path $javaExe)) {
  throw "Invalid -JavaHome. java.exe not found at: $javaExe"
}

# Force this PowerShell session (and the Maven build) to use Java 17
$env:JAVA_HOME = $JavaHome
$env:Path = (Join-Path $JavaHome 'bin') + ';' + $env:Path

Write-Host "JAVA_HOME=$env:JAVA_HOME"
Write-Host "java -version:" 
Invoke-NativeCommand -Exe $javaExe -Args @('-version')

# Build
$skipTestsArg = $null
if ($SkipTests.IsPresent) {
  $skipTestsArg = '-DskipTests'
}

Push-Location $repoRoot
try {
  Write-Host "Building WAR via Maven..."
  $mvnExe = 'mvn'
  if (Test-Path $bundledMvn) {
    $mvnExe = $bundledMvn
  }
  if ($skipTestsArg) {
    Invoke-NativeCommand -Exe $mvnExe -Args @('-f', $backendPom, 'clean', 'package', $skipTestsArg)
  } else {
    Invoke-NativeCommand -Exe $mvnExe -Args @('-f', $backendPom, 'clean', 'package')
  }
} finally {
  Pop-Location
}

if (!(Test-Path $targetWar)) {
  throw "Build finished but WAR not found at: $targetWar"
}

# Verify bytecode levels
Assert-WarClassesAreJava17OrLower -warPath $targetWar

# Copy to deploy folder with timestamp
if (!(Test-Path $deployDir)) {
  New-Item -ItemType Directory -Path $deployDir | Out-Null
}

$ts = Get-Date -Format 'yyyy-MM-dd_HHmm'
$deployWar = Join-Path $deployDir "wissentest_JDK17_${ts}.war"
Copy-Item -LiteralPath $targetWar -Destination $deployWar -Force

Write-Host "OK: Built and verified Java 17 WAR."
Write-Host " - $targetWar"
Write-Host " - $deployWar"
