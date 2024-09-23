@echo off

echo This batch can download TikTok videos. Cookies change nothing.

set /P url=Video URL 

set /P output=Output file name without extension 

yt-dlp -U

yt-dlp -f "best[vcodec=h264]" -o %output%.mp4 %url%