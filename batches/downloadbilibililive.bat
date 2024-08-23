@echo off
chcp 65001
echo This can download bilibili Live.  This cannot download from beginning of a stream.
set /P url=Video URL 
set /P output=Output file name without extension 
yt-dlp -U
yt-dlp -f "best[ext=flv]" -o %output%.flv %url%
ffmpeg -i %output%.flv -c copy %output%.mp4
del %output%.flv