# MoveSubs.ps1
# Copy it to the ROOT folder containing all the season folders. If you dont have a root folder, create one and put all the season folders in there.
# Right Click the script and select "Run with Power Shell".
# Source: https://www.reddit.com/r/Piracy/comments/155szxj/i_created_a_windows_powershell_script_to_move_and/

# Get the current directory where the script is being executed (assuming it's the root folder of the TV show containing season folders)
$tvShowRootFolder = Get-Location

# Initialize variables to count the copied subtitle files and deleted folders
$subtitleFilesCopied = 0
$foldersDeleted = @()

# Get all season folders within the main TV show root folder
$seasonFolders = Get-ChildItem -Path $tvShowRootFolder -Directory

# Loop through each season folder
foreach ($seasonFolder in $seasonFolders) {
    # Get the "Subs" folder path within the current season folder
    $subsFolder = Join-Path -Path $seasonFolder.FullName -ChildPath "Subs"

    # Check if the "Subs" folder exists within the current season folder
    if (Test-Path -Path $subsFolder -PathType Container) {
        # Get all the subfolders (Episode Subtitle Folders) in the "Subs" folder
        $episodeSubtitleFolders = Get-ChildItem -Path $subsFolder -Directory

        # Loop through each episode subtitle folder
        foreach ($episodeFolder in $episodeSubtitleFolders) {
            # Get the episode name (parent folder name)
            $episodeName = $episodeFolder.Name

            # Get all .srt files in the current episode subtitle folder
            $srtFiles = Get-ChildItem -Path $episodeFolder.FullName -Filter "*.srt"

            # Loop through each .srt file in the current episode subtitle folder
            foreach ($srtFile in $srtFiles) {
                # Create a new filename with the episode name as a prefix
                $newFileName = "{0}_{1}" -f $episodeName, $srtFile.Name

                # Set the destination path to the current season folder
                $destinationPath = Join-Path -Path $seasonFolder.FullName -ChildPath $newFileName

                # Copy the .srt file to the current season folder with the new filename
                Copy-Item -Path $srtFile.FullName -Destination $destinationPath

                # Increment the count of copied subtitle files
                $subtitleFilesCopied++
            }
        }

        # Provide a summary for each season
        Write-Host "Season $($seasonFolder.Name): $subtitleFilesCopied subtitle files copied."

        # Reset the subtitle files counter for the next season
        $subtitleFilesCopied = 0
    }
}

# Display the final message
Write-Host "`nAll .srt files have been renamed and copied to their corresponding season folders."

# Ask the user if they want to delete the original "Subs" folders
$deleteSubsFolders = Read-Host "Do you want to delete the original 'Subs' folders? (Y/N)"

# If the user chooses to delete the original "Subs" folders, proceed
if ($deleteSubsFolders -eq "Y" -or $deleteSubsFolders -eq "y") {
    # Loop through each season folder again to delete the "Subs" folders
    foreach ($seasonFolder in $seasonFolders) {
        $subsFolder = Join-Path -Path $seasonFolder.FullName -ChildPath "Subs"
        if (Test-Path -Path $subsFolder -PathType Container) {
            Remove-Item -Path $subsFolder -Recurse -Force
            $foldersDeleted += $subsFolder
        }
    }

    # Provide a summary of deleted folders
    Write-Host "`nDeleted 'Subs' folders:"
    foreach ($folderDeleted in $foldersDeleted) {
        Write-Host $folderDeleted
    }
}

# Display the total count of original folders deleted
Write-Host "`nTotal 'Subs' folders deleted: $($foldersDeleted.Count)"

# Prevent the PowerShell window from closing automatically
Write-Host "Press any key to close this window..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")