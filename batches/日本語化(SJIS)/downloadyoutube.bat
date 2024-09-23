@echo off

echo This batch can download YouTube videos. Cookies are used for download Private videos.

set /P url=Video URL 

set /P output=Output file name without extension 

yt-dlp -U

yt-dlp -f "bv[protocol=https]+ba[ext=m4a][protocol=https]" --recode-video mp4 -o %output%.mp4 %url%