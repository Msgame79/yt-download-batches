# 使い方
## 事前準備
1. [ffmpeg-master-latest-win64-gpl.zip](https://github.com/BtbN/FFmpeg-Builds/releases/tag/latest)と[yt-dlp.exe](https://github.com/yt-dlp/yt-dlp-nightly-builds/releases)をインストールし、環境変数PATHを通しておく。
2. 自分がわかる場所にフォルダを作っておき、そのフォルダ内にバッチファイルや`Cookies.txt`(後述)を配置する。
## `Cookies.txt`のダウンロード(Chrome用)
1. [Get cookies.txt LOCALLY](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc)をChromeにインストール
2. `Google Chromeの設定(右上の三点リーダー)`→`設定`→`ダウンロード`→`ダウンロード前に各ファイルの保存場所を確認する`を有効にする
3. 拡張機能一覧から`Get cookies.txt LOCALLY`をクリックし、`Export All Cookies`をクリック
4. ファイル名を変更せず(`Cookies.txt`のまま)に[事前準備](#事前準備)で用意したフォルダにダウンロードする
## オプション説明
### [共通](batches/)
#### URL
動画のURLを貼り付け(共有用リンクはリダイレクト先が正しければ正しく処理される)
#### Output file name withoue extension
出力ファイル名を入力する。ファイル名に使用できない文字(`\/:*?"<>|`)は使用不可(変数入力時は例外あり)。
### [`downloadbilibili.bat`](batches/downloadbilibili.bat),[`downloadniconico.bat`](batches/downloadniconico.bat)
#### Download HQ video using cookies(y/n)
`Cookies.txt`を使用して、高品質な動画をダウンロードするかどうか
引数は`yYnN`が使用可能。他の文字を入力した場合はもう一度入力を要求する。
### [`downloadyoutubelive.bat`](batches/downloadyoutubelive.bat)
#### Start download from beginning(y/n)
DVRが有効な配信の最初からダウンロードするかどうか
引数は`yYnN`が使用可能。他の文字を入力した場合はもう一度入力を要求する。
# バッチファイル解析
## [`downloadbilibili.bat`](batches/downloadbilibili.bat)
```
@echo off
chcp 65001
echo This can download bilibili videos. Premium/Normal member can download 1080p60/4K,720p60 with a cookie file generated from Get cookies.txt LOCALLY (https://x.gd/G3xMs). 
set /P url=Video URL 
set /P output=Output file name without extension 
:loop
set /P cookie=Download HQ video using cookies(y/n)
set t=%%(autonumber)s
set outputs=%output%_%t% 
if %cookie%==y (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https][vcodec*=avc]+bestaudio[ext=m4a][protocol=https]" --cookies cookies.txt -o "%outputs%.mp4" %url%
) else if %cookie%==Y (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https][vcodec*=avc]+bestaudio[ext=m4a][protocol=https]" --cookies cookies.txt -o "%outputs%.mp4" %url%
) else if %cookie%==n (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https][vcodec*=avc]+bestaudio[ext=m4a][protocol=https]" -o "%outputs%.mp4" %url%
) else if %cookie%==N (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https][vcodec*=avc]+bestaudio[ext=m4a][protocol=https]" -o "%outputs%.mp4" %url%
) else (
goto loop
)
dir /b %output%*>list.txt
for /f %%a in (list.txt) do (echo file %%a>>list1.txt)
mkdir a
ffmpeg -f concat -i list1.txt -c copy a\%output%.mp4
del %output%*.mp4
del list.txt
del list1.txt
move a\%output%.mp4 .
rmdir /q a
```
## [`downloadbilibililive.bat`](batches/downloadbilibililive.bat)
```
@echo off
chcp 65001
echo This can download bilibili Live.  This cannot download from beginning of a stream.
set /P url=Video URL 
set /P output=Output file name without extension 
yt-dlp -U
yt-dlp -f "best[ext=flv]" -o %output%.flv %url%
ffmpeg -i %output%.flv -c copy %output%.mp4
del %output%.flv
```
## [`downloadniconico.bat`](batches/downloadniconico.bat)
```
@echo off
chcp 65001
echo This can download niconico videos. Premium member can down 1080p with a cookie file generated from Get cookies.txt LOCALLY (https://x.gd/G3xMs)
set /P url=Video URL 
set /P output=Output file name without extension 
:loop
set /P cookie=Download HQ video using cookies(y/n) 
if %cookie%==y (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" --cookies cookies.txt -o %output%.mp4 %url%
) else if %cookie%==Y (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" --cookies cookies.txt -o %output%.mp4 %url%
) else if %cookie%==n (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" -o %output%.mp4 %url%
) else if %cookie%==N (
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]" -o %output%.mp4 %url%
) else (
goto loop
)
```
## [`downloadtiktok.bat`](batches/downloadtiktok.bat)
```
@echo off
chcp 65001
echo This can download TikTok videos. 
set /P url=Video URL 
set /P output=Output file name without extension 
yt-dlp -U
yt-dlp -f "best[ext=mp4][vcodec*=h264]" -o %output%.mp4 %url%
```
## [`downloadyoutube.bat`](batches/downloadyoutube.bat)
```
@echo off
chcp 65001
echo This can download YouTube videos. 
set /P url=Video URL 
set /P output=Output file name without extension 
yt-dlp -U
yt-dlp -f "bestvideo[ext=mp4][protocol=https]+bestaudio[ext=m4a][protocol=https]" -o %output%.mp4 %url%
```
## [`downloadyoutubelive.bat`](batches/downloadyoutubelive.bat)
```
@echo on
chcp 65001
echo This can download YouTube live streams. 
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
yt-dlp -f bv+ba %n% -o %output%.mp4 %url%
```
### 共通
```
@echo off
```
コマンドの先頭に@をつけることでコマンドの入力部分(カレントディレクトリを含む)を表示しないようにする。`echo off`でこれ以降のすべてのコマンドに適用される。
```
chcp 65001
```
文字コードを`UTF-8`に指定。デフォルトのコードページは932(日本語Windowsの場合)が選択されている。
なお、バッチファイルをメモ帳で開き、文字コードを`ANSI`にして保存すると、このコマンドなしで日本語を表示することができる。
```
set /P url=Video URL
```
```
set /P output=Output file name without extension
```
変数を設定(定義)する。`/P`オプションでユーザーによる入力を変数の値とすることができる。`=`の左は変数名、右は値入力時の説明である。
```
yt-dlp -U
```
`yt-dlp`の更新を確認する。更新があれば自動でダウンロードする。
```
yt-dlp -o %output%.mp4 %url%
```
変数`output`と`url`を使用して引数を使用する。以下にここで使われるオプションを表示する。
```
-f [FORMAT]
```
ダウンロード時のフォーマットを指定する。詳細は[yt-dlpのドキュメント](https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#format-selection)参照。
```
--cookies cookies.txt
```
`cookies.txt`を使用してサイトにログインしてからダウンロードする。bilibiliやニコニコ動画(プレミアム会員のみ)ではダウンロードの品質が向上する。
```
--recode-video mp4
```
引数(`mp4`)に対応していないコーデックがあれば引数(`mp4`)に対応したコーデックに変換する。
```
--remux-video mp4
```
コーデックを変更せずに別のコンテナに再多重化する。
## `output`に使える変数
`Output file name without extension`の入力中`%%(variable)s`または`%%(variable)d`を追加することで、一定の文字列を追加することができる。使用可能な変数は[ここ](https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#output-template)で確認できる。
