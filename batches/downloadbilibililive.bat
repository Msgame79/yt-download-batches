@echo off
chcp 65001
echo This can download bilibili Live. 
set /P url=stream url 
set output=output file name 
yt-dlp -U
yt-dlp -f "best[ext=flv]" -o %output%.flv %url%
ffmpeg -i %output%.flv -c copy %output%.mp4
del %output%.flv