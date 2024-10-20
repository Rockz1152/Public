## Generate-Media-Report.ps1

# Set console background to black
$host.ui.RawUI.BackgroundColor = "Black"
cls

# Change working directory to script's folder
$scriptpath = $MyInvocation.MyCommand.Path
$scriptfolder = Split-Path $scriptpath
Set-Location -Path "$scriptfolder"

# Define the paths for the Movies and Shows directories
#$moviesPath = "E:\Movies"
$moviesPath = "Movies"
#$showsPath = "E:\Shows"
$showsPath = "Shows"

# Define the output HTML file path
#$outputHtmlPath = "E:\media_contents.html"
$outputHtmlPath = "media_contents.html"

# Create a new StringBuilder to store the HTML content
$htmlContent = New-Object -TypeName System.Text.StringBuilder

# Start the HTML document
$htmlContent.AppendLine("<html>") | Out-Null
$htmlContent.AppendLine("<head>") | Out-Null
$htmlContent.AppendLine("<title>Media Contents</title>") | Out-Null
$htmlContent.AppendLine("
<style>
    body {
        background-color: #2b2b2b; /* Dark grey background */
        color: #d3d3d3; /* Light grey text */
        font-family: Arial, sans-serif;
    }
    h1 {
        color: #ffa07a; /* Light salmon color for main title */
    }
    h2 {
        color: #87cefa; /* Light sky blue color for section titles */
    }
    h3 {
        color: #ff7f50; /* Coral color for subfolder titles */
    }
    ul {
        list-style-type: none; /* Remove bullet points from lists */
    }
    li {
        margin: 5px 0;
    }
</style>
") | Out-Null
$htmlContent.AppendLine("</head>") | Out-Null
$htmlContent.AppendLine("<body>") | Out-Null
$htmlContent.AppendLine("<h1>Media Contents</h1>") | Out-Null

# Function to list contents of a directory
function List-FolderContents {
    param (
        [string]$folderPath,
        [string]$sectionTitle
    )

    $htmlContent.AppendLine("<h2>$sectionTitle</h2>") | Out-Null

    # Get the list of subfolders, sorted alphabetically
    $subfolders = Get-ChildItem -Path $folderPath -Directory | Sort-Object Name

    foreach ($subfolder in $subfolders) {
        $htmlContent.AppendLine("<h3>$($subfolder.Name)</h3>") | Out-Null
        $htmlContent.AppendLine("<ul>") | Out-Null

        # Get the list of files in the subfolder, sorted alphabetically
        $files = Get-ChildItem -Path $subfolder.FullName | Sort-Object Name

        foreach ($file in $files) {
            $htmlContent.AppendLine("<li>$($file.Name)</li>") | Out-Null
        }

        $htmlContent.AppendLine("</ul>") | Out-Null
    }

    $htmlContent.AppendLine("<hr>") | Out-Null
}

# List the contents of the Movies directory
List-FolderContents -folderPath $moviesPath -sectionTitle "Movies"

# List the contents of the Shows directory
List-FolderContents -folderPath $showsPath -sectionTitle "Shows"

# Close the HTML document
$htmlContent.AppendLine("</body>") | Out-Null
$htmlContent.AppendLine("</html>") | Out-Null

# Write the HTML content to the output file
$htmlContent.ToString() | Set-Content -Path $outputHtmlPath

Write-Output "HTML file created at: $outputHtmlPath"
Sleep 2
