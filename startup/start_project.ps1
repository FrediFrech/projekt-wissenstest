# PowerShell Script to setup and start the Wissenstest project
# This script ensures Java, Maven, and Tomcat are available locally (without requiring admin install)
# and then builds and runs the application.

$ErrorActionPreference = "Stop"

$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path -Parent $ScriptDir
$ToolsDir = Join-Path $ScriptDir "tools"

# --- Configurations ---
$JavaUrl = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.10%2B7/OpenJDK17U-jdk_x64_windows_hotspot_17.0.10_7.zip"
$JavaDirName = "jdk-17.0.10+7"

$MavenUrl = "https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip"
$MavenDirName = "apache-maven-3.9.6"

$TomcatUrl = "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.zip"
$TomcatDirName = "apache-tomcat-9.0.85"

$NodeUrl = "https://nodejs.org/dist/v20.11.0/node-v20.11.0-win-x64.zip"
$NodeDirName = "node-v20.11.0-win-x64"

$PgUrl = "https://get.enterprisedb.com/postgresql/postgresql-16.1-1-windows-x64-binaries.zip"
$PgDirName = "pgsql"

# --- Helper Functions ---

function Install-Tool {
    param (
        [string]$Name,
        [string]$Url,
        [string]$TargetDirName,
        [string]$TestPath # Subpath to check if it exists inside ToolsDir
    )

    $ToolPath = Join-Path $ToolsDir $TargetDirName
    $ZipPath = Join-Path $ToolsDir "$Name.zip"

    Write-Host "Checking for $Name..." -ForegroundColor Cyan

    if (!(Test-Path $ToolPath)) {
        Write-Host "$Name not found. Downloading..." -ForegroundColor Yellow
        if (!(Test-Path $ToolsDir)) { New-Item -ItemType Directory -Path $ToolsDir | Out-Null }
        
        try {
            Invoke-WebRequest -Uri $Url -OutFile $ZipPath -UseBasicParsing
        }
        catch {
            Write-Error "Failed to download $Name from $Url. Error: $_"
        }

        Write-Host "Extracting $Name..." -ForegroundColor Yellow
        Expand-Archive -Path $ZipPath -DestinationPath $ToolsDir -Force
        
        # Cleanup Zip
        Remove-Item $ZipPath -Force

        Write-Host "$Name installed to $ToolPath" -ForegroundColor Green
    } else {
        Write-Host "$Name is already installed." -ForegroundColor Green
    }
    
    return $ToolPath
}

# --- Main Execution ---

Write-Host "=== Projekt Wissenstest Startup Script ===" -ForegroundColor Magenta
Write-Host "Repository Root: $RepoRoot"

# 1. Setup Tools
$JavaHome = Install-Tool -Name "Java 17" -Url $JavaUrl -TargetDirName $JavaDirName
$MavenHome = Install-Tool -Name "Maven" -Url $MavenUrl -TargetDirName $MavenDirName
$TomcatHome = Install-Tool -Name "Tomcat 9" -Url $TomcatUrl -TargetDirName $TomcatDirName
$NodeHome = Install-Tool -Name "Node.js" -Url $NodeUrl -TargetDirName $NodeDirName
$PgHome = Install-Tool -Name "PostgreSQL" -Url $PgUrl -TargetDirName $PgDirName

# 2. Configure Environment
Write-Host "Configuring Environment..." -ForegroundColor Cyan
$env:JAVA_HOME = $JavaHome
$env:M2_HOME = $MavenHome
$env:CATALINA_HOME = $TomcatHome
$env:NODE_HOME = $NodeHome
$PgBin = Join-Path $PgHome "bin"

# Add to PATH (temporarily for this process)
$env:PATH = "$JavaHome\bin;$MavenHome\bin;$NodeHome;$PgBin;$env:PATH"

# Verify Versions
java -version
mvn -version
node -version
npm -version
postgres --version

# --- 2.5 Setup Database ---
Write-Host "`n=== Setting up Database ===`n" -ForegroundColor Magenta
$DbDataDir = Join-Path $ScriptDir "db-data"
$DbPort = 5433
$DbUser = "student"
$DbPass = "student"
$DbName = "wissentest"

# Init DB if not exists
if (!(Test-Path $DbDataDir)) {
    Write-Host "Initializing Database at $DbDataDir..." -ForegroundColor Yellow
    # Initialize with default user 'student' and authentication method 'trust' (simple for local dev)
    initdb -D $DbDataDir -U $DbUser --auth=trust -E UTF8 --locale=C
}

# Start Postgres
Write-Host "Starting PostgreSQL on port $DbPort..."
$LogFile = Join-Path $ScriptDir "postgres.log"
# Check if running
if (!(Test-NetConnection -ComputerName localhost -Port $DbPort -InformationLevel Quiet)) {
    pg_ctl -D $DbDataDir -l $LogFile -o "-p $DbPort" start
    
    # Wait for startup
    $Retries = 10
    while (!(Test-NetConnection -ComputerName localhost -Port $DbPort -InformationLevel Quiet) -and $Retries -gt 0) {
        Start-Sleep -Seconds 1
        $Retries--
    }
    
    if ($Retries -eq 0) {
        Write-Error "Failed to start PostgreSQL!"
    }
    
    Write-Host "PostgreSQL started." -ForegroundColor Green
    
    # Create DB and Schema (only if just started/initialized)
    # We check if DB exists
    $DbExists = psql -p $DbPort -U $DbUser -lqt | Select-String $DbName
    if (!$DbExists) {
        Write-Host "Creating Database '$DbName'..."
        createdb -p $DbPort -U $DbUser $DbName
        
        Write-Host "Importing Schema..."
        $SchemaSql = Join-Path $RepoRoot "db\schema.sql"
        $SeedsSql = Join-Path $RepoRoot "db\seeds.sql"
        
        if (Test-Path $SchemaSql) {
            psql -p $DbPort -U $DbUser -d $DbName -f $SchemaSql
        }
        if (Test-Path $SeedsSql) {
            psql -p $DbPort -U $DbUser -d $DbName -f $SeedsSql
        }
    }
} else {
    Write-Host "PostgreSQL is already running on port $DbPort." -ForegroundColor Green
}

# 3. Build Frontend (DISABLED - Using JSP Native)
Write-Host "`n=== Building Frontend (Skipped for Native JSP) ===`n" -ForegroundColor DarkGray
# $FrontendDir = Join-Path $RepoRoot "alte_react_version\frondend"
# ... (React build removed to comply with user request)

# 4. Build Backend
Write-Host "`n=== Building Backend ===`n" -ForegroundColor Magenta
Set-Location -Path (Join-Path $RepoRoot "mainlogik, backend")

# Skip tests for demo mode to allow offline start
mvn clean package "-Dmaven.test.skip=true"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Maven Build Failed!"
}

# 5. Deploy to Tomcat
Write-Host "`n=== Deploying to Tomcat ===`n" -ForegroundColor Magenta
$WarFile = Join-Path (Join-Path $RepoRoot "mainlogik, backend") "target\wissentest.war"
$WebappsDir = Join-Path $TomcatHome "webapps"

if (Test-Path $WarFile) {
    Copy-Item $WarFile -Destination $WebappsDir -Force
    Write-Host "WAR file deployed to $WebappsDir" -ForegroundColor Green
} else {
    Write-Error "WAR file not found at $WarFile"
}

# 6. Start Tomcat
Write-Host "`n=== Starting Tomcat ===`n" -ForegroundColor Magenta
$TomcatBin = Join-Path $TomcatHome "bin"

# Check if port 8080 is in use and kill the process
$Port = 8080
$Processes = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue | 
             Where-Object { $_.State -eq 'Listen' } |
             Select-Object -ExpandProperty OwningProcess -Unique |
             Where-Object { $_ -gt 0 }

if ($Processes) {
    foreach ($ProcId in $Processes) {
        Write-Host "Port $Port is already in use by PID $ProcId. Killing process..." -ForegroundColor Yellow
        Stop-Process -Id $ProcId -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 2
}

$StartupScript = Join-Path $TomcatBin "startup.bat"

Write-Host "Starting Tomcat in a separate window..."
Start-Process -FilePath $StartupScript -WorkingDirectory $TomcatBin

Write-Host "`n=== Setup Complete ===`n" -ForegroundColor Green
Write-Host "The application is starting up."
Write-Host "Access it here: http://localhost:8080/wissentest/"
Write-Host "Demo Login: student / student123"
Write-Host "`nPress any key to close this installer window (Tomcat will keep running)..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
