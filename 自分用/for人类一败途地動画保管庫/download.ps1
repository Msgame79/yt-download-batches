chcp 65001
$ErrorActionPreference = 'SilentlyContinue'
Clear-Host
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
            $guid = (New-Guid).Guid
            New-Item -ItemType Directory "$($num)" | Out-Null
            Start-Process "yt-dlp" "--force-overwrite --quiet --progress --format ""bv[vcodec*=avc]+ba"" -R infinite -o ""$($num)\$($args[0])_%(autonumber)03d.mp4"" https://www.bilibili.com/video/$($bv)" -Wait -NoNewWindow
            #Start-Process "yt-dlp" "--force-overwrite --quiet --progress --format ""bv[vcodec*=avc]+ba"" -R infinite --cookies cookies.txt -o ""$($num)\$($args[0])_%(autonumber)03d.mp4"" https://www.bilibili.com/video/$($bv)" -Wait -NoNewWindow # use this line if you use cookies
            Get-ChildItem -Name "$($num)" | ForEach-Object {"file $($_)" | Out-File "$($num)\$($guid).txt" -Append}
            Start-Process "ffmpeg" "-loglevel -8 -f concat -i ""$($num)\$($guid).txt"" -c copy $($num)\$($args[0]).mp4" -Wait -NoNewWindow
            Get-ChildItem -Name "$($num)" | Where-Object {$_ -ne "output$($num).mp4"} | ForEach-Object {Remove-Item "$($num)\$($_)"}
            Start-Process "yt-dlp" "--quiet --max-downloads 1 --skip-download --write-thumbnail --convert-thumbnails png -R infinite -o ""$($num)\$($args[0]).%(ext)s"" https://www.bilibili.com/video/$($bv)" -Wait -NoNewWindow
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