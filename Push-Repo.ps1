$commitMsg = Read-Host -Prompt "Enter commit message"

$PSProfilePathSource = (Split-Path -Path $profile -Parent) + "\profile.ps1"
$PSProfilePathDestination =  "$PSScriptRoot\profile.ps1"

Copy-Item -Path $PSProfilePathSource -Destination $PSProfilePathDestination -Verbose
Start-Sleep -Seconds 3

if (Test-Path -Path $PSProfilePathDestination) {
    Write-Host "Powershell profile copied into repo successfully`n" -ForegroundColor Green
} else {
    throw "Error: Powershell profile was not found in the repo: exiting"
}

git add --all
git commit -m $commitMsg
git push

Start-Sleep -Seconds 3
Remove-Item -Path $PSProfilePathDestination -Verbose

if (Test-Path -Path $PSProfilePathDestination) {
    throw "Error: Powershell profile was not removed from the repo: please remove it manually"
} else {
    Write-Host `n"Powershell profile copy was removed from the repo successfully" -ForegroundColor Green
}
