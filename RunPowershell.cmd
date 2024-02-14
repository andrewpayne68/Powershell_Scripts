@ECHO OFF
if "%1" == "elevated" goto start
powershell -command "Start-Process %~dpnx0 elevated -Verb runas"
goto :EOF

:start
SET PowerShellScriptPath=C:\SCRIPTS\Automated_Windows_Updates.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%'";

:EOF
exit
