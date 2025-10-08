# Enable ESU (Extended Security Updates)
Source: https://www.youtube.com/watch?v=ym-Iz1Afy7w

_*This requires a personal Microsoft Account_

- Add the registry keys to allow for ESU opt-in
```
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU" /v "ESUEligibility" /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU" /v "ESUEligibilityResult" /t REG_DWORD /d 1 /f
```
- Open Windows Update and click `Enroll` on the right side bar or at the bottom of the page

Once enrolled updates are valid until October 2026
