# SecureBoot 2023 CA Update

In June of 2026, Microsoft's first SecureBoot certificate signed in 2011 expired. Here are some commands to help ensure your system's certificates are updated.

### Check if SecureBoot is enabled
```powershell
if (( Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State" -Name "UEFISecureBootEnabled" ) -eq "1") {
    Write-Host "SecureBoot is enabled" -ForegroundColor Green
} else {
    Write-Host "SecureBoot is Not enabled" -ForegroundColor Yellow
}
```
- If SecureBoot is not enabled, you will need to configure your system's firmware settings to enable it.

### Check if updated certificates are available
```powershell
# Read the Secure Boot databases once
$dbText  = [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).Bytes)
$kekText = [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI kek).Bytes)
# Gather results
$results = @(
    [PSCustomObject]@{
        Name      = 'Windows UEFI CA 2023'
        Installed = $dbText -match 'Windows UEFI CA 2023'
    }
    [PSCustomObject]@{
        Name      = 'Microsoft UEFI CA 2023'
        Installed = $dbText -match 'Microsoft UEFI CA 2023'
    }
    [PSCustomObject]@{
        Name      = 'Microsoft Corporation KEK 2K CA 2023'
        Installed = $kekText -match 'Microsoft Corporation KEK 2K CA 2023'
    }
)
# Output all results together
foreach ($result in $results) {
    if ($result.Installed) {
        Write-Host "$($result.Name) installed" -ForegroundColor Green
    }
    else {
        Write-Host "$($result.Name) Not installed" -ForegroundColor Yellow
    }
}
```

<!-- Original manual commands
[System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes) -match 'Windows UEFI CA 2023'
[System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes) -match 'Microsoft UEFI CA 2023'
[System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI kek).bytes) -match 'Microsoft Corporation KEK 2K CA 2023'
-->

If updated certificates are not yet installed to the firmware, you can manually run the task to update them
- Set the registry key to enable the updates
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot" -Name "AvailableUpdates" -Value 0x40
```
- Run the following scheduled task
```powershell
Start-ScheduledTask -TaskName "\Microsoft\Windows\PI\Secure-Boot-Update"
```
- Reboot the system twice
- Recheck if the updated certificates are installed and then verify if the Boot Manager has been updated

### Verify the Boot Manager is updated
```powershell
if (( Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing" -Name "UEFICA2023Status" ) -eq "Updated") {
    Write-Host "Boot Manager is updated" -ForegroundColor Green
} else {
    Write-Host "Boot Manager is Not updated" -ForegroundColor Yellow
}
```

### Related Event IDs
Source: TPM-WMI
- ID 1036 - Secure Boot Db update applied successfully
- ID 1043 - Secure Boot KEK update applied successfully
- ID 1044 - Secure Boot DB update to install Microsoft Option ROM UEFI CA 2023 certificate applied successfully
- ID 1045 - Secure Boot DB update to install Microsoft UEFI CA 2023 certificate applied successfully
- ID 1800 - A reboot is required before instaiing the Secure Boot update. Reason: Boot Manager (2023)
- ID 1801 - Indicates the old certificate is still in use: "Secure Boot certificates have been updated but are not yet applied to the device firmware"
- ID 1799 - Boot Manager signed with Windows UEFI CA 2023 was installed successfully
- ID 1808 - This device has updated Secure Boot CA/keys
