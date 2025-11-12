chcp 65001
$ErrorActionPreference = 'SilentlyContinue'
# Needs 2 arguments
if (($args).Count -eq 2)
{
    if ($args[0] -match "^output([1-9]\d*)$")
    {
        $num = $Matches.1
        if ($args[1] -match "^((http(s)?://)?((www|m)\.)?bilibili\.com/video/)?(BV[0-9a-zA-Z]+)`$")
        {
            $bv = $Matches.6
            yt-dlp --version | Out-Null
            if (-not $?)
            {
                "yt-dlp is unavailable(0x4)`nyt-dlp`nhttps://github.com/yt-dlp/yt-dlp"
                exit(4)
            }
            ffmpeg -version | Out-Null
            if (-not $?)
            {
                "ffmpeg is unavailable(0x5)`nffmpeg`nhttps://www.gyan.dev/ffmpeg/builds/"
                exit(5)
            }
            if (-not (Test-Path ".\cookies.txt"))
            {
                "cookies.txt not found(0x6)`nGet cookies.txt LOCALLY`nhttps://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc"
                exit(6)
            }
            if (Test-Path ".\$($num)")
            {
                "Directory $($num) recreated"
                do
                {
                    Remove-Item "$($num)" -Recurse
                }
                until
                (
                    -not (Test-Path "$($num)")
                )
            }
            "When it's stuck, press Ctrl+C"
            New-Item -ItemType Directory "$($num)" | Out-Null
            Start-Process "yt-dlp" "--force-overwrite --quiet --progress --format ""bv+ba"" -R infinite --cookies cookies.txt -o ""$($num)\$($args[0])_%(autonumber)03d.mp4"" https://www.bilibili.com/video/$($bv)" -Wait -NoNewWindow
            $ins = ""
            $ins1 = ""
            $ins2 = ""
            $scales = @()
            $a = 0
            Get-ChildItem -Name "$($num)" | ForEach-Object {
                $ins += "-i ""${num}\${_}"" "
                $ins1 += "[${a}:v]scale=s=hd1080[v$($a+1)];"
                $a++
                $ins2 += "[v$a][$($a-1):a]"
                $scales += "($(ffprobe -hide_banner -i "$num\$_" -loglevel 0 -select_streams v -of "default=nw=1:nk=1" -show_entries "stream=coded_width")x$(ffprobe -hide_banner -i "$num\$_" -loglevel 0 -select_streams v -of "default=nw=1:nk=1" -show_entries "stream=coded_height"))"
            }
            Start-Process "ffmpeg" "-loglevel -8 ${ins}-filter_complex ""${ins1}${ins2}concat=n=${a}:v=1:a=1[v][a]"" -map ""[v]"" -map ""[a]"" -c:v h264_nvenc -qp 21 -c:a aac -b:a 192k $($num)\$($args[0]).mp4" -Wait -NoNewWindow
            Get-ChildItem -Name "$($num)" | Where-Object {$_ -ne "output$($num).mp4"} | ForEach-Object {Remove-Item "$($num)\$($_)"}
            Start-Process "yt-dlp" "--quiet --max-downloads 1 --skip-download --write-thumbnail --convert-thumbnails png -R infinite -o ""$($num)\$($args[0]).%(ext)s"" https://www.bilibili.com/video/$($bv)" -Wait -NoNewWindow
            Start-Process "yt-dlp" "--quiet --max-downloads 1 --skip-download --write-thumbnail --convert-thumbnails jpg -R infinite -o ""$($num)\$($args[0]).%(ext)s"" https://www.bilibili.com/video/$($bv)" -Wait -NoNewWindow
            "Download completed"
            $scales | ForEach-Object {
                "$_"
            }
            "Exiting with code 0"
            exit(0)
        }
        else
        {
            "`$args[1] ""$($args[1])"" does not match RegEx ""^((http(s)?://)?((www|m)\.)?bilibili\.com/video/)?BV[0-9a-zA-Z]+`$""(0x3)"
            exit(3)
        }
    }
    else
    {
        "`$args[0] ""$($args[0])"" does not match RegEx ""^output[1-9]\d*`$""(0x2)"
        exit(2)
    }
}
else
{
    "Invalid arguments(0x1)"
    exit(1)
}
Get-ChildItem -Recurse -Name | Where-Object {$_ -match "\.mp4$"} | ForEach-Object {
    "$_"
    ffprobe -hide_banner -i $_ -loglevel 0 -select_streams v -of "default=nw=1:nk=1" -show_entries "stream=coded_height"
}