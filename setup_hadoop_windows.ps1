# ========================================
# Windows Hadoop Setup für PySpark
# ========================================
# Dieses Skript richtet winutils.exe für PySpark auf Windows ein
# Führe es als Administrator aus!

$ErrorActionPreference = "Stop"

Write-Host "=== Windows Hadoop Setup für PySpark ===" -ForegroundColor Cyan
Write-Host ""

# Schritt 1: Hadoop-Verzeichnis erstellen
$HADOOP_HOME = "C:\hadoop"
$HADOOP_BIN = "${HADOOP_HOME}\bin"

Write-Host "[1/3] Erstelle Verzeichnis: $HADOOP_BIN" -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $HADOOP_BIN | Out-Null

# Schritt 2: winutils.exe herunterladen (Hadoop 3.3.1 - kompatibel mit Spark 3.x)
$WINUTILS_URL = "https://github.com/cdarlint/winutils/raw/master/hadoop-3.3.1/bin/winutils.exe"
$WINUTILS_PATH = "${HADOOP_BIN}\winutils.exe"

Write-Host "[2/3] Lade winutils.exe herunter..." -ForegroundColor Yellow
Write-Host "      von: $WINUTILS_URL" -ForegroundColor Gray

try {
    # Invoke-WebRequest kann in manchen PowerShell-Umgebungen nicht verfügbar sein; versuche es trotzdem
    Invoke-WebRequest -Uri $WINUTILS_URL -OutFile $WINUTILS_PATH -UseBasicParsing -ErrorAction Stop
    Write-Host "      ✓ Erfolgreich heruntergeladen" -ForegroundColor Green
} catch {
    Write-Host "      ✗ Fehler beim Download: $_" -ForegroundColor Red
    Write-Host "      Bitte lade winutils.exe manuell herunter und platziere es unter:" -ForegroundColor Yellow
    Write-Host "      $WINUTILS_PATH" -ForegroundColor Yellow
    # continue without exiting so that user can set env manually
}

# Schritt 3: Umgebungsvariable setzen
Write-Host "[3/3] Setze HADOOP_HOME Umgebungsvariable..." -ForegroundColor Yellow

# System-weite Umgebungsvariable (erfordert Admin-Rechte)
try {
    [Environment]::SetEnvironmentVariable('HADOOP_HOME', $HADOOP_HOME, 'Machine')
    Write-Host "      ✓ HADOOP_HOME = $HADOOP_HOME (System)" -ForegroundColor Green
} catch {
    Write-Host "      ✗ Fehler beim Setzen der System-Variable (Admin-Rechte erforderlich)" -ForegroundColor Red
    Write-Host "      Setze stattdessen für aktuellen User..." -ForegroundColor Yellow
    [Environment]::SetEnvironmentVariable('HADOOP_HOME', $HADOOP_HOME, 'User')
    Write-Host "      ✓ HADOOP_HOME = $HADOOP_HOME (User)" -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Setup abgeschlossen! ===" -ForegroundColor Green
Write-Host ""
Write-Host "WICHTIG: Starte PyCharm/Jupyter KOMPLETT neu, damit die Änderungen wirksam werden!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Überprüfung:" -ForegroundColor Cyan
Write-Host "  - winutils.exe: $WINUTILS_PATH"
Write-Host "  - Existiert: $(Test-Path $WINUTILS_PATH)"
Write-Host "  - HADOOP_HOME: $HADOOP_HOME"
Write-Host ""
