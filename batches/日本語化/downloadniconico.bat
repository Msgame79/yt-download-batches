@echo off
echo This can download niconico videos. Premium member can down 1080p with a cookie file generated from Get cookies.txt LOCALLY (https://x.gd/G3xMs)
set /P url=Video URL 
set /P output=Output file name without extension 
:loop
set /P cookie=Download HQ video using cookies(y/n) 
if %cookie%==y (
yt-dlp -U
yt-dlp -f "bv+ba" --recode-video mp4 --cookies cookies.txt -o %output%.mp4 %url%
) else if %cookie%==Y (
yt-dlp -U
yt-dlp -f "bv+ba" --recode-video mp4 --cookies cookies.txt -o %output%.mp4 %url%
) else if %cookie%==n (
yt-dlp -U
yt-dlp -f "bv+ba" --recode-video mp4 -o %output%.mp4 %url%
) else if %cookie%==N (
yt-dlp -U
yt-dlp -f "bv+ba" --recode-video mp4 -o %output%.mp4 %url%
) else (
goto loop
)
