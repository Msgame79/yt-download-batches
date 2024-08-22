@echo off
chcp 65001
echo This can download bilibili videos. 
set /P url=動画のURLを入力 
set /P output=出力ファイル名を入力(拡張子なし) 
set t=%%(autonumber)s
set outputs=%output%_%t%
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https][vcodec*=avc]+bestaudio[ext=m4a][protocol=https]" --cookies www.bilibili.com_cookies.txt -o "%outputs%.mp4" %url%
dir /b %output%*>list.txt
for /f %%a in (list.txt) do (echo file %%a>>list1.txt)
mkdir a
ffmpeg -f concat -i list1.txt -c copy a\%output%.mp4
del %output%*.mp4
del list.txt
del list1.txt
move a\%output%.mp4 .
rmdir /q a