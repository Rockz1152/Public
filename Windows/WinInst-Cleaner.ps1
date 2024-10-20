﻿# Delete unused .msi and .msp files
# source https://gallery.technet.microsoft.com/Delete-unused-msi-and-msp-aecf0bc8#content

# Verify Running as Admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
If (!( $isAdmin )) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
    exit
}

Function Clean-Up ([String]$FileType, [Array]$Data)
{
    #Reading list of files from C:\Windows\Installer folder.
    $InstallerFiles = Get-ChildItem "C:\Windows\Installer" "*.$FileType" -File
    foreach ($InstallerFile in $InstallerFiles)
    {
        #If Windows Installer doesn't have data about exiting file in C:\Windows\Installer folder,
        #we can assume it is not needed and we delete the file.
        If (!($Data | Where {$_ -eq $InstallerFile.FullName}))
        {
            Remove-Item -Path $InstallerFile.FullName -Force -Verbose -ErrorAction Continue -WhatIf
        }
    }
}

#Initializing arrays
[array]$PatchesLocation = @()
[array]$InstallersLocation = @()

#Finding info about installed programs.
$Installer = New-Object -ComObject "WindowsInstaller.Installer"
$Products = $Installer.Products()

#Going through products and finding patches related to every product.
foreach ($ProductCode in $Products)
{
    #Adding path of the .msi files into the array, which we will process later.
    $InstallersLocation += $Installer.ProductInfo($ProductCode, "LocalPackage")
    
    #Find patches which are installed for certain product code
    $Patches = $Installer.Patches($ProductCode)
    foreach ($PatchCode in $Patches)
    {
        #Adding path of the .msp files into the array, which we will process later.
        $PatchesLocation += $Installer.PatchInfo($PatchCode, "LocalPackage")
    }
}

#Use the function to compare found data with the files in the C:\windows\installer directory.
If ( $PatchesLocation.Count -ne 0)
{
    Clean-Up -FileType "msp" -Data $PatchesLocation
}
If ( $InstallersLocation.Count -ne 0)
{
    Clean-Up -FileType "msi" -Data $InstallersLocation
}

Write-Host 
Write-Host Press any key to close
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")