chcp 65001

Set-Location $PSScriptRoot

[array]$list=@()
[string]$codec=""
[string]$output=""
[string]$url=""

if ($args[0] -ne "") {
    $output = $args[0]+"_%(autonumber)d.%(ext)s"
}
if ($args[1] -ne "") {
    $url = $args[1]
}

yt-dlp -q --progress --force-overwrites -f "bv[ext=mp4]+ba[ext=m4a]/bv+ba/best" -o "${output}" -R infinite "${url}"
$list = Get-ChildItem -Name | Where-Object {$_ -match "${output}_\d+\.[^\.]+"}
if ($list.Count -ge 2) {
} else {
    $list | ForEach-Object {"file ""$_""" | Out-File "list.txt" -Append -Encoding utf8NoBOM}
    ffmpeg -y -loglevel -8 -f concat -i "list.txt" -c:v h264_nvenc -qmax 18 -qmin 18 "${output}1.mp4"
    $list | ForEach-Object {Remove-Item $_}
    "deleting list.txt"
    do {
        Remove-Item "list.txt"
    } until ($?)
}
$list = @()
$codec = ffprobe -hide_banner -loglevel 16 -of "default=nw=1:nk=1" -select_streams v:0 -show_entries "stream=codec_name" "${output}1.mp4"
if (-not $codec -match "^h264$") {
    "transcoding to h264"
    ffmpeg -y -loglevel -8 -i "${output}1.mp4" -c:v h264_nvenc -qmax 18 -qmin 18 -c:a copy "${output}.mp4"
} else {
    Rename-Item "${output}1.mp4" "${output}.mp4"
}
yt-dlp -q --force-overwrites --skip-download --write-thumbnail --convert-thumbnails png -o "${output}.png" -R infinite "${url}"
