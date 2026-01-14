Write-Host "=== TOOL MANUTENZIONE E DIAGNOSTICA WINDOWS ===" -ForegroundColor Cyan
Write-Host ""

# --- INFO SISTEMA ---
Write-Host "[1] Informazioni sistema" -ForegroundColor Yellow
Get-ComputerInfo | Select-Object OSName, OSVersion, WindowsProductName, CsSystemFamily, CsTotalPhysicalMemory

# --- DATA E ORA ---
Write-Host "`n[2] Data e ora sistema" -ForegroundColor Yellow
Get-Date

# --- STATO INTERNET ---
Write-Host "`n[3] Verifica connessione Internet" -ForegroundColor Yellow
if (Test-Connection -ComputerName 8.8.8.8 -Quiet -Count 1) {
    Write-Host "Internet OK" -ForegroundColor Green
} else {
    Write-Host "Internet NON disponibile" -ForegroundColor Red
}

# --- IP ---
Write-Host "`n[4] Indirizzi IP" -ForegroundColor Yellow
Get-NetIPAddress -AddressFamily IPv4 | Select-Object IPAddress, InterfaceAlias

# --- DISCO ---
Write-Host "`n[5] Spazio libero dischi" -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name="Free(GB)";Expression={[math]::Round($_.Free/1GB,2)}}, @{Name="Used(GB)";Expression={[math]::Round(($_.Used/1GB),2)}}

# --- UTILIZZO CPU ---
Write-Host "`n[6] Utilizzo CPU attuale" -ForegroundColor Yellow
Get-CimInstance Win32_Processor | Select-Object LoadPercentage

# --- MEMORIA RAM ---
Write-Host "`n[7] Stato memoria RAM" -ForegroundColor Yellow
Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="RAM Libera(GB)";Expression={[math]::Round($_.FreePhysicalMemory/1MB,2)}}, @{Name="RAM Totale(GB)";Expression={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}}

# --- PROCESSI PESANTI ---
Write-Host "`n[8] Processi che consumano CPU" -ForegroundColor Yellow
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 ProcessName, CPU

# --- SERVIZI BLOCCATI ---
Write-Host "`n[9] Servizi non in esecuzione" -ForegroundColor Yellow
Get-Service | Where-Object {$_.Status -ne "Running"} | Select-Object DisplayName, Status

# --- PULIZIA FILE TEMP ---
Write-Host "`n[10] Pulizia file temporanei" -ForegroundColor Yellow
$Temp = $env:TEMP
Get-ChildItem $Temp -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "File temporanei eliminati" -ForegroundColor Green

# --- CACHE PREFETCH ---
Write-Host "`n[11] Pulizia cache prefetch" -ForegroundColor Yellow
Remove-Item "C:\Windows\Prefetch\*" -Force -ErrorAction SilentlyContinue
Write-Host "Cache Prefetch pulita" -ForegroundColor Green

# --- SVUOTA CESTINO ---
Write-Host "`n[12] Svuotamento cestino" -ForegroundColor Yellow
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "Cestino svuotato" -ForegroundColor Green

# --- VERIFICA DISCO ---
Write-Host "`n[13] Controllo integrità disco" -ForegroundColor Yellow
Write-Host "Nota: verrà programmato CHKDSK al riavvio"
cmd /c "chkdsk C: /F /R"

# --- SFC ---
Write-Host "`n[14] Controllo file di sistema (SFC)" -ForegroundColor Yellow
sfc /scannow

Write-Host "`n=== OPERAZIONI COMPLETATE ===" -ForegroundColor Magenta
