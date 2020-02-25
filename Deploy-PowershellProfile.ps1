function Deploy-PowershellProfile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [switch]$ForAllUsers
    )
    $thisFn = $MyInvocation.MyCommand.Name

    $profileRepoFilepath = (Join-Path $PSScriptRoot -ChildPath 'profile.ps1')

    if ($ForAllUsers) {
        $profileLocalDestFilepath = $profile.AllUsersAllHosts
        Write-Verbose "$($thisFn): Powershell Profile will be deployed for all users"

    } else {
        $profileLocalDestFilepath = $profile.CurrentUserAllHosts
        Write-Verbose "$($thisFn): Powershell Profile will be deployed for current user only"
    }

    Write-Verbose "$($thisFn): Deploying Profile from the repo:`n   Source: $($profileRepoFilepath)`n   Destination: $($profileLocalDestFilepath)"
    Copy-Item $profileRepoFilepath -Destination $profileLocalDestFilepath -Force -Confirm:$false

    Write-Verbose "$($thisFn): Powershell Profile deployment complete" 
}