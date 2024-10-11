@echo off

chcp 65001

:loop

cls

echo このバッチファイルはbilibili動画、サムネイルとそれに付随するダウンロード時点のメタデータ^(json^)をダウンロードし、zipにまとめます。

echo ^(任意^)バッチファイルと同じフォルダにbilibiliにログインしたcookies.txtがあると高画質でダウンロードできます。

echo バッチ実行前にcookies.txtを更新しておくことをおすすめします。

echo 確認済みの動作環境

echo Windows 11 Home 23H2

echo winget built-in

echo FFmpeg 7.1 from winget install Gyan.FFmpeg

echo yt-dlp-nightly@2024.10.07.232845 from winget install yt-dlp.yt-dlp.nightly

echo Microsoft PowerShell 5.1.22621.4249 built-in

echo 7-Zip 24.08 from winget install 7zip.7zip

echo Get cookies.txt LOCALLY from Chrome Web Store ^(https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc^)

echo 環境変数path %LOCALAPPDATA%\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-7.1-full_build\bin^(ffmpegインストール時に登録される^)

echo %LOCALAPPDATA%\Microsoft\WinGet\Packages\yt-dlp.yt-dlp.nightly_Microsoft.Winget.Source_8wekyb3d8bbwe^(yt-dlpインストール時に登録される^)

echo C^:\Program Files\7-Zip^(インストールだけでは環境変数に登録されないので自分で環境変数Pathに登録するか113行目の7zをフルパス^(^"C:\Program Files\7-Zip\7z^"^)にする^)

echo.

set /p install=動作環境をセットアップまたはソフトウェアを更新しますか?^(yY/nN^)セットアップ後、バッチファイルは1度終了します。

if /i "%install%"=="y" (

winget uninstall yt-dlp.yt-dlp.nightly

winget uninstall ffmpeg

winget uninstall 7zip.7zip

winget install yt-dlp.yt-dlp.nightly

winget install 7zip.7zip

echo 実行完了。10秒後に自動で終了します。7-zipについては自分で環境変数を登録してください。

timeout /t 10 /nobreak> nul

goto end

) else if /i "%install%"=="n" (

goto ahead

) else (

goto loop

)

:ahead

:loop1

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

if not defined url (

cls

echo このバッチファイルはbilibili動画、サムネイルとそれに付随するダウンロード時点のメタデータ^(json^)をダウンロードし、zipにまとめます。

echo ^(任意^)バッチファイルと同じフォルダにbilibiliにログインしたcookies.txtがあると高画質でダウンロードできます。

echo バッチ実行前にcookies.txtを更新しておくことをおすすめします。

echo 確認済みの動作環境

echo Windows 11 Home 23H2

echo winget built-in

echo FFmpeg 7.1 from winget install Gyan.FFmpeg

echo yt-dlp-nightly@2024.10.07.232845 from winget install yt-dlp.yt-dlp.nightly

echo Microsoft PowerShell 5.1.22621.4249 built-in

echo 7-Zip 24.08 from winget install 7zip.7zip

echo Get cookies.txt LOCALLY from Chrome Web Store ^(https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc^)

echo 環境変数path %LOCALAPPDATA%\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-7.1-full_build\bin^(ffmpegインストール時に登録される^)

echo %LOCALAPPDATA%\Microsoft\WinGet\Packages\yt-dlp.yt-dlp.nightly_Microsoft.Winget.Source_8wekyb3d8bbwe^(yt-dlpインストール時に登録される^)

echo C^:\Program Files\7-Zip^(インストールだけでは環境変数に登録されないので自分で環境変数Pathに登録するか113行目の7zをフルパス^(^"C:\Program Files\7-Zip\7z^"^)にする^)

echo.

echo 動作環境をセットアップまたはソフトウェアを更新しますか?^(yY/nN^)セットアップ後、バッチファイルは1度終了します。%install%

goto loop1

)

:loop2

echo.

echo 出力ファイル名^(拡張子なし^)

echo 実行後^(入力ファイル名^).zipという名前のファイルが生成されます。

echo 既にファイル名.zipが存在している場合は上書きされます。

echo ファイル名に使用できない文字^(\/:*?"<>|^)を入力しないでください。

echo.

set /p output=

if not defined output (

cls

echo このバッチファイルはbilibili動画、サムネイルとそれに付随するダウンロード時点のメタデータ^(json^)をダウンロードし、zipにまとめます。

echo ^(任意^)バッチファイルと同じフォルダにbilibiliにログインしたcookies.txtがあると高画質でダウンロードできます。

echo バッチ実行前にcookies.txtを更新しておくことをおすすめします。

echo 確認済みの動作環境

echo Windows 11 Home 23H2

echo winget built-in

echo FFmpeg 7.1 from winget install Gyan.FFmpeg

echo yt-dlp-nightly@2024.10.07.232845 from winget install yt-dlp.yt-dlp.nightly

echo Microsoft PowerShell 5.1.22621.4249 built-in

echo 7-Zip 24.08 from winget install 7zip.7zip

echo Get cookies.txt LOCALLY from Chrome Web Store ^(https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc^)

echo 環境変数path %LOCALAPPDATA%\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-7.1-full_build\bin^(ffmpegインストール時に登録される^)

echo %LOCALAPPDATA%\Microsoft\WinGet\Packages\yt-dlp.yt-dlp.nightly_Microsoft.Winget.Source_8wekyb3d8bbwe^(yt-dlpインストール時に登録される^)

echo C^:\Program Files\7-Zip^(インストールだけでは環境変数に登録されないので自分で環境変数Pathに登録するか113行目の7zをフルパス^(^"C:\Program Files\7-Zip\7z^"^)にする^)

echo.

echo 動作環境をセットアップまたはソフトウェアを更新しますか?^(yY/nN^)セットアップ後、バッチファイルは1度終了します。%install%

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

echo %url%

goto loop2

)

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除^(1/9^)

del /q %output%.zip> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除^(2/9^)

del /q %output%\%output%\*> nul

rmdir /q %output%\%output%> nul

del /q %output%\*> nul

rmdir /q %output%> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo %output%フォルダ作成^(3/9^)

mkdir %output%

mkdir %output%\%output%

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo %output%フォルダ作成完了^(3/9^)

echo 動画とjsonファイルのダウンロード^(4/9^)

echo Downloaded at %date% %time: =0%>%output%\%output%\%output%.json

echo.>>%output%\%output%\%output%.json

if exist "cookies.txt" (

yt-dlp -q --progress --cookies cookies.txt -f "bv+ba/best" --recode-video mp4 --write-info-json -o "%output%\%output%_%%(autonumber)04d.%%(ext)s" %url%

) else (

yt-dlp -q --progress -f "bv+ba/best" --recode-video mp4 --write-info-json -o "%output%\%output%_%%(autonumber)04d.%%(ext)s" %url%

)


echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo %output%フォルダ作成完了^(3/9^)

echo 動画とjsonファイルのダウンロード完了^(4/9^)

echo サムネイルのダウンロード^(5/9^)

yt-dlp -q -w --skip-download --write-thumbnail -o "%output%\%output%\%output%.%%(ext)s" %url% 

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo %output%フォルダ作成完了^(3/9^)

echo 動画とjsonファイルのダウンロード完了^(4/9^)

echo サムネイルのダウンロード完了^(5/9^)

echo 動画の処理^(6/9^)

cd %output%> nul

dir /b *.mp4>%output%.txt

for /f "delims=" %%a in (%output%.txt) do (echo file %%a>>%output%1.txt)

ffmpeg -loglevel -8 -f concat -i %output%1.txt -c copy %output%\%output%.mp4

cd %~DP0> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo %output%フォルダ作成完了^(3/9^)

echo 動画とjsonファイルのダウンロード完了^(4/9^)

echo サムネイルのダウンロード完了^(5/9^)

echo 動画の処理完了^(6/9^)

echo jsonファイルの処理^(7/9^)

dir /b %output%\%output%_*.json>%output%\%output%2.txt> nul

for /f "delims=" %%b in (%output%\%output%2.txt) do (type %output%\%%b nul>>%output%\%output%.json)> nul

powershell -Command "Get-Content %output%\%output%.json -Encoding UTF8 | ForEach-Object { [System.Net.WebUtility]::HtmlDecode($_) } | Out-File %output%\%output%\%output%.json -encoding UTF8 -Append"> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo %output%フォルダ作成完了^(3/9^)

echo 動画とjsonファイルのダウンロード完了^(4/9^)

echo サムネイルのダウンロード完了^(5/9^)

echo 動画の処理完了^(6/9^)

echo jsonファイルの処理完了^(7/9^)

echo %output%.zipの作成^(8/9^)

cd %output%\%output%> nul

7z a %output%.zip *> nul

move %output%.zip %~DP0> nul

cd %~DP0> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo %output%フォルダ作成完了^(3/9^)

echo 動画とjsonファイルのダウンロード完了^(4/9^)

echo サムネイルのダウンロード完了^(5/9^)

echo 動画の処理完了^(6/9^)

echo jsonファイルの処理完了^(7/9^)

echo %output%.zipの作成完了^(8/9^)

echo %output%フォルダの削除^(9/9^)

del /q %output%\%output%\*> nul

rmdir /q %output%\%output%> nul

del /q %output%\*> nul

rmdir /q %output%> nul

cls

echo プレビュー

echo URL^: %url%

echo 出力ファイル名^: %output%.zip

echo.

echo %output%.zip削除完了^(1/9^)

echo %output%フォルダ削除完了^(2/9^)

echo %output%フォルダ作成完了^(3/9^)

echo 動画とjsonファイルのダウンロード完了^(4/9^)

echo サムネイルのダウンロード完了^(5/9^)

echo 動画の処理完了^(6/9^)

echo jsonファイルの処理完了^(7/9^)

echo %output%.zipの作成完了^(8/9^)

echo %output%フォルダの削除完了^(9/9^)

echo 実行完了。10秒後に自動で終了します。

timeout /t 10 /nobreak> nul

:end
