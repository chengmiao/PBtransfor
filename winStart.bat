@echo off
taskkill /f /im PBclient.exe

pause

set /p ip=输入服务器ip地址：
set /p port=输入服务器端口：

pause

cd /d %~dp0
start "" "%~dp0\bin\PBclient.exe" %ip% %port%