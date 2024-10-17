@echo off
set a=0
set b=1
set c=
set d=0
set e=1
set f=2
echo a_{1}=0, a_{2}=1, a_{n+2}=a_{n}+a_{n+1}
echo.
echo a_{1}=%a%
pause
cls
echo a_{1}=0, a_{2}=1, a_{n+2}=a_{n}+a_{n+1}
echo.
echo a_{1}=0
echo a_{2}=%b%
pause
:loop
cls
set /a d=d+1
set /a e=e+1
set /a f=f+1
set /a c=a+b
echo a_{1}=0, a_{2}=1, a_{n+2}=a_{n}+a_{n+1}
echo.
echo a_{%d%}=%a%
echo a_{%e%}=%b%
echo a_{%f%}=%c%
pause
cls
set /a d=d+1
set /a e=e+1
set /a f=f+1
set /a a=b+c
echo a_{1}=0, a_{2}=1, a_{n+2}=a_{n}+a_{n+1}
echo.
echo a_{%d%}=%b%
echo a_{%e%}=%c%
echo a_{%f%}=%a%
pause
cls
set /a d=d+1
set /a e=e+1
set /a f=f+1
set /a b=c+a
echo a_{1}=0, a_{2}=1, a_{n+2}=a_{n}+a_{n+1}
echo.
echo a_{%d%}=%c%
echo a_{%e%}=%a%
echo a_{%f%}=%b%
pause
goto loop
