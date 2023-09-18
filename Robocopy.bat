@echo off
mode con: cols=55 lines=15
title ROBOCOPY
color f1
cls
echo.
echo.
echo.
set /p kaynak= KOPYALANACAK KLASOR ?  
echo.
set /p hedef= KOPYALAMA HEDEFI ?  
echo.

robocopy %kaynak%\ %hedef%\ /copyall /s /e /zb /log:%USERPROFILE%\Desktop\Robocopy-Kopyalama-Sonucu.log /tee

pause
