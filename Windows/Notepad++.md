# Notepad++
## Download
- https://notepad-plus-plus.org/downloads/
- [Ninite](https://ninite.com/)

## Installation
- Leave all installation options on their default settings
- You can optionally enable the desktop shortcut
- Let the installation finish
- It's recommended to enable the "Show hidden file extensions" option in Windows File Explorer
```
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f; Stop-Process -ProcessName explorer
```

## Appearance

### Set Dark Theme and Fonts
- Open Notepad++
- Go to Settings > Preferences
- On the left select 'Dark Mode', check `Dark mode` and click `Close`
- Go to Settings > Style Configurator
  - Make sure "Global Styles" is selected under "Language"
  - Make sure "Default Style" is selected under "Style"
- Under 'Font Style' on the right side, select a font size of `12`
- Click `Save & Close`

## Configuration
- Settings > Preferences
- Toolbar
  - Check `Hide`
- Tab Bar
  - Uncheck `Enable pin tab feature`
- Editing 1
  - Check `Enable smooth font`
- Margins/Border/Edge
  - Fold Margin Style
    - Select `Circle tree`
  - Change History
    - If the green/orange colors in the margin are distracting, you can disable them here
    - Uncheck `Show in the margin`
    - Uncheck `Show in the text`
  - Border Width
    - Check `No Edge`
  - Uncheck `Display bookmark`
- New document
  - Under Format (Line ending), select `Unix (LF)`
- Indentation
  - Make sure Indent size is set to `4` and under "Indent using:" select `Space characters(s)`
- Backup
  - Make sure both settings are enabled, `Remember current session for next launch` and `Enable session snapshot and periodic backup`
- Auto-Completion
  - Make sure Auto indent is checked
  - Uncheck both `Enable auto-completion on each input` and `Function parameters hint on input`
- Cloud & Link
  - Under Clickable Link Settings, uncheck `Enable`
- MISC.
  - If you don't want to be prompted when there are updates available for Notepad++, uncheck `Enable Notepad++ auto-updater`

### Optional
- View > Show Symbol
  - Check `Show Space and Tab`
  - Uncheck `Show Indent Guide`

## Plugins
- Plugins > Plugins Admin
- Search for `DSpellCheck` and `ComparePlus`, check each and click Install
- Click Yes to the popup and yes to the UAC popup
- Verify the plugins are installed by clicking Plugins at the top
  - You should now see ComparePlus and DSpellCheck
- We need to install a language for DSpellCheck to work
  - Go to Plugins > DSpellCheck > Change Current Language > Download Languages
  - In the popup select `English (United States)` and then click `Install Selected`

## Troubleshooting
Syntax highlighting is broke after an update

- Close Notepad++
- Navigate to `%APPDATA%\Notepad++\themes` and delete `DarkModeDefault.xml`
- Reopen Notepad++ and reapply the settings from the Appearance section above
