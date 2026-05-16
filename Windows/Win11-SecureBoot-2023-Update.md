# SecureBoot 2023 CA Update

In June of 2026, Microsoft's first SecureBoot certificate signed in 2011 expired. Here are some commands to help ensure your system's certificates are updated.

### Check if SecureBoot is enabled
```
if (( Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State" -Name "UEFISecureBootEnabled" ) -eq "1") {
    Write-Host "SecureBoot is enabled" -ForegroundColor Green
} else {
    Write-Host "SecureBoot is Not enabled" -ForegroundColor Yellow
}
```
- If SecureBoot is not enabled, you will need to configure your system's firmware settings to enable it.

### Check if updated certificates are available
```
[System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes) -match 'Windows UEFI CA 2023'
[System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes) -match 'Microsoft UEFI CA 2023'
[System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI kek).bytes) -match 'Microsoft Corporation KEK 2K CA 2023'
```
If updated certificates are not yet installed to the firmware, you can manually run the task to update them
- Set the registry key
```
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot" -Name "AvailableUpdates" -Value 0x40
```
- Run the following scheduled task
```
Start-ScheduledTask -TaskName "\Microsoft\Windows\PI\Secure-Boot-Update"
```
- Reboot the system twice

### Verify the boot loader is updated
```
if (( Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing" -Name "UEFICA2023Status" ) -eq "Updated") {
    Write-Host "Boot loader is updated" -ForegroundColor Green
} else {
    Write-Host "Boot loader is Not updated" -ForegroundColor Yellow
}
```


