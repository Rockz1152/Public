# Enable ESU (Extended Security Updates)
Source: https://www.yourwindowsguide.com/2025/09/cant-enroll-in-windows-10-esu.html#gsc.tab=0

_*This requires a personal Microsoft Account_

- Enable Connected User Experiences and Telemetry (DiagTrack) service
```
sc.exe config DiagTrack start= auto
sc.exe start DiagTrack
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

Once enabled updates are valid until October 2026
