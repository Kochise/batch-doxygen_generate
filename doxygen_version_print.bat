@echo off
setlocal enabledelayedexpansion
rem doxygen_version_print.bat
rem Display current Doxygen version

rem Have Doxygen installed and within your PATH environment variable
rem http://www.doxygen.nl/download.html

rem Get current folder name
call :expand "%cd%\.."
for /f %%i in ("%ret%") do set "vpath=%%~nxi"

rem Print Doxygen version
doxygen.exe -v 2>nul

goto :eof

:expand
	set "ret=%~f1"
goto :eof
