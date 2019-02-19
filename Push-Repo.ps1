$commitMsg = Read-Host -Prompt "Enter commit message"

$PSProfilePathSource = (Split-Path -Path $profile -Parent) + "\profile.ps1"
$PSProfilePathDestination = (Split-Path -Path $PSScriptRoot -Parent) + "\profile.ps1"

Copy-Item -Path $PSProfilePathSource -Destination $PSProfilePathDestination -Verbose

if (Test-Path -Path $PSProfilePathDestination) {
    Write-Host "Powershell profile copied into repo successfully"
} else {
    throw "Error: Powershell profile was not found in the repo: exiting"
}

git add --all
git commit -m $commitMsg
git push

Remove-Item -Path $PSProfilePathDestination -Verbose

if (Test-Path -Path $PSProfilePathDestination) {
    throw "Error: Powershell profile was not removed from the repo: please remove it manually"
} else {
    Write-Host "Powershell profile copy was removed from the repo successfully"
}
