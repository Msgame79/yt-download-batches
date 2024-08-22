@echo on
chcp 65001
echo This can download YouTube live streams. 
set /P url=URL
set /P output=output
:loop
set /P sdfb=start download from beginning(y/n) 
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
yt-dlp -f bv+ba %n% -o %output%.mp4 %url%