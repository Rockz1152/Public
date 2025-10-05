# Enable ESU (Extended Security Updates)
Source: https://www.yourwindowsguide.com/2025/09/cant-enroll-in-windows-10-esu.html#gsc.tab=0

_*This requires a personal Microsoft Account_

- Enable Connected User Experiences and Telemetry (DiagTrack) service
```
Set-Service -Name "DiagTrack" -StartupType Automatic; Start-Service -Name "DiagTrack"
```
- Force ESU opt-in to appear in Windows Update
```
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides" /v 4011992206 /t REG_DWORD /d 2 /f
```
- Reboot the computer
- Run the eligibility check
```
cmd /c ClipESUConsumer.exe -evaluateEligibility
```
- Open Windows Update and you should be able to opt-in to ESU now
- Disable the "DiagTrack" service after enrolling
```
Set-Service -Name "DiagTrack" -StartupType Disabled; Stop-Service -Name "DiagTrack"
```

Once enrolled updates are valid until October 2026
