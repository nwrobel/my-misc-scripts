
function Show-PfCmdlets {
    Write-Host "Profile contains the following usable cmdlets & aliases:" -ForegroundColor Yellow

    $cmdlets = @(
        'helpw',
        'vbon', 
        'vboff'
    )

    foreach ($cmdlet in $cmdlets) {
        Write-Host $cmdlet -ForegroundColor Cyan
    }
}

function Set-PfVerboseOff {
    $global:VerbosePreference = 'SilentlyContinue'
    Write-Host "VerbosePreference is now set to 'SilentlyContinue'"
}

function Set-PfVerboseOn {
    $global:VerbosePreference = 'Continue'
    Write-Host "VerbosePreference is now set to 'Continue'"
}

function Show-PfHelpWindow {
    param (
        $target
    )

    Get-Help $target -ShowWindow
}

Set-Alias -Name 'vboff' -Value Set-PfVerboseOff
Set-Alias -Name 'vbon' -Value Set-PfVerboseOn
Set-Alias -Name 'helpw' -Value Show-PfHelpWindow

$VerbosePreference = 'Continue'
$ErrorActionPreference = 'Stop'

Write-Host "User Powershell profile was executed successfully! Run 'Show-PfCmdlets' for a list of usable cmdlets from the profile." -ForegroundColor Cyan
Write-Host "Currently, verbose logging is on and execution will stop if an exception is thrown`n" -ForegroundColor Cyan
Write-Host "For help/info, use:" -ForegroundColor Magenta
Write-Host "    Show-PfCmdlets (lists the usable cmdlets defined in the profile)
    help <cmdletname> (-Full, -Examples, -Parameter, -Detailed, etc.)
    helpw <cmdletname> (opens the full help window for cmdlet)
    Get-Member (explore an object)
    Get-Command (locate and browse cmdlets)`n"  -ForegroundColor Cyan

