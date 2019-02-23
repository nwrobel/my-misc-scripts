Write-Host "Syncback scheduled backup `"datastore => dsbak`" is about to be run" -ForegroundColor Yellow
Write-Host 'Please connect USB External HDD (F:\) and press [Enter] continue...' -ForegroundColor Yellow
$input = Read-Host

while (-not (Test-Path -Path 'F:\')) {
    Write-Host 'Wating for USB External HDD (F:\) to be recognized...' -ForegroundColor Cyan
    Start-Sleep -Seconds 1
}


1..3 | ForEach-Object {
    Write-Host "Done! Passing control to Syncback in $(4 - $_)s..." -ForegroundColor Cyan
    Start-Sleep -Seconds 1
}