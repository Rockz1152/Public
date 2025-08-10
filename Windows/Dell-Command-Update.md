# Dell Command Update
Dell Command Update or DCU, is a Dell utility for Windows that detects and installs the latest BIOS, firmware, and driver updates for supported Dell systems.

## Installation
Starting with version 5.5 of Dell Command Update, unnecessary bloat is included in the installer. As such, it is recommended to only install version 5.4 from the link below.

https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=6vfww

## Configuration
These changes configure the following settings:
- Disables the welcome screen to expediate program use
- Disables automatic updates and sets the schedule to `Manual`
- Filters out unwanted software such as the 5.5 update for DCU and Dell's remote support assist tool.

This Powershell code includes a check for Dell hardware just to be safe. Open a Windows Terminal as Admin to run.
```powershell
if ((Get-WmiObject Win32_Bios | Select Manufacturer -ExpandProperty Manufacturer) -eq "Dell Inc."){
Write-Host -NoNewline "Configuring Dell Command Update..."
New-Item -Path "HKLM:\SOFTWARE\DELL\UpdateService\Clients\CommandUpdate\Preferences\Settings\Schedule" -force | Out-Null
New-Item -Path "HKLM:\SOFTWARE\DELL\UpdateService\Clients\CommandUpdate\Preferences\CFG" -force | Out-Null
New-Item -Path "HKLM:\SOFTWARE\DELL\UpdateService\Clients\CommandUpdate\Preferences\Settings\UpdateFilter\UpdateType" -force | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\DELL\UpdateService\Clients\CommandUpdate\Preferences\Settings\Schedule" -Name "ScheduleMode" -PropertyType String -Value "ManualUpdates" | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\DELL\UpdateService\Clients\CommandUpdate\Preferences\CFG" -Name "ShowSetupPopup" -PropertyType DWORD -Value "0" | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\DELL\UpdateService\Clients\CommandUpdate\Preferences\Settings\UpdateFilter\UpdateType" -Name "IsApplicationSelected" -PropertyType DWORD -Value "0" | Out-Null
Write-Host "Done" -ForegroundColor Green
Sleep 2
} else {
Write-Host "Dell hardware not found, exiting..."
sleep 5
}
```
