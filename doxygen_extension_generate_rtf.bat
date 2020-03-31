@echo off
setlocal enabledelayedexpansion
rem doxygen_extension_generate_rtf.bat
rem Generate Doxygen rtf extensions file

rem Have Doxygen installed and within your PATH environment variable
rem http://www.doxygen.nl/download.html

rem Get current folder name
call :expand "%cd%\.."
for /f %%i in ("%ret%") do set "vpath=%%~nxi"

rem Generate rtf extensions file
doxygen.exe -e rtf "%vpath%.extension.rtf"

goto :eof

:expand
	set "ret=%~f1"
goto :eof
