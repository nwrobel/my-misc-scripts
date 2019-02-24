#################################### Profile.ps1 ##################################################
#
# All the following code will be run every time powershell is started
#
# Use the prefix 'Pf' after the verb-* when naming any command in the profile for use:
#  'Pf' - indicated this is a profile cmdlet that can only be used for users who have my profile.
#   If using any 'Pf' cmdlets in scripts, ensure I copy the definition of those cmdlets into the script.

Write-Host "Loading Powershell profile, defined at 'C:\Users\nick.wrobel\Documents\WindowsPowerShell\profile.ps1'" -ForegroundColor Cyan
$VerbosePreference = 'SilentlyContinue'

function Show-PfCmdlets {
    Write-Host "Profile contains the following usable cmdlets & aliases:" -ForegroundColor Yellow

    $cmdlets = @(
        'helpw',
        'vbon', 
        'vboff',
        'Get-PfUsersLoggedIn'
    )

    foreach ($cmdlet in $cmdlets) {
        Write-Host $cmdlet -ForegroundColor Cyan
    }
}

function Get-PfUsersLoggedIn {
    & query user   
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

# TODO: INCOMPLETE (not usable yet) 
function Write-PfHeading {
<#
.Synopsis
    Prints headline-type messages to the console in a pretty way.
.Parameter Message
    The main message to be printed, required. 
.Parameter Message2
    The secondary message to be printed, if needed.
.Parameter Bold
    Makes the output more eye-grabbing, used for bigger headlines. False by default if not specified.
.Parameter Small
    Makes the output less eye-grabbing, used for smaller, less important headlines. False by default if not specified.
#>

    Param(
        [Parameter(Mandatory=$false)]
        [string]$Message = '', 
        [Parameter(Mandatory=$false)]
        [int]$Length = 0,
        [Parameter(Mandatory=$false)]
        [char]$LineChar = '=',
        [Parameter(Mandatory=$false)]
        [switch]$Big = $false)

    # Get the current terminal width
    # $terminalWidth = (get-host).UI.RawUI.BufferSize.Width

    $messageLength = $message.length

    # Figure out how much padding to use on each side
    # $padding = $terminalWidth - $length - 2
    $padding = $Length - $messageLength -2 

    $leftSide = [math]::Truncate($padding / 2)
    $rightSide = $padding - $leftSide
    $leftSideLine = ''
    $rightSideLine = ''

    # Create the padding
    for ($i = 0; $i -lt $leftSide; $i++) {
        if ($big) {
            $leftSideLine += '\'  
        }
        else {
            $leftSideLine += $LineChar
        }
        
    }

    for ($i = 0; $i -lt $rightSide; $i++) {
        if ($big) {
            $rightSideLine += '/'  
        }
        else {
            $rightSideLine += $LineChar
        }
    }

    # Use different padding characters if we are doing bold
    if ($big) {
        for ($i = 0; $i -lt $terminalWidth; $i++) {
            $boxLine += '='
        }

        Write-Host $boxLine -ForegroundColor Yellow
    }

    # Write out the messages
    Write-Host $leftSideLine $message $rightSideLine -ForegroundColor Yellow

    if ($big) {
        Write-Host $boxLine -ForegroundColor Yellow     
    }
}
        
# TODO: INCOMPLETE (not usable yet) 
# Print out a line divider, made out of special characters       
function Write-PfLine {
<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
    param (
        $Length,
        $AutoSize,
        $LineChar,
        $Message,
        $Alignment
    )
    
}

# TODO: INCOMPLETE (not usable yet) 
# Get the WinRmUri for a system on the network
function Get-PfWinRMUriForSystem {
<#
.Synopsis
    Gets the URI for a Powershell remote manangement session for a system
.Parameter SystemName
    The name of the systems I want to remote into
#>
    param(
        [Parameter(Mandatory=$true)] 
        [string]$SystemName)

    switch ($SystemName)
    {
        'sys1' 
        {
            'http://192.168.1.102:443'
        }
    }
}

# TODO: INCOMPLETE (not usable yet) 
# Retrieve the credential for a system from the saved encrypted credentials
function Get-PfSystemCredential {
    param (
        [Parameter(Mandatory = $true)]
        [String]$SystemName
    )

    # [SecureString]$pwd = ConvertTo-SecureString ($sitePwd) -AsPlainText -Force
    # return (New-Object System.Management.Automation.PSCredential ("$SystemName\$username", $pwd))
}

# TODO: INCOMPLETE (not usable yet) 
# Copy a file to or from a remote system
function Copy-PfFileToFromRemote {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('ToRemote', 'FromRemote')]
        [string]$direction,

        [Parameter(Mandatory=$true)]
        [string]$SystemName,

        [Parameter(Mandatory=$true)]
        [string]$localFilePath,

        [Parameter(Mandatory=$true)]
        [string]$remoteFilePath
    )

    $winRmUri = (Get-PfWinRMUriForSystem -SystemName $SystemName)
    $credential = Get-PfSystemCredential -SystemName $SystemName

    # [System.Uri]$remoteFilePathPath = $remoteFilePathPath
    # if ($remoteFilePathPath.isUNC) {
    #     if ($remoteFilePathPath.isFile) {
    #         $remoteFilePathParentFolder = (Split-Path -Path $remoteFilePathPath -Parent)
    #         $tempDrive = New-PSDrive -Name "TempDrive" -PSProvider FileSystem -Root $remoteFilePathParentFolder -Credential $credential 
        
    #     } else {
    #         $tempDrive = New-PSDrive -Name "TempDrive" -PSProvider FileSystem -Root $remoteFilePathPath -Credential $credential
    #     }
    #     $remoteFilePathPath = $tempDrive
    #     # Copy-Item -Path $Source -Destination "J:\myfile.txt"
    # }

    if ($direction -eq 'ToRemote') {
        Write-Host "Begin pushing local file $($localFilePath) to remote location $($remoteFilePath) in $($SystemName)" -ForegroundColor Cyan
        Copy-BBHostCfgCopyFilesToRemoteServer -WinRMUri $winRmUri -Credential $credential -Source $localFilePath -Destination $remoteFilePath -Recurse
    }
    elseif ($direction -eq 'FromRemote') {
        Write-Host "Begin pulling remote file $($remoteFilePath) in $($SystemName) to local location $($localFilePath)" -ForegroundColor Cyan
        Copy-BBHostCfgCopyFilesFromRemoteServer -WinRMUri $winRmUri -Credential $credential -Source $remoteFilePath -Destination $localFilePath -Recurse
    }

    Write-Host "File transfer completed successfully!" -ForegroundColor Green
}

# TODO: INCOMPLETE (not usable yet) 
# Cmdlet to add new username and password credentials for multiple systems/servers/sites
# at once and store them securely on disk
function New-PfSecureStoredCred  {
    $credentialSaveLocation = "$Env:USERPROFILE\Documents\WindowsPowerShell\exported_objects\sitecreds.csv"

    $systemCredSecureList = [System.Collections.ArrayList]@()
    $systemNames = 'sys1', 'sys2'

    foreach ($system in $systemNames) {
        $systemUsername = Read-Host -Prompt "Enter username for $system"
        $systemPassSecure = Read-Host -AsSecureString -Prompt "Enter password for $system"    
        $systemUsernameSecure = ConvertTo-SecureString -String $systemUsername

        $systemCredSecureList.Add([PSCustomObject]@{
            "SystemName" = $siteName
            "SystemUsernameEncrypted" = $systemUsernameSecure
            "SystemPasswordEncrypted" = $systemPassSecure
        })    
    }

    $systemCredSecureList | Export-Csv -Path $credentialSaveLocation
}

# TODO: INCOMPLETE (not usable yet) 
# Cmdlet to update the saved username and/or password credential for a system/server/site
function Update-PfSecureStoredCred {
    param(
    [Parameter(Mandatory=$true)]
    [string]$siteName
    )
}

Set-Alias -Name 'vboff' -Value Set-PfVerboseOff
Set-Alias -Name 'vbon' -Value Set-PfVerboseOn
Set-Alias -Name 'helpw' -Value Show-PfHelpWindow

$VerbosePreference = 'Continue'
$ErrorActionPreference = 'Stop'

Write-Host "User Powershell profile was executed successfully!" -ForegroundColor Cyan
Write-Host "Currently, verbose logging is on and execution will stop if an exception is thrown`n" -ForegroundColor Cyan
Write-Host "For help/info, use:" -ForegroundColor Magenta
Write-Host "    Show-PfCmdlets (lists usable cmdlets loaded from definitions in the PS profile)
    help <cmdletname> (-Full, -Examples, -Parameter, -Detailed, etc.)
    helpw <cmdletname> (opens the full help window for cmdlet)
    Get-Member (explore an object)
    Get-Command (locate and browse cmdlets)`n"  -ForegroundColor Cyan

