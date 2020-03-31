@echo off
setlocal enabledelayedexpansion
rem doxygen_documentation_generate.bat
rem Generate Doxygen documentation

rem Have Doxygen installed and within your PATH environment variable
rem http://www.doxygen.nl/download.html

rem Get current folder name
call :expand "%cd%\.."
for /f %%i in ("%ret%") do set "vpath=%%~nxi"

set "vdoc=.\doxygen\html\index.html"

dot.exe -V 2>nul
if !errorlevel! neq 0 (
	dir "%ProgramFiles%\*dot.exe" /b /a:-d /on /s>"%vpath%.__dot"
	if exist "%vpath%.__dot" (
		for /f "delims=" %%a in (%vpath%.__dot) do set "vpdot=%%a"
		for /f "delims=" %%a in ("!vpdot!") do set "vfdot=%%~nxa"
		call set "vpdot=%%vpdot:\!vfdot!=!%%"
		rem Hopefully this will do the trick...
		set "path=%path%;!vpdot!"
		del "%vpath%.__dot"
	)
)

rem Generate documentation
cd ..
doxygen.exe "doxygen\%vpath%.doxygen"

if exist "%vdoc%" (
	cmd /c "%vdoc%"
)

goto :eof

:expand
	set "ret=%~f1"
goto :eof
