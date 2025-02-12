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
[string]$thumbnailconfirm = "Y"

# check if ffmpeg, ffprobe and yt-dlp are available
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
yt-dlp --version | Out-Null
if (-not $?) {
    "yt-dlp is unabailable`nenter to exit"
    Read-Host
    exit
}

# main area
while ($true) {
    do { # yt-dlpがダウンロードできるURLを書くまで繰り返し
        Clear-Host
        $url = Read-Host -Prompt "URL"
        yt-dlp -F $url | Out-Null
    } until ($?)
    do { # 出力ファイル名を指定(上書きとファイル名に使ってほしくない文字を回避)
        Clear-Host
        "URL: $url"
        $output = Read-Host -Prompt "output filename without extension"
        $len = $output.Length
    } until ($len -ge 1 -and $len -le 255 -and $output -match "[^\u0020\u0022\u002a\u002f\u003a\u003c\u003e\u003f\u005c\u007c\u3000]{$len}" -and -not (Test-Path "$output.mp4"))
    do {
        Clear-Host
        "URL: $url"
        "output filename without extension: $output"
        $thumbnailconfirm = Read-Host -Prompt "Download thumbnail?(yYnN)"
    } until ($thumbnailconfirm -match "^[yYnN]$")
    if (Test-Path -Path "cookies.txt") {
        "I use cookies.txt"
        $cookies = "--cookies ""cookies.txt"""
    } else {
        "I don't use cookies.txt"
        $cookies = "--no-cookies"
    }
    "downloading video"
    yt-dlp -q --progress --force-overwrites -f "bv[ext=mp4]+ba[ext=m4a]/bv+ba/best" $cookies -o "${output}_%(autonumber)d.%(ext)s" -R infinite $url
    if (Test-Path "list.txt") {
        "deleting list.txt"
        do {
            Remove-Item "list.txt"
        } until ($?)
    }
    $list = Get-ChildItem -Name | Where-Object {$_ -match "${output}_\d+\.[^\.]+"}
    if ($list.Count -ge 2) {
        "connecting videos"
        $list | ForEach-Object {"file $_" | Out-File "list.txt" -Append -Encoding utf8NoBOM}
        ffmpeg -y -loglevel -8 -f concat -i "list.txt" -c:v h264_nvenc -qmax 18 -qmin 18 "${output}1.mp4"
        $list | ForEach-Object {Remove-Item $_}
        if (Test-Path "list.txt") {
            "deleting list.txt"
            do {
                Remove-Item "list.txt"
            } until ($?)
        }
    } else {
        Rename-Item "${output}_1.mp4" "${output}1.mp4"
    }
    $list = @()
    $codec = ffprobe -hide_banner -loglevel 16 -of "default=nw=1:nk=1" -select_streams v:0 -show_entries "stream=codec_name" "${output}1.mp4"
    if (-not $codec -match "^h264$") {
        "transcoding to h264"
        ffmpeg -y -loglevel -8 -i "${output}1.mp4" -c:v h264_nvenc -qmax 18 -qmin 18 -c:a copy "${output}.mp4"
    } else {
        Rename-Item "${output}1.mp4" "${output}.mp4"
    }
    if ($thumbnailconfirm -match "[yY]") {
        "downloading thumbnail(${output}.png)"
        yt-dlp -q --force-overwrites --skip-download --write-thumbnail --convert-thumbnails png -o "$output.%(ext)s" $url
        "${output}.mp4 and ${output}.png saved successfully`nenter to restart"
    } else {
        "${output}.mp4 saved successfully`nenter to restart"
    }
    Read-Host
}
