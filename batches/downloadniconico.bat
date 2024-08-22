@echo off
chcp 65001
echo This can download niconico videos. 
set /P url=動画のURLを入力 
set /P output=出力ファイル名を入力(拡張子なし)
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" -o %output%.mp4 %url%