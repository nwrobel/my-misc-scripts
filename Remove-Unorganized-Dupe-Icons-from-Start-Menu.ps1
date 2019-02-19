$expectedStartMenuSubfolderNames = 'Audio Tools','Development','Drawing & Modeling','File Management','Internet','IT',
                               'Media Players','Music Creation','Music Library','Office Software','Photo Tools',
                               'Security','StartUp','System Info','Utilities & Maintenance','Video Tools',
                               'Windows Accessories','Windows Administrative Tools','Windows System'

$currentUserStartMenuPath = "$($ENV:APPDATA)\Microsoft\Windows\Start Menu\Programs"
$systemStartMenuPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

Write-host "Warning - this will delete:`n- ALL shortcuts/folders from the current user start menu folder`n- All unsorted shortcuts/folders (those not in the expected subfolders) from the system start menu" -ForegroundColor Magenta

$currentUserStartMenuItemsToDelete = Get-ChildItem -Path $currentUserStartMenuPath -Recurse
$systemStartMenuItemsToDelete = Get-ChildItem -Path $systemStartMenuPath -Recurse -Exclude $expectedStartMenuSubfolders

Write-Host "The following items are set to be deleted:" -ForegroundColor Magenta
$currentUserStartMenuItemsToDelete
$systemStartMenuItemsToDelete

$continue = Read-Host -Prompt "Are you sure you want to remove these items? [y/n]"

if ($continue -eq 'y') {

} elseif ($continue -eq 'n') {

} else {
    Write-Host 'Please enter y or n to decide' -ForegroundColor Red
}