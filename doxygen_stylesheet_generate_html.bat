@echo off
setlocal enabledelayedexpansion
rem doxygen_stylesheet_generate_html.bat
rem Generate html Doxygen template style sheet

rem Have Doxygen installed and within your PATH environment variable
rem http://www.doxygen.nl/download.html

rem Get current folder name
call :expand "%cd%\.."
for /f %%i in ("%ret%") do set "vpath=%%~nxi"

rem Generate html template style sheet
doxygen.exe -w html "%vpath%.headerFile.html" "%vpath%.footerFile.html" "%vpath%.styleSheetFile.html" "%vpath%.doxygen"

goto :eof

:expand
	set "ret=%~f1"
goto :eof
