# Backup-Addons.ps1
# Authored by Rockz 6-2-21

# If you get an Execution Policy error running the script, open a powershell prompt as an administrator and run:
# Set-ExecutionPolicy Unrestricted -Force

# Set Variable paths
$Env:Dropbox = "D:\Dropbox"
$Env:WoW = "C:\World of Warcraft"
$Env:7zip = "$Env:Programfiles\7-Zip\7z.exe"

# Set console height and width
[console]::WindowHeight=30;

# set console colors and print ascii art
$host.ui.RawUI.BackgroundColor = "Black"
cls
Write-Host ""
$oldtext = $host.ui.RawUI.ForegroundColor
$host.ui.RawUI.ForegroundColor = "Green"
Write-Host "      :::::::::   ::::::::   ::::::::  :::    ::: ::::::::: ";
Write-Host "     :+:    :+: :+:    :+: :+:    :+: :+:   :+:       :+:   ";
Write-Host "    +:+    +:+ +:+    +:+ +:+        +:+  +:+       +:+     ";
Write-Host "   +#++:++#:  +#+    +:+ +#+        +#++:++       +#+       ";
Write-Host "  +#+    +#+ +#+    +#+ +#+        +#+  +#+     +#+         ";
Write-Host " #+#    #+# #+#    #+# #+#    #+# #+#   #+#   #+#           ";
Write-Host "###    ###  ########   ########  ###    ### #########       ";
$host.ui.RawUI.ForegroundColor = $oldtext
Remove-Variable oldtext

# Verify Paths
$Paths = @($Env:Dropbox,$Env:WoW,$Env:7zip)
foreach ($Path in $Paths) {
    if (!(Test-Path $Path)) {
        Write-host "$Path not found"
        $StopScript = "true"
        }
    }
if ($StopScript -eq "true") {
    Write-Host ""
    Write-host "One or more paths are invalid"
    Write-host "Please correct and run again"
    Write-Host -NoNewLine 'Press any key to close...';
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    exit
}

# hide progress text and show header
$progressPreference = 'silentlyContinue'
Write-Host ""
Write-Host "Backing up Warcraft Addons..."
Write-Host ""

function backup($era) {
    If(Test-Path "$Env:Dropbox\$era.7z"){
        Remove-Item "$Env:Dropbox\$era.7z" -force
    }
    Write-Host "Backing up $era"
    & $Env:7zip a "$Env:Dropbox\$era.7z" "$Env:WoW\$era\Interface" "$Env:WoW\$era\WTF" | Out-null
    Write-Host "$era complete"
}

workflow work {
    parallel {
        backup _classic_
        backup _classic_era_
        backup _retail_
    }
    "All done"
    Sleep 3
}
work

$Env:Dropbox = $null
$Env:WoW = $null
$Env:7zip = $null
$progressPreference = 'Continue'
