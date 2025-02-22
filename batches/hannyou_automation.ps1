chcp 65001

Set-Location $PSScriptRoot

[array]$list=@()
[string]$codec=""
[string]$output=""
[string]$url=""

if ($null -ne $args[0]) {
    $output = $args[0]
} else {
    exit
}
if ($null -ne $args[1]) {
    $url = $args[1]
} else {
    exit
}

yt-dlp -q --progress --force-overwrites -f "bv[ext=mp4]+ba[ext=m4a]/bv+ba/best" -o "${output}_%(autonumber)d.%(ext)s" -R infinite "${url}"
if ($?) {
    $list = Get-ChildItem -Name | Where-Object {$_ -match "${output}_\d+\.[^\.]+"}
    if ($list.Count -eq 1) {
        Rename-Item "${output}_1.mp4" "${output}1.mp4"
    } else {
        $list | ForEach-Object {"file ""$_""" | Out-File "list.txt" -Append -Encoding utf8NoBOM}
        ffmpeg -y -loglevel -8 -f concat -i "list.txt" -c:v h264_nvenc -qmax 18 -qmin 18 "${output}1.mp4"
        $list | ForEach-Object {Remove-Item $_}
        do {
            Remove-Item "list.txt"
        } until ($?)
    }
    $codec = ffprobe -hide_banner -loglevel 16 -of "default=nw=1:nk=1" -select_streams v:0 -show_entries "stream=codec_name" "${output}1.mp4"
    if ($codec -match "^h264$") {
        Rename-Item "${output}1.mp4" "${output}.mp4"
    } else {
        ffmpeg -y -loglevel -8 -i "${output}1.mp4" -c:v h264_nvenc -qmax 18 -qmin 18 -c:a copy "${output}.mp4"
        do {
            Remove-Item "${output}1.mp4"
        } until ($?)
    }
    yt-dlp -q --force-overwrites --skip-download --write-thumbnail --convert-thumbnails png -o "${output}" -R infinite "${url}"
    if ((Get-ItemProperty "${output}.png").Length -ge 2097152) {
        ffmpeg -hide_banner -loglevel 0 -y -i "${output}.png" -c mjpeg -q 0 -frames:v 1 "${output}.jpg"

        do {
            Remove-Item "${output}.png"
        } until ($?)
    }
}
