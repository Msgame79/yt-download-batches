chcp 65001 # UTF-8 Without BOM

# `^ +`を空の文字列に置換して行頭の空白を削除

Start-Process .\delfiles.bat -Wait

Clear-Host

$d=

$UUIDs = Get-Content -Path .\uuids.txt #ここに全てのUUIDを張り付けたテキストファイルをGet-Contentする

Set-Location .\musics

$UUIDs | ForEach-Object {

    Try {

        $flag=$true

        Invoke-WebRequest -Uri "https://ncs.io/track/download/$_" -OutFile ".\$_.mp3"

    } catch {

        $flag=$false

    }

    if ($flag) {

        $a=Invoke-WebRequest -Uri "https://ncs.io/track/download/$_" -Method Head

        [String]$b=$a.Headers["Content-Disposition"]

        $c=$b.SubString(22,$b.Length - 41)

        if ($c -eq $d) {

            $c="$c (Instrumental)"

        } else {

        }

        $c

        $_

        "Downloaded successfully"

        Do {

            Try {

                $flag=$true

                $c | Out-File ..\names.txt utf8NoBOM -Append

                $_ | Out-File ..\names.txt utf8NoBOM -Append

                "Downloaded successfully" | Out-File ..\names.txt utf8NoBOM -Append

            } Catch {

                $flag=$false

            }

        } Until ($flag)

        ffmpeg -hide_banner -loglevel -8 -y -i "$_.mp3" -metadata Title="$c" -c copy "new\$_.mp3"

    } else {

        $a=Invoke-WebRequest -Uri "https://ncs.io/track/download/$_" -Method Head

        [String]$b=$a.Headers["Content-Disposition"]

        $c=$b.SubString(22,$b.Length - 41)

        if ($c -eq $d) {

            $c="$c (Instrumental)"

        } else {

        }

        $c

        $_

        "Failed"

        Do {

            Try {

                $flag=$true

                $c | Out-File ..\names.txt utf8NoBOM -Append

                $_ | Out-File ..\names.txt utf8NoBOM -Append

                "Failed" | Out-File ..\names.txt utf8NoBOM -Append

            } Catch {

                $flag=$false

            }

        } Until ($flag)

    }

    Do {

        Try {

            $flag=$true

            "" | Out-File ..\names.txt utf8NoBOM -Append

        } Catch {

            $flag=$false

        }

    } Until ($flag)

    $d=$c

    ""

}

"完了"

Read-Host
