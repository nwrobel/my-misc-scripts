$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot -ChildPath 'Deploy-PowershellProfile.ps1')

$commitMsg = Read-Host -Prompt "Enter commit message"

git config --global user.email "nickwrobel2@gmail.com"
git config --global user.name "Nick Wrobel"

git add --all
git commit -m $commitMsg
git push

Write-Host "Commit pushed successfully" -ForegroundColor Green
Write-Host "Deploying Powershell Profile from repo to apply any updates"

Deploy-PowershellProfile -Verbose #-ForAllUsers
Write-Host "Powershell Profile deployed successfully" -ForegroundColor Green
