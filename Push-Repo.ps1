$commitMsg = Read-Host -Prompt "Enter commit message: "

$PSProfilePath = (Split-Path -Path $profile -Parent) + "\profile.ps1"
$Destination = (Split-Path -Path $PSScriptRoot -Parent)

Copy-Item -Path $PSProfilePath -Destination $Destination

git add --all
git commit -m $commitMsg
git push

Remove-Item -Path "$Destination\profile.ps1" -WhatIf
