# ps1 encoding
chcp 65001

Set-Location $PSScriptRoot

# default values
[string]$url = ""
[string]$output = ""
[int]$len = 0
[string]$cookies = ""
[array]$list = @()
[string]$codec = ""

# check if ffmpeg and ffprobe are available
ffprobe -version | Out-Null
if (-not $?) {
    "ffprobe is unabailable`nenter to exit"
    Read-Host
    exit
}
ffmpeg -version | Out-Null
if (-not $?) {
    "ffmpeg is unabailable`nenter to exit"
    Read-Host
    exit
}

# main block
while ($true) {
    do {
        Clear-Host
        $url = Read-Host -Prompt "URL"
        Invoke-WebRequest -Uri "$url" -Method Head | Out-Null
    } until ($?)
    do {
        $output = Read-Host -Prompt "output filename without extension"
        $len = $output.Length
    } until ($len -ge 1 -and $output -match "[^\u0022\u002a\u002f\u003a\u003c\u003e\u003f\u005c\u007c]{$len}")
    if (Test-Path -Path "$output.mp4") {
        "file already exists`nenter to return"
        continue
    }
    if (Test-Path -Path "cookies.txt") {
        $cookies = "--cookies cookies.txt"
    } else {
        $cookies = "--no-cookies"
    }
    yt-dlp -q --progress --force-overwrites -f "bv[ext=mp4]+ba[ext=m4a]/bv+ba/best" --recode-video mp4 $cookies -o "${output}_%(autonumber)d.mp4" -R infinite $url
    yt-dlp -q --force-overwrites --skip-download --write-thumbnail --convert-thumbnails png -o "$output.%(ext)s" $url
    if (Test-Path "list.txt") {
        Remove-Item "list.txt"
    }
    $list = Get-ChildItem -Name | Where-Object {$_ -match "${output}_\d+\.mp4"}
    if ($list.Count -ge 2) {
        $list | ForEach-Object {"file $_" | Out-File "list.txt" -Append -Encoding utf8NoBOM}
        ffmpeg -y -loglevel -8 -f concat -i "list.txt" -c:v h264_nvenc -qmax 18 -qmin 18 "${output}1.mp4"
        $list | ForEach-Object {Remove-Item $_}
    } else {
        Rename-Item "${output}_1.mp4" "${output}1.mp4"
    }
    if (Test-Path "list.txt") {
        Remove-Item "list.txt"
    }
    $list = @()
    $codec = ffprobe -hide_banner -loglevel 16 -of "default=nw=1:nk=1" -select_streams v:0 -show_entries "stream=codec_name" "${output}1.mp4"
    if (-not $codec -match "^h264$") {
        ffmpeg -y -loglevel -8 -i "${output}1.mp4" -c:v h264_nvenc -qmax 18 -qmin 18 -c:a copy "${output}.mp4"
    } else {
        Rename-Item "${output}1.mp4" "${output}.mp4"
    }
    "${output}.mp4 saved successfully`n enter to continue"
    Read-Host
}