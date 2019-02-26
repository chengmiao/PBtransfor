@echo off
taskkill /f /im PBclient.exe

::pause

::set /p ip=���������ip��ַ��
::set /p port=����������˿ڣ�?

pause

cd /d %~dp0\bin
::start "" "%~dp0\bin\PBclient.exe" %ip% %port%
start "" "%~dp0\bin\PBclient.exe"