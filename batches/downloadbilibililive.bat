@echo off
chcp 65001
echo This can download bilibili Live.  This cannot download from beginning of a stream.
set /P url=Video URL 
set /P output=Output file name without extension 
yt-dlp -U
yt-dlp -f "best[ext=flv]" --remux-video mp4 -o "%output%.mp4" %url%