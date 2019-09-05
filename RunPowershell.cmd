@ECHO OFF
SET ThisScriptsDirectory=%~dp0
SET PowerShellScriptPath=C:\AD_Automated_Install.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%'";