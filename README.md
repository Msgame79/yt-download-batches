# 使い方
## 事前準備
1. [ffmpeg-(version)-full_build.7zまたはffmpeg-(version)-full_build.zip
](https://github.com/GyanD/codexffmpeg/releases)と[yt-dlp.exe](https://github.com/yt-dlp/yt-dlp-nightly-builds/releases)をインストールし、環境変数PATHを通しておく。
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
出力ファイル名を入力する。ファイル名に使用できない文字(`\/:*?"<>|`)とスペースは使用不可。
### [`downloadbilibili.bat`](batches/downloadbilibili.bat),[`downloadniconico.bat`](batches/downloadniconico.bat)
#### Download HQ video using cookies(y/n)
`Cookies.txt`を使用して、高品質な動画をダウンロードするかどうか
引数は`yYnN`が使用可能。他の文字を入力した場合はもう一度入力を要求する。
### [`downloadyoutubelive.bat`](batches/downloadyoutubelive.bat)
#### Start download from beginning(y/n)
DVRが有効な配信の最初からダウンロードするかどうか
引数は`yYnN`が使用可能。他の文字を入力した場合はもう一度入力を要求する。
# バッチファイル解析
## 共通
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
