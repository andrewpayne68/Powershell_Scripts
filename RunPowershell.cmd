@ECHO OFF
SET ThisScriptsDirectory=%~dp0
SET PowerShellScriptPath=C:\Scripts\Automated_Windows_Updates.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%'";
