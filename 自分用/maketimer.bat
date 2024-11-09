chcp 65001

echo off

cls

echo FFmpeg^(https^://github.com/GyanD/codexffmpeg/releases^)を環境変数Pathに登録し、font.ttf、font.ttc、font.otfのいずれかをバッチファイルと同じフォルダに置いてTimer.mp4、begin.png、end.pngを作成します。

echo 使える色の名前はffmpeg -hide_banner -colorsで確認できます。
    
echo.

if exist font.otf (

set font=font.otf

) else if exist font.ttc (

set font=font.ttc

) else if exist font.ttf (

set font=font.ttf

) else (

echo font.ttf、font.ttc、font.otfのいずれかをバッチファイルと同じフォルダに配置してください。10秒後に自動で終了します。

timeout /t 10>nul

exit

)

ffmpeg -loglevel -8

if %errorlevel%==9009 (

echo.

echo ffmpegを実行できません。ffmpegをインストールするか環境変数を確認してください。10秒後に自動で終了します。

timeout /t 10>nul

exit

)

set /p fps=fps^(整数^)^: 

echo.

set /p len=動画の長さ^(整数、1分=60、1時間=3600、最小=1^(0:00:01.000^)、最大=359999^(99:59:59.000^)^)^: 

echo.

set /p tc=文字の色^(RGBAカラーコードまたは色の名前^)^: 

echo.

set /p bc=背景の色^(RGBAカラーコードまたは色の名前^)^: 

for /f "delims=" %%a in ('powershell %len%+1/%fps%') do ( set len1=%%a )

for /f "delims=" %%b in ('powershell 1/%fps%') do ( set len2=%%b )

ffmpeg -y -hide_banner -f lavfi -r %fps% -i "color=%bc%:size=2880x200" -vf "drawtext=fontfile=%font%:fontsize=178:x=0:y=10:fontcolor=%tc%:text='%%{pts\:hms}'" -t %len1% -g 0 -c:v h264_nvenc -qmax 22 -qmin 22 -bf 0 Timer.mp4

ffmpeg -y -hide_banner -loglevel -8 -i Timer.mp4 -frames:v 1 begin.png

ffmpeg -y -hide_banner -loglevel -8 -sseof -%len2% -i Timer.mp4 -frames:v 1 end.png