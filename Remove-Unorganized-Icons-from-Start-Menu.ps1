function Assert-ReadInputYesToProceed {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Prompt,
      
        [Parameter(Mandatory=$false)]
        [string]$ErrorMessageOnInputNo = "Stopping script due to user choice"
    )

    do {
        $continue = Read-Host -Prompt "$Prompt [Y/N]"

        if ($continue -eq 'n') {
            Write-Host $ErrorMessageOnInputNo -ForegroundColor Red
            exit
        
        } elseif ($continue -ne 'y') {
            Write-Host "Incorrect input: Enter Y or N" -ForegroundColor Red
        }
    } while ($continue -ne 'y')   
}

$subfoldersToKeep = @(
'Audio Tools',
'Development',
'Drawing & Modeling',
'File Management',
'Internet',
'IT',
'Media Players',
'Music Creation',
'Music Library',
'Office Software',
'Photo Tools',
'Security',
'StartUp',
'System Info',
'Utilities & Maintenance',
'Video Tools',
'Win. Accessories',
'Win. Admin Tools',
'Win. System'
)

Write-Host "Organizing start menu according to the list 'folders to keep' specified" -ForegroundColor Green
Write-Host "Scanning for items to remove..." -ForegroundColor Cyan

$currentUserStartMenuPath = "$($ENV:APPDATA)\Microsoft\Windows\Start Menu\Programs"
$systemStartMenuPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

Write-host "Warning - this will delete:`n- ALL shortcuts/folders from the current user start menu folder`n- All unsorted shortcuts/folders (those not in the expected subfolders) from the system start menu" -ForegroundColor Magenta

$expectedStartMenuSubfolders = ($subfoldersToKeep | ForEach-Object  {
    Join-Path -Path $systemStartMenuPath -ChildPath $_
})

$currentUserStartMenuItemsToDelete = (Get-ChildItem -Path $currentUserStartMenuPath)
$systemStartMenuItemsToDelete = (Get-ChildItem -Path $systemStartMenuPath | Where-Object -FilterScript { $_.FullName -notin $expectedStartMenuSubfolders})

Write-Host "The following start menu items are ready to be deleted`n(any files contained in listed folders will also be deleted):" -ForegroundColor Red
$currentUserStartMenuItemsToDelete | Select-Object -ExpandProperty FullName 
$systemStartMenuItemsToDelete | Select-Object -ExpandProperty FullName 

Assert-ReadInputYesToProceed -Prompt "Are you sure you want to delete these items?"

$currentUserStartMenuItemsToDelete | Remove-Item -Force -Verbose -Recurse
$systemStartMenuItemsToDelete | Remove-Item -Force -Verbose -Recurse

Write-Host "Unorganized start menu items were removed successfully!" -ForegroundColor Green
