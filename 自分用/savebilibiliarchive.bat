@echo off

chcp 65001

cls

echo このバッチファイルはbilibili動画、サムネイルとそれに付随するダウンロード時点のメタデータ(json)をダウンロードし、zipにまとめます。

echo (任意)バッチファイルと同じフォルダにbilibiliにログインしたcookies.txtがあると高画質でダウンロードできます。

echo 確認済みの動作環境

echo Windows 11 Home 23H2

echo FFmpeg 7.1 from winget

echo yt-dlp-nightly@2024.10.07.232845 from winget

echo Microsoft PowerShell 5.1.22621.4249 built-in

echo 7-Zip 24.08 from winget

echo Get cookies.txt LOCALLY from Chrome Web Store ^(https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc^)

echo 環境変数path %LOCALAPPDATA%\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-7.1-full_build\bin

echo %LOCALAPPDATA%\Microsoft\WinGet\Packages\yt-dlp.yt-dlp.nightly_Microsoft.Winget.Source_8wekyb3d8bbwe

echo C^:\Program Files\7-Zip^(システム環境変数のpathに登録^)

echo.

echo URLを入力

echo ^&は使用しないでください。なんなら^&以降は消してください

echo 使用可能なURLの例

echo https^://www.bilibili.com/video/BVid

echo https^://www.bilibili.com/video/avid

echo 動画ページにリンクする短縮リンクも使用可能

echo https://b23.tv/randomid

echo https://x.gd/A0JKD

echo.

set /p url=

echo.

echo 出力ファイル名

echo 実行後^(入力ファイル名^).zipという名前のファイルが生成されます

echo ファイル名に使用できない文字^(\/:*?"<>|^)を入力しないでください

echo.

set /p output=

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

del %output%.zip

winget upgrade ffmpeg

winget upgrade --id yt-dlp.yt-dlp

winget upgrade --id yt-dlp.yt-dlp.nightly

winget upgrade --id 7zip.7zip

winget upgrade --id 7zip.7zip.Alpha.exe

winget upgrade --id 7zip.7zip.Alpha.msi

mkdir a

yt-dlp -q --progress --cookies cookies.txt -f "bv+ba/best" --recode-video mp4 --write-info-json -o "%output%_%%(autonumber)04d.%%(ext)s" %url% 

yt-dlp -q --progress --skip-download --write-thumbnail --convert-thumbnails png -o "a\%output%.%%(ext)s" %url% 

dir /b %output%*.mp4>%output%.txt

dir /b %output%*.json>%output%1.txt

for /f "delims=" %%a in (%output%.txt) do (echo file %%a>>%output%2.txt)

for /f "delims=" %%b in (%output%1.txt) do (type %%b>>%output%.json)

ffmpeg -loglevel -8 -f concat -i %output%2.txt -c copy a\%output%.mp4 

powershell -Command "Get-Content %output%.json -Encoding UTF8 | ForEach-Object { [System.Net.WebUtility]::HtmlDecode($_) } | Out-File a\%output%.json" 

del /q %output%*

cd a

7z a %output%.zip *

move %output%.zip ..

cd ..

del /q a

rmdir a
