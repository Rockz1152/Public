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
# Current User

## Privacy - Disable and reset Advertising ID and info
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f

## Privacy - Disable transmission of typing information
reg add "HKCU\Software\Microsoft\input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f

## App Privacy - Disable app access to device location
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f

## User Behavior - Disable the use of diagnostic data for tailor-made user experience
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f

# Local Machine

## Privacy - Disable and reset Advertising ID and info for the machine
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f

## Privacy - The Windows Customer Experience Improvement Program
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f

## App Privacy - Disable app access to device location
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f

## Location Services - Disable Windows Geolocation Service
reg add "HKLM\System\CurrentControlSet\Services\lfsvc\Service\Configuration" /v "Status" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v "SensorPermissionState" /t REG_DWORD /d 0 /f

## User Behavior - Disable the use of diagnostic data from customizing user experiences for whole machine
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f
```

## Current User Map

Privacy
```
# Disable and reset Advertising ID and info
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f

# Disable transmission of typing information
reg add "HKCU\Software\Microsoft\input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f

# Disable suggestions in the timeline
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d 0 /f

# Disable suggestions in Start
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f

# Disable tips, tricks, and suggestions when using Windows
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f

# Disable showing suggested content in the Settings app
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f

# Disable the possibility of suggestion to finish the setup of the device
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v "ScoobeSystemSettingEnabled" /t REG_DWORD /d 0 /f
```

App Privacy
```
# Disable app access to user account information
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f

# Disable Windows tracking of app starts
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d 0 /f

# Disable app access to diagnostics information
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f
```

Microsoft Edge (new version based on Chromium)
```
# Disable tracking in the web
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "ConfigureDoNotTrack" /t REG_DWORD /d 1 /f

# Disable check for saved payment methods by sites
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PaymentMethodQueryEnabled" /t REG_DWORD /d 0 /f

# Disable personalizing advertising, search, news and other services
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d 0 /f

# Disable automatic complete of web addresses in address bar
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d 0 /f

# Disable user feedback in toolbar
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d 0 /f

# Disable storing and autocompleting of credit card data on websites
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d 0 /f

# Disable form suggestions
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillAddressEnabled" /t REG_DWORD /d 0 /f

# Disable suggestions from local providers
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "LocalProvidersEnabled" /t REG_DWORD /d 0 /f

# Disable search and website suggestions
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SearchSuggestEnabled" /t REG_DWORD /d 0 /f

# Disable shopping assistant in Microsoft edge
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d 0 /f

# Disable Edge bar
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "WebWidgetAllowed" /t REG_DWORD /d 0 /f

# Disable Sidebar in Microsoft Edge
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "HubsSidebarEnabled" /t REG_DWORD /d 0 /f

# Disable the Microsoft Account Sign-In button
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "BrowserSignin" /t REG_DWORD /d 0 /f

# Disable Enhanced Spell Checking
reg add "HKCU\Software\Policies\Microsoft\Edge" /v "MicrosoftEditorProofingEnabled" /t REG_DWORD /d 0 /f
```
