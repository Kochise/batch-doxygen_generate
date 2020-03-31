@echo off
setlocal enabledelayedexpansion
rem doxygen_layout_generate.bat
rem Generate Doxygen layout template

rem Have Doxygen installed and within your PATH environment variable
rem http://www.doxygen.nl/download.html

rem Get current folder name
call :expand "%cd%\.."
for /f %%i in ("%ret%") do set "vpath=%%~nxi"

rem Generate layout template
doxygen.exe -l "%vpath%.layout"

goto :eof

:expand
	set "ret=%~f1"
goto :eof
