# Set the path to the folder containing the .flac files
$ffmpegPath = "C:\Download\ffmpeg\bin\ffmpeg.exe"
$folderPath = "C:\Download\media"
$outputFolder = "C:\Download\media"

# Get all .flac files in the folder
$flacFiles = Get-ChildItem -Path $folderPath -Filter "*.flac" -Recurse

foreach ($file in $flacFiles) {
    # $outputFile = [System.IO.Path]::ChangeExtension($file, "mp3")
    $outputFile = $file.FullName -replace "\.flac$", ".mp3"

	Write-Host "Converting: $file"
	& $ffmpegPath -i $file.FullName -ab 128k -map_metadata 0 -id3v2_version 3 $outputFile
}
