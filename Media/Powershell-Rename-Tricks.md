## Powershell File Rename Tricks
Change to the directory of the files first
```
cd "path\to\files"
```
Changing the File Extension of all .jpeg files to .jpg
```
dir *.jpeg | rename-item -newname { $_.name  -replace ".jpeg",".jpg" }
```
```
dir *.srt | rename-item -newname { $_.name  -replace ".srt",".eng.srt" }
```
Appending a File Extension 
```
dir | rename-item -newname  { $_.Name +".jpg" }
```
File Rename with Customizable Increasing Number
```
dir *.jpg | ForEach-Object  -begin { $count=1 }  -process { rename-item $_ -NewName "image$count.jpg"; $count++ }
```
