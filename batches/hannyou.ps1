$ErrorActionPreference = 'SilentlyContinue'

# 編集可能な変数
[string]$defaultfolder = "$PSScriptRoot" # デフォルト: $PSScriptRoot
[string]$formatselector = "bv+ba/best" # デフォルト: "bv+ba/best"
[string]$thumbnailextension = "png" # デフォルト: "png" 使用可能な拡張子: png,jpg,ewbp
[string]$vencodesetting = "-vcodec h264_nvenc -qp 18" # デフォルト: "-vcodec libx264 -crf 21" フィルターをかけるので"-vcodec copy"は使えない
[string]$aencodesetting = "-acodec aac -aq 1" # デフォルト: "-acodec aac -q:a 1" デフォルトではあえて再エンコードするように書いているが、できるなら"-acodec copy"が良い
[string]$outputextension = "mp4" # デフォルト: "mp4" デフォルトがmp4向けのエンコード設定のため。ただし上のエンコード設定によっては変える必要あり、あとここで編集させているのはすぐ上にエンコード設定があるから。使用可能な拡張子: avi, flv, gif, mkv, mov, mp4, webm, aac, aiff, alac, flac, m4a, mka, mp3, ogg, opus, vorbis, wav
<#
目的別いろんなエンコードメモ
再生できればいいからとにかく容量を小さくしたい場合
hevc+Opus,mkv Container(環境によるかも)
[string]$vencodesetting = "-vcodec libx265 -qp 18"
[string]$aencodesetting = "-acodec libopus -b:a 96k"
[string]$outputextension = "mkv"

互換性が欲しい場合
h264+aac, mp4 container(伝統的な組み合わせで大抵のデバイスで再生可能)
[string]$vencodesetting = "-vcodec libx264 -qp 18"
[string]$aencodesetting = "-acodec aac -q:a 1"
[string]$outputextension = "mp4"
VP9+Opus, webm container(YouTubeでも使われてる)
[string]$vencodesetting = "-vcodec libvpx-vp9"
[string]$aencodesetting = "-acodec libopus -b:a 96k"
[string]$outputextension = "webm"

可逆圧縮したい場合
h264(lossless)+alac, mp4 container(mp4で可逆圧縮したい場合。flacはmp4コンテナに入らない)
[string]$vencodesetting = "-vcodec libx264 -qp 0"
[string]$aencodesetting = "-acodec flac"
[string]$outputextension = "mp4"
utvideo+flac, mkv container (ファイルサイズがでかくなる)
[string]$vencodesetting = "-vcodec utvideo"
[string]$aencodesetting = "-acodec flac"
[string]$outputextension = "mkv"
ffv1+flac, mkv container(ファイルの保存に一番向いている)
[string]$vencodesetting = "-vcodec ffv1 -level 3"
[string]$aencodesetting = "-acodec flac"
[string]$outputextension = "mkv"
VP9(lissless)+Opus(非可逆圧縮だがWebm側が可逆圧縮の音声コーデックをサポートしていない), webm container(エンコードがめちゃ遅い)
[string]$vencodesetting = "-vcodec libvpx-vp9 -lossless 1"
[string]$aencodesetting = "-acodec libopus 
 128k"
[string]$outputextension = "webm"
#>

# 編集不可能な変数
[string]$logtext = ""
[string]$url = ""
[string]$startat = ""
[string]$endat = ""
[uint]$starttime = 0
[uint]$endtime = 0
[string]$thumbnailselector = ""
[string]$cookies = ""
[string]$outputfilename = ""
[string]$files = ""
[string]$guid = (New-Guid).Guid
[System.Object]$processlength = $null
[int]$hour = 0
[int]$minute = 0
[int]$second = 0
[int]$millisecond = 0

# メイン処理
Set-Location $defaultfolder
yt-dlp --version | Out-Null
if (-not $?) {
    "yt-dlpが使用できません`nEnterで終了"
    Read-Host
    exit
}
ffmpeg -version | Out-Null
if (-not $?) {
    "ffmpegが使用できません`nEnterで終了"
    Read-Host
    exit
}
if ($thumbnailextension -notmatch "^(jpg|png|webp)$") {
    "`$thumbnailextensionの値が不正です`nEnterで終了"
    Read-Host
    exit
}
if ($outputextension -notmatch "^(avi|flv|gif|mkv|mov|mp4|webm|ogv|asf|aac|aiff|alac|flac|m4a|mka|mp3|ogg|opus|vorbis|wav)$") {
    "`$outputextensionの値が不正です`nEnterで終了"
    Read-Host
    exit
}
$logtext += "動画エンコード設定`n${vencodesetting}`n音声エンコード設定`n${aencodesetting}`n出力ファイル拡張子`n${outputextension}`nサムネイル拡張子`n${thumbnailextension}`nURL"
do {
    Clear-Host
    $url = Read-Host -Prompt $logtext
    yt-dlp -q -F "${url}" | Out-Null
} until ($?)
if ((yt-dlp -F "${url}"| Where-Object {$_ -match "^\[info\]"}).Count -eq 1) {
    $logtext += ": ${url}`n開始時間(秒(.ミリ秒)または((時間:)分:)秒(.ミリ秒)表記、0で最初を指定、-1で次をスキップし、最初から最後までダウンロード)"
    do {
        Clear-Host
        $startat = Read-Host -Prompt $logtext
    } until ($startat -match "^(0+(\.0*)?|-0*1(\.0*)?|\d+(\.\d{1,3})?|((\d+:)?[0-5]?\d:)?([0-5]?\d|\d)(\.\d{1,3})?)$")
    $logtext += ": ${startat}`n"
    if ($startat -match "^-1$") {
        $startat = "0"
        $endat = "inf"
    } else {
        if ($startat -match "^((?<second>\d+)(\.(?<millisecond>\d{1,3}))?|(((?<hour>\d+):)?(?<minute>[0-5]?\d):)?(?<second>[0-5]?\d)(\.(?<millisecond>\d{1,3}))?)$") {
            $hour = [int]$Matches.hour
            $minute = [int]$Matches.minute
            $second = [int]$Matches.second
            $millisecond = if ([int]$Matches.millisecond) {[int]($Matches.millisecond).PadRight(3,"0")} else {0}
            $starttime = $hour * 3600000 + $minute * 60000 + $second * 1000 + $millisecond
        }
        $logtext += "終了時間(秒(.ミリ秒)または((時間:)分:)秒(.ミリ秒)表記、-1またはinfで最後までダウンロード)"
        do {
            do {
                Clear-Host
                $endat = Read-Host -Prompt "$logtext"
            } until ($endat -match "^(-0*1(\.0*)?|inf|\d+(\.\d{1,3})?|((\d+:)?[0-5]?\d:)?[0-5]?\d(\.\d{1,3})?)$")
            if ($endat -match "^((?<second>\d+)(\.(?<millisecond>\d{1,3}))?|(((?<hour>\d+):)?(?<minute>[0-5]?\d):)?(?<second>[0-5]?\d)(\.(?<millisecond>\d{1,3}))?)$") {
                $hour = [int]$Matches.hour
                $minute = [int]$Matches.minute
                $second = [int]$Matches.second
                $millisecond = if ([int]$Matches.millisecond) {[int]($Matches.millisecond).PadRight(3,"0")} else {0}
                $endtime = $hour * 3600000 + $minute * 60000 + $second * 1000 + $millisecond
            } else {
                $endat = "inf"
            }
        } until ($endat -cmatch "^inf$" -or $endtime -gt $starttime)
        $logtext += ": ${endat}`n"
    }
} else {
    $startat = "0"
    $endat = "inf"
}
$logtext += "サムネイルの処理、0=ダウンロードしない、1=動画とは別にダウンロード、2=動画へ埋め込む(画像は保存しない)、3=埋め込みと画像で保存"
do {
    Clear-Host
    $thumbnailselector = Read-Host -Prompt $logtext
} until ($thumbnailselector -match "^[0-3]$")
$logtext += ": ${thumbnailselector}`n出力ファイル名(拡張子なし)"
do {
    Clear-Host
    $outputfilename = Read-Host -Prompt $logtext
} until ($outputfilename -notmatch "[\u0020\u0022\u002a\u002f\u003a\u003c\u003e\u003f\u005c\u007c\u3000]" -and (Get-ChildItem -Name -File | Where-Object {$_ -cmatch "^${outputfilename}(1|_\d{3})?\.(${outputextension}|${thumbnailextension})$"}).Count -eq 0)
Clear-Host
Write-Host -Object "${logtext}: ${outputfilename}"
if (Test-Path -Path ".\cookies.txt") {
    Write-Host -Object "cookies.txtを使用します"
    $cookies = "--cookies 
    cookies.txt"
} else {
    Write-Host -Object "cookies.txtが見つかりません"
    $cookies = "--no-cookies"
}
$processlength = Measure-Command -Expression {
    Write-Host -Object "(yt-dlp)動画ダウンロード中"
    yt-dlp --quiet --progress --download-sections "*${startat}-${endat}" $cookies --format "${formatselector}" --downloader-args "ffmpeg_i:-loglevel quiet" --downloader-args "ffmpeg_o:${vencodesetting} ${aencodesetting} -f matroska" --remux-video $outputextension --output "${outputfilename}_%(autonumber)03d.%(ext)s" --retries infinite $url
    if ((Get-ChildItem -Name | Where-Object {$_ -match "${outputfilename}_\d{3}\.$outputextension$"}).Count - 1) {
        Get-ChildItem -Name | Where-Object {$_ -match "${outputfilename}_\d{3}\.$outputextension$"} | ForEach-Object {$files += "file ${_}`n"}
        New-Item -Path ".\${guid}.txt" -ItemType File -Value $files
        Write-Host -Object "(ffmpeg)動画を結合中"
        ffmpeg -hide_banner -loglevel -8 -f concat -i "${guid}.txt" -c copy "${outputfilename}1.${outputextension}"
        Get-ChildItem -Name | Where-Object {$_ -match "${outputfilename}_\d{3}\.$outputextension$"} | ForEach-Object {Remove-Item $_}
        Remove-Item ".\${guid}.txt"
    } else {
        Rename-Item "$(Get-ChildItem -Name | Where-Object {$_ -match "${outputfilename}_001\.$outputextension$"})" "${outputfilename}1.${outputextension}"
    }
    if ([int]$thumbnailselector) {
        Write-Host -Object "(yt-dlp)サムネイルダウンロード中"
        yt-dlp --quiet --max-downloads 1 --skip-download --write-thumbnail --convert-thumbnails $thumbnailextension $cookies --output "${outputfilename}.%(ext)s" $url
        if ([int]$thumbnailselector - 1) {
            ffmpeg -hide_banner -loglevel -8 -i "${outputfilename}1.${outputextension}" -i "${outputfilename}.${thumbnailextension}" -map 0 -map 1 -c copy -disposition:v:1 attached_pic "${outputfilename}.${outputextension}"
            Remove-Item "${outputfilename}1.${outputextension}"
            if ([int]$thumbnailselector -eq 2) {
                Remove-Item "${outputfilename}.${thumbnailextension}"
            }
        } else {
            Rename-Item "${outputfilename}1.${outputextension}" "${outputfilename}.${outputextension}"
        }
    } else {
        Rename-Item "${outputfilename}1.${outputextension}" "${outputfilename}.${outputextension}"
    }
}
"ダウンロードにかかった時間: $((($processlength.Hours).ToString()).PadLeft(2,'0')):$((($processlength.Minutes).ToString()).PadLeft(2,'0')):$((($processlength.Seconds).ToString()).PadLeft(2,'0')).$((($processlength.Milliseconds).ToString()).PadLeft(3,'0'))`nCtrl+CかAlt+F4で終了"
while (1) {
    Read-Host
}