Get-AppxPackage | Select Name,PackageFullName

Get-AppxPackage -AllUsers *xboxapp* | Remove-AppxPackage