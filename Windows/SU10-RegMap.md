# ShutUp10++ Registry Map
This map will include only the `Recommended Settings` from the app as well as the following

- Current User
  - Windows Explorer > Disable ads in Windows Explorer/OneDrive
  - Search > Disable extensions of Windows search with Bing
  - Taskbar
    - Disable People icon in the taskbar
    - Disable search box in the taskbar
    - Disable "Meet now" in the taskbar
    - Disable news and interests in the taskbar
- Local Machine
  - Windows AI
    - Disable Cocreator in Microsoft Paint
    - Disable AI-powered image fill in Microsoft Paint
  - Windows Explorer > Disable OneDrive access to network before login
  - Microsoft Defender and Microsoft SpyNet
    - Disable Microsoft SpyNet membership
    - Disable submitting data samples to Microsoft
    - Disable reporting of malware infection information
  - Taskbar
    - Disable "Meet now" in the taskbar
    - Disable new and interests in the taskbar
  - Miscellaneous
    - Disable Key Management Service Online Activation
    - Disable automatic download and update of map data
    - Disable unsolicited network traffic on the offline maps settings page

## Out-of-box Privacy Settings
```
# Privacy - Disable and reset Advertising ID and info
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f
# Privacy - Disable and reset Advertising ID and info for the machine
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f
# Privacy - Disable transmission of typing information
reg add "HKCU\Software\Microsoft\input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f
# Privacy - The Windows Customer Experience Improvement Program
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f
# App Privacy - Disable app access to device location
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
# App Privacy - Disable app access to device location
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
# Location Services - Disable Windows Geolocation Service
reg add "HKLM\System\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d 0 /f
# User Behavior - Disable the use of diagnostic data for tailor-made user experience
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f
# User Behavior - Disable the use of diagnostic data from customizing user experiences for whole machine
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f
```

--- 

## Current User Map




