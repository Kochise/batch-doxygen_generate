@echo off
setlocal enabledelayedexpansion
rem doxygen_stylesheet_generate_latex.bat
rem Generate latex Doxygen template style sheet

rem Have Doxygen installed and within your PATH environment variable
rem http://www.doxygen.nl/download.html

rem Get current folder name
call :expand "%cd%\.."
for /f %%i in ("%ret%") do set "vpath=%%~nxi"

rem Generate latex template style sheet
doxygen.exe -w latex "%vpath%.headerFile.latex" "%vpath%.footerFile.latex" "%vpath%.styleSheetFile.latex" "%vpath%.doxygen"

goto :eof

:expand
	set "ret=%~f1"
goto :eof
