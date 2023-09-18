@echo off
chcp 65001
for /f "delims=[] tokens=2" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do set ip=%%a
echo %computername%\%username% (%ip%) %Date:~4% %time:~0,5%>> %username%.txt
