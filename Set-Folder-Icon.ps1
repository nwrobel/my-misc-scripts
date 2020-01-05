
function Set-FolderIcon {
    param(
        [string]$TargetDirectory,
        [string]$IconFilepath
    )

    $DesktopIniContent = "
    [.ShellClassInfo]
    IconResource=C:\WINDOWS\System32\SHELL32.dll,316
    "
     
    If (Test-Path "$($TargetDirectory)\desktop.ini")  {
      Write-Verbose "The desktop.ini file already exists! Operation aborted"
    
    } Else  {
      #Create/Add content to the desktop.ini file
      Set-Content -Path "$($TargetDirectory)\desktop.ini" -Value $DesktopIniContent
      
      #Set the attributes for $DesktopIni
      (Get-Item "$($TargetDirectory)\desktop.ini" -Force).Attributes = 'Hidden, System, Archive'
     
      #Finally, set the folder's attributes
      (Get-Item $TargetDirectory -Force).Attributes = 'ReadOnly, Directory'
    }
}

Set-FolderIcon -TargetDirectory "D:\Temp\Git Repo Backups" -IconFilepath ''
