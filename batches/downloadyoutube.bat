@echo off
chcp 65001
echo This can download YouTube videos. 
set /P url=Video URL 
set /P output=Output file name without extension 
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https]+bestaudio[ext=m4a][protocol=https]" -o %output%.mp4 %url%