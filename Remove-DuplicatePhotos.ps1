function Get-ImageDateTaken {
    param (
        $ImageFilepath
    )

    [reflection.assembly]::LoadWithPartialName("System.Drawing") | Out-Null
    $pic = New-Object System.Drawing.Bitmap($ImageFilepath)

    try {
        $bitearr = $pic.GetPropertyItem(36867).Value 
        $string = [System.Text.Encoding]::ASCII.GetString($bitearr) 
        $DateTime = [datetime]::ParseExact($string,"yyyy:MM:dd HH:mm:ss`0",$Null)

        return $DateTime
    
    } catch {
        return $null
    
    } finally {
        $pic.Dispose()
    } 
}

function Get-ImageBestDate {
    param (
        $ImageFilepath
    )

    $file = Get-Item $ImageFilepath

    $fileDateCreated = $file.CreationTime
    $fileDateModified = $file.LastWriteTime
    $fileDateTaken = Get-ImageDateTaken -ImageFilepath $ImageFilepath

    $allDates = @($fileDateCreated, $fileDateModified, $fileDateTaken)
    $oldestDate = $allDates | Sort-Object -Descending | Select-Object -Last 1
    
    return $oldestDate
}

function Remove-DuplicateImages {
    param (
        $ImageRootDir
    )

    $fileHashes = Get-ChildItem $ImageRootDir -Recurse | Get-FileHash -Algorithm 'SHA256'
    $groupedFileHashes = $fileHashes | Group-Object -Property Hash
    
    $duplicateFileHashes = $groupedFileHashes | Where-Object -FilterScript { $_.Count -gt 1 }
    $duplicatesToDeleteFilepaths = @()
    
    foreach ($duplicateFileHashGroup in $duplicateFileHashes) {
        $duplicateFiles = $duplicateFileHashGroup.Group
    
        $oldestFile = $null
        foreach ($file in $duplicateFiles) {
            
            if (-not $oldestFile) {
                $oldestFile = $file
            
            } else {
                $currentFileDate = Get-ImageBestDate -ImageFilepath $file.Path
                $oldestFileDate = Get-ImageBestDate -ImageFilepath $oldestFile.Path
    
                if ($currentFileDate -lt $oldestFileDate) {
                    $oldestFile = $file
                
                # If the two timestamps are equal for the files, choose the one that is NOT in the form of "filename(number).ext"
                # Files that match this form are most likely copies, made from one of the other files in the duplicate group
                } elseif ($currentFileDate -eq $oldestFileDate) {
                    $fileName = (Get-Item $file.Path).Name
                    if ($fileName -notlike "*(*).*") {
                        $oldestFile = $file
                    }
                }
            } 
        }
    
        $duplicatesToDeleteFilepaths += ($duplicateFiles | Where-Object { $_.Path -ne $oldestFile.Path } | Select-Object -ExpandProperty Path)
    }
    
    $duplicatesToDeleteFilepaths | Remove-Item -Force

    Write-Host "Removed the following duplicates (only 1 copy of each of these image files was kept):"
    $duplicatesToDeleteFilepaths
    Write-Host "$($duplicatesToDeleteFilepaths.Count) duplicate image files deleted successfully"    
}

Remove-DuplicateImages -ImageRootDir "Z:\Image Library\Photos"