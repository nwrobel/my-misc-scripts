# TODO: make this into a module, for practice in creating your own Powershell modules
# TDOD: add inline help docs to make these cmdlets usable by others on Github - make sure that
# "get-help" returns correct info for each cmdlet

function Compress-AllDirsInFolder {
    param (
        [string]$ParentFolder
    )

    $zipExecutablePath = "$env:ProgramFiles\7-Zip\7z.exe"
    $zipExecutablePath86 = "${env:ProgramFiles(x86)}\7-Zip\7z.exe"

    if (Test-Path -Path $zipExecutablePath) {
        Set-Alias -Name sz -Value $zipExecutablePath

    } elseif (Test-Path -Path $zipExecutablePath86) {
        Set-Alias -Name sz -Value $zipExecutablePath86

    } else {
        throw "7zip not found in either expected install dirs: $zipExecutablePath; $zipExecutablePath86"
    }

    $foldersToZip = (Get-ChildItem -Path $ParentFolder -Directory | Select-Object -ExpandProperty FullName)
    $numFoldersToZip = @($foldersToZip).Count

    Write-Host "$numFoldersToZip folders were found within the parent folder, ready to archive:" -ForegroundColor Yellow
    $foldersToZip

    do {
        $continue = Read-Host -Prompt "Proceed with archiving these folders? [Y/N]"

        if ($continue -eq 'n') {
            throw "Exiting due to choice of user"
        
        } elseif ($continue -ne 'y') {
            Write-Host "Incorrect response: Enter Y or N" -ForegroundColor Red
        }
    
    } while ($continue -ne 'y')

    Write-Host "`nStarting compression process on $numFoldersToZip folders..."

    foreach ($folder in $foldersToZip) {
        Write-Host "`n---------------------------------------------------------------------------------------------------" -ForegroundColor Cyan
        Write-Host "Starting compression, directory: $folder" -ForegroundColor Cyan

        $targetFilepath = "$folder-archive.7z"
        sz a -mx=9 -t7z $targetFilepath $folder

        Write-Host "`nArchive creation complete for this directory!" -ForegroundColor Cyan
    }

    Write-Host "`nCompression process completed on $numFoldersToZip folders!" -ForegroundColor Green
}

function Test-AllArchivesInFolder {
    param (
        [string]$ParentFolder
    )

    $zipExecutablePath = "$env:ProgramFiles\7-Zip\7z.exe"
    $zipExecutablePath86 = "${env:ProgramFiles(x86)}\7-Zip\7z.exe"

    if (Test-Path -Path $zipExecutablePath) {
        Set-Alias -Name sz -Value $zipExecutablePath

    } elseif (Test-Path -Path $zipExecutablePath86) {
        Set-Alias -Name sz -Value $zipExecutablePath86

    } else {
        throw "7zip not found in either expected install dirs: $zipExecutablePath; $zipExecutablePath86"
    }

    $archivesToTest = (Get-ChildItem -Path $ParentFolder -Filter '*.7z' | Select-Object -ExpandProperty FullName)
    $numArchivesToTest = @($archivesToTest).Count

    Write-Host "$numArchivesToTest 7z archives were found within the parent folder, ready to test:" -ForegroundColor Yellow
    $archivesToTest

    do {
        $continue = Read-Host -Prompt "Proceed with testing these archives? [Y/N]"

        if ($continue -eq 'n') {
            throw "Exiting due to choice of user"
        
        } elseif ($continue -ne 'y') {
            Write-Host "Incorrect response: Enter Y or N" -ForegroundColor Red
        }
    
    } while ($continue -ne 'y')

    Write-Host "`nStarting testing process on $numArchivesToTest archives..."

    foreach ($archive in $archivesToTest) {
        Write-Host "`n---------------------------------------------------------------------------------------------------" -ForegroundColor Cyan
        Write-Host "Starting test: $archive" -ForegroundColor Cyan

        sz t $archive * -r

        Write-Host "`nTest complete for this archive!" -ForegroundColor Cyan
    }

    Write-Host "`nTesting process completed on $numArchivesToTest archives!" -ForegroundColor Green
    
}






