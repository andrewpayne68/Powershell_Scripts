@ECHO OFF
SET ThisScriptsDirectory=%~dp0
SET PowerShellScriptPath=C:\Scripts\Build_Domain.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%'";