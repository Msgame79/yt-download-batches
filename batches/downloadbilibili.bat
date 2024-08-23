@echo off
chcp 65001
echo This can download bilibili videos. Premium/Normal member can download 1080p60/4K,720p60 with a cookie file generated from Get cookies.txt LOCALLY (https://x.gd/G3xMs). 
set /P url=Video URL 
set /P output=Output file name without extension 
:loop
set /P cookie=Download HQ video using cookies(y/n)
set t=%%(autonumber)s
set outputs=%output%_%t% 
if %cookie%==y (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https][vcodec*=avc]+bestaudio[ext=m4a][protocol=https]" --cookies cookies.txt -o "%outputs%.mp4" %url%
) else if %cookie%==Y (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https][vcodec*=avc]+bestaudio[ext=m4a][protocol=https]" --cookies cookies.txt -o "%outputs%.mp4" %url%
) else if %cookie%==n (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https][vcodec*=avc]+bestaudio[ext=m4a][protocol=https]" -o "%outputs%.mp4" %url%
) else if %cookie%==N (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https][vcodec*=avc]+bestaudio[ext=m4a][protocol=https]" -o "%outputs%.mp4" %url%
) else (
goto loop
)
dir /b %output%*>list.txt
for /f %%a in (list.txt) do (echo file %%a>>list1.txt)
mkdir a
ffmpeg -f concat -i list1.txt -c copy a\%output%.mp4
del %output%*.mp4
del list.txt
del list1.txt
move a\%output%.mp4 .
rmdir /q a