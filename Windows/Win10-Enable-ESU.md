# Enable ESU (Extended Security Updates)
_*This requires a personal Microsoft Account_

Sources:

- https://www.youtube.com/watch?v=ym-Iz1Afy7w
- https://www.yourwindowsguide.com/2025/09/cant-enroll-in-windows-10-esu.html#gsc.tab=0
- https://www.askwoody.com/forums/topic/how_to_force_windows_10_esu/

Try this first

- Add the registry keys to allow for ESU opt-in
```
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU" /v "ESUEligibility" /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU" /v "ESUEligibilityResult" /t REG_DWORD /d 1 /f
```
- Open Windows Update and click `Enroll` on the right side bar or at the bottom of the page

If the Enroll option is still missing try this as well

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

_*Removing the Microsoft account from the system may prevent future updates from installing_
