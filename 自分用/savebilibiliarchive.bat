@echo off

chcp 65001

cls

echo このバッチファイルはbilibili動画、サムネイルとそれに付随するダウンロード時点のメタデータ(json)をダウンロードし、zipにまとめます。

echo (任意)バッチファイルと同じフォルダにbilibiliにログインしたcookies.txtがあると高画質でダウンロードできます。

echo バッチ実行前にcookies.txtを更新しておくことをおすすめします。

echo 確認済みの動作環境

echo Windows 11 Home 23H2

echo FFmpeg 7.1 from winget install Gyan.FFmpeg

echo yt-dlp-nightly@2024.10.07.232845 from winget install yt-dlp.yt-dlp.nightly

echo Microsoft PowerShell 5.1.22621.4249 built-in

echo 7-Zip 24.08 from winget install 7zip.7zip

echo Get cookies.txt LOCALLY from Chrome Web Store ^(https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc^)

echo 環境変数path %LOCALAPPDATA%\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-7.1-full_build\bin^(ffmpegインストール時に登録される^)

echo %LOCALAPPDATA%\Microsoft\WinGet\Packages\yt-dlp.yt-dlp.nightly_Microsoft.Winget.Source_8wekyb3d8bbwe^(yt-dlpインストール時に登録される^)

echo C^:\Program Files\7-Zip^(インストールだけでは環境変数に登録されないので自分で環境変数Pathに登録するか113行目の7zをフルパス^(^"C:\Program Files\7-Zip\7z^"^)にする^)

echo.

echo URLを入力

echo ^&は使用しないでください。なんなら^&以降は消してください。

echo 使用可能なURLの例

echo https^://www.bilibili.com/video/BVid

echo https^://www.bilibili.com/video/avid

echo 動画ページにリンクする短縮リンクも使用可能

echo https://b23.tv/randomid

echo https://x.gd/A0JKD

echo.

set /p url=

echo.

echo 出力ファイル名^(拡張子なし^)

echo 実行後^(入力ファイル名^).zipという名前のファイルが生成されます。

echo 既にファイル名.zipが存在している場合は上書きされます。

echo ファイル名に使用できない文字^(\/:*?"<>|^)を入力しないでください。

echo.

set /p output=

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo 既存の%output%.zipを削除中^(1/9^)

del %output%.zip> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダを削除中^(2/9^)

del /q %output%\*> nul

rmdir /q %output%> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo 実行準備中^(3/9^)

winget upgrade ffmpeg> nul

winget upgrade --id yt-dlp.yt-dlp> nul

winget upgrade --id yt-dlp.yt-dlp.nightly> nul

winget upgrade --id 7zip.7zip> nul

winget upgrade --id 7zip.7zip.Alpha.exe> nul

winget upgrade --id 7zip.7zip.Alpha.msi> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo 実行準備完了^(3/9^)

echo 動画ダウンロード中^(4/9^)

mkdir %output%

yt-dlp -q --progress --cookies cookies.txt -f "bv+ba/best" --recode-video mp4 --write-info-json -o "%output%_%%(autonumber)04d.%%(ext)s" %url% 

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo 実行準備完了^(3/9^)

echo 動画ダウンロード完了^(4/9^)

echo サムネイルダウンロード中^(5/9^)

yt-dlp -q --progress -w --skip-download --write-thumbnail -o "a\%output%.%%(ext)s" %url% 

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo 実行準備完了^(3/9^)

echo 動画ダウンロード完了^(4/9^)

echo サムネイルダウンロード完了^(5/9^)

echo 動画の処理中^(6/9^)

dir /b %output%*.mp4>%output%.txt

for /f "delims=" %%a in (%output%.txt) do (echo file %%a>>%output%2.txt)

ffmpeg -loglevel -8 -f concat -i %output%2.txt -c copy a\%output%.mp4

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo 実行準備完了^(3/9^)

echo 動画ダウンロード完了^(4/9^)

echo サムネイルダウンロード完了^(5/9^)

echo 動画処理完了^(6/9^)

echo jsonファイル処理中^(7/9^)

dir /b %output%*.json>%output%1.txt

for /f "delims=" %%b in (%output%1.txt) do (type %%b>>%output%.json& echo.>>%output%.json)

powershell -Command "Get-Content %output%.json -Encoding UTF8 | ForEach-Object { [System.Net.WebUtility]::HtmlDecode($_) } | Out-File a\%output%.json"> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo 実行準備完了^(3/9^)

echo 動画ダウンロード完了^(4/9^)

echo サムネイルダウンロード完了^(5/9^)

echo 動画処理完了^(6/9^)

echo jsonファイル処理完了^(7/9^)

echo zip作成中^(8/9^)

cd %output%

7z a %output%.zip *> nul

move %output%.zip ..> nul

cd ..

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo 実行準備完了^(3/9^)

echo 動画ダウンロード完了^(4/9^)

echo サムネイルダウンロード完了^(5/9^)

echo 動画処理完了^(6/9^)

echo jsonファイル処理完了^(7/9^)

echo zip作成完了^(8/9^)

echo 不要なファイルを削除中^(9/9^)

del /q %output%*> nul

del /q %output%\*> nul

rmdir %output%> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo 実行準備完了^(3/9^)

echo 動画ダウンロード完了^(4/9^)

echo サムネイルダウンロード完了^(5/9^)

echo 動画処理完了^(6/9^)

echo jsonファイル処理完了^(7/9^)

echo zip作成完了^(8/9^)

echo 不要なファイルの削除完了^(9/9^)

echo 実行完了。10秒後に自動で終了します。

timeout /t 10 /nobreak> nul
