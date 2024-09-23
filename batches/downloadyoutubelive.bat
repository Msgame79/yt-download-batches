@echo off

echo This can download YouTube live streams. But not recommended. You can prefer using dounloadyoutube.bat after finishing a stream. 

set /P url=Video URL 

set /P output=Output file name without extension 

:loop

set /P sdfb=Start download from beginning(y/n) 

if %sdfb%==y (

set n=--live-from-start

) else if %sdfb%==Y (

set n=--live-from-start

) else if %sdfb%==n (

set n=--no-live-from-start

) else if %sdfb%==N (

set n=--no-live-from-start

) else (

goto loop

)

pause

yt-dlp -U

yt-dlp -f bv+ba --recode-video mp4 %n% -o %output%.mp4 %url%