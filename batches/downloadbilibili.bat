@echo off

echo This batch can download bilibili videos. Cookies are used for high-quality(HQ) download.

set /P url=Video URL 

set /P output=Output file name without extension 

:loop

set /P cookie=Download HQ video using cookies(y/n)

if "%cookie%"=="y" (

yt-dlp -U

yt-dlp -f "bv+ba" --recode-video mp4 --cookies cookies.txt -o "%output%_%%(autonumber)03d.mp4" %url%

) else if "%cookie%"=="Y" (

yt-dlp -U

yt-dlp -f "bv+ba" --recode-video mp4 --cookies cookies.txt -o "%output%_%%(autonumber)03d.mp4" %url%

) else if "%cookie%"=="n" (

yt-dlp -U

yt-dlp -f "bv+ba" --recode-video mp4 -o "%output%_%%(autonumber)03d.mp4" %url%

) else if "%cookie%"=="N" (

yt-dlp -U

yt-dlp -f "bv+ba" --recode-video mp4 -o "%output%_%%(autonumber)03d.mp4" %url%

) else (

goto loop

)

mkdir a

dir /b %output%*>list.txt

for /f "delims=""" %%a in (list.txt) do (echo file %%a>>list1.txt)

ffmpeg -f concat -i list1.txt -c copy a\%output%.mp4

del %output%*.mp4

del list.txt

del list1.txt

move a\%output%.mp4 .

rmdir /q a