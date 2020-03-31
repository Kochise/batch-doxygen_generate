@echo off
setlocal enabledelayedexpansion
rem doxygen_stylesheet_generate_rtf.bat
rem Generate rtf Doxygen template style sheet

rem Have Doxygen installed and within your PATH environment variable
rem http://www.doxygen.nl/download.html

rem Get current folder name
call :expand "%cd%\.."
for /f %%i in ("%ret%") do set "vpath=%%~nxi"

rem Generate rtf template style sheet
doxygen.exe -w rtf "%vpath%.stylesheet.rtf"

goto :eof

:expand
	set "ret=%~f1"
goto :eof
