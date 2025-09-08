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
$outputHtmlPath = "media_inventory.html"

# Get the current date for the inventory header
$currentDate = Get-Date -Format "yyyy-MM-dd"

# Create a new StringBuilder to store the HTML content
$htmlContent = New-Object -TypeName System.Text.StringBuilder

# Helper function to get jump menu letters from a given folder path
function Get-JumpMenuLetters {
    param (
        [string]$folderPath
    )
    $letters = Get-ChildItem -Path $folderPath -Directory |
               ForEach-Object { $_.Name.Substring(0,1).ToUpper() } |
               Sort-Object -Unique
    return $letters
}

# Begin building the HTML document with embedded CSS
$htmlContent.AppendLine("<html>") | Out-Null
$htmlContent.AppendLine("<head>") | Out-Null
$htmlContent.AppendLine("<title>Media Inventory</title>") | Out-Null
$htmlContent.AppendLine(@"
<style>
    body {
        background-color: #2b2b2b; /* Dark grey background */
        color: #d3d3d3; /* Light grey text */
        font-family: Arial, sans-serif;
        margin: 20px;
    }
    h1 {
        color: #ffa07a; /* Light salmon for main title */
    }
    h2 {
        color: #87cefa; /* Light sky blue for section titles */
    }
    h3 {
        color: #ff7f50; /* Coral for subfolder titles */
    }
    .jump-menu {
        margin-bottom: 10px;
    }
    .jump-menu a {
        color: #add8e6;
        margin-right: 8px;
        text-decoration: none;
    }
    .jump-menu a:hover {
        text-decoration: underline;
    }
    ul {
        list-style-type: none; /* Remove bullet points */
        padding-left: 20px;
    }
    li {
        margin: 5px 0;
    }
    hr {
        border: 1px solid #555;
        margin: 20px 0;
    }
</style>
"@) | Out-Null
$htmlContent.AppendLine("</head>") | Out-Null
$htmlContent.AppendLine("<body>") | Out-Null

# Return-to-top anchor
$htmlContent.AppendLine("<a name='top'></a>") | Out-Null

# Add Inventory Date at the top
$htmlContent.AppendLine("<h1>Media Inventory</h1>") | Out-Null
$htmlContent.AppendLine("<p><strong>Inventory Date:</strong> $currentDate</p>") | Out-Null

# Build jump menus for both Movies and Shows and output them at the top
$moviesLetters = Get-JumpMenuLetters -folderPath $moviesPath
$showsLetters  = Get-JumpMenuLetters -folderPath $showsPath

# Count Movies and Shows
$movieCount = $(Get-ChildItem -Path $moviesPath -Directory -Depth 1).count
$showCount = $(Get-ChildItem -Path $showsPath -Directory -Depth 1).count

$htmlContent.AppendLine("<div class='jump-menu'>") | Out-Null
$htmlContent.AppendLine("<table style='text-align:left;'>") | Out-Null

$htmlContent.AppendLine("<tr>") | Out-Null
$htmlContent.AppendLine("<td style='vertical-align:top;'><strong>($movieCount) Movies:</strong>&nbsp;&nbsp;&nbsp;</td>") | Out-Null
$htmlContent.AppendLine("<td>") | Out-Null
foreach ($letter in $moviesLetters) {
    $htmlContent.AppendLine("<a href='#Movies_$letter' style='margin-right:8px;'>$letter</a>") | Out-Null
}
$htmlContent.AppendLine("</td>") | Out-Null
$htmlContent.AppendLine("</tr>") | Out-Null

$htmlContent.AppendLine("<tr>") | Out-Null
$htmlContent.AppendLine("<td style='vertical-align:top;'><strong>($showCount) Shows:</strong>&nbsp;&nbsp;&nbsp;</td>") | Out-Null
$htmlContent.AppendLine("<td>") | Out-Null
foreach ($letter in $showsLetters) {
    $htmlContent.AppendLine("<a href='#Shows_$letter' style='margin-right:8px;'>$letter</a>") | Out-Null
}
$htmlContent.AppendLine("</td>") | Out-Null
$htmlContent.AppendLine("</tr>") | Out-Null

$htmlContent.AppendLine("</table>") | Out-Null
$htmlContent.AppendLine("</div>") | Out-Null

$htmlContent.AppendLine("<hr>") | Out-Null

# Function to list folder contents and include anchors for jump navigation
function List-FolderContents {
    param (
        [string]$folderPath,
        [string]$sectionTitle,
        [string]$anchorPrefix
    )

    $htmlContent.AppendLine("<h2>$sectionTitle</h2>") | Out-Null

    # Get the list of subfolders sorted alphabetically
    $subfolders = Get-ChildItem -Path $folderPath -Directory | Sort-Object Name

    if (-not $subfolders) {
        $htmlContent.AppendLine("<p>No subfolders found for $sectionTitle.</p>") | Out-Null
        return
    }

    $currentLetter = ""
    foreach ($subfolder in $subfolders) {
        $firstLetter = $subfolder.Name.Substring(0,1).ToUpper()
        if ($firstLetter -ne $currentLetter) {
            # Insert an anchor for this letter group
            $htmlContent.AppendLine("<a name='${anchorPrefix}_$firstLetter'></a>") | Out-Null
            $currentLetter = $firstLetter
        }
        $htmlContent.AppendLine("<h3>$($subfolder.Name)</h3>") | Out-Null
        $htmlContent.AppendLine("<ul>") | Out-Null

        # Get the files within this subfolder, sorted alphabetically
        $files = Get-ChildItem -Path $subfolder.FullName | Sort-Object Name
        foreach ($file in $files) {
            $htmlContent.AppendLine("<li>$($file.Name)</li>") | Out-Null
        }
        $htmlContent.AppendLine("</ul>") | Out-Null
    }

    $htmlContent.AppendLine("<hr>") | Out-Null
}

# List the contents of the Movies directory (anchors will be present as defined above)
List-FolderContents -folderPath $moviesPath -sectionTitle "Movies" -anchorPrefix "Movies"

# List the contents of the Shows directory (anchors will be present as defined above)
List-FolderContents -folderPath $showsPath -sectionTitle "Shows" -anchorPrefix "Shows"

# Add a "Return to Top" button (bottom-right corner)
$htmlContent.AppendLine(@"
<a href="#top" id="topBtn">&#8679;</a>
<style>
    #topBtn {
        position: fixed;
        bottom: 20px;
        right: 20px;
        font-size: 28px;
        text-decoration: none;
        background-color: #444;
        color: #fff;
        padding: 10px 15px;
        border-radius: 6px; /* Small rounding for square edges */
        box-shadow: 2px 2px 6px #000;
        opacity: 0.6;              /* Semi-transparent */
        transition: opacity 0.3s, background-color 0.3s;
    }
    #topBtn:hover {
        background-color: #666;
    }
</style>
"@) | Out-Null


# Close the HTML document
$htmlContent.AppendLine("</body>") | Out-Null
$htmlContent.AppendLine("</html>") | Out-Null

# Write the HTML content to the output file
$htmlContent.ToString() | Set-Content -Path $outputHtmlPath

Write-Output "HTML file created at: $outputHtmlPath"
Sleep 2
