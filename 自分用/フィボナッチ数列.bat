@echo off

set a=0

set b=1

set c=1

echo %a%

echo %b%

:loop

set /a c=a+b

set /a a=b+c

set /a b=c+a

echo %c%

echo %a%

echo %b%

goto loop