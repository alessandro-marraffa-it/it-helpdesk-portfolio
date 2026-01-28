Write-Host "NETWORK CHECK STATUS" -ForegroundColor Cyan

Write-Host "Configurazione IP:" -ForegroundColor Green
ipconfig

Write-Host "Test gateway:" -ForegroundColor Green
$gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0").NextHop
ping $gateway -n 2

Write-Host "Test Internet:" -ForegroundColor Green
ping 8.8.8.8 -n 2

Write-Host "Test DNS:" -ForegroundColor Green
nslookup google.com

Write-Host "Controllo completato." -ForegroundColor Green
