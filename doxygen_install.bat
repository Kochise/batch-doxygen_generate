@echo off
setlocal enabledelayedexpansion
rem doxygen_layout_generate.bat
rem Generate Doxygen layout template

rem Have Doxygen installed and within your PATH environment variable
rem http://www.doxygen.nl/download.html

rem Change default helpers
set "quiet=1>nul 2>nul"
set "fquiet=/f /q 1>nul 2>nul"

rem Convert current time and date in a more usable format
for /f "tokens=1,2,3,4 delims=/ " %%a in ("%date%") do set "fdate=%%d%%c%%b%%a"
for /f "tokens=1,2,3,4 delims=:," %%a in ("%time%") do set "ftime=%%a%%b%%c%%d"
set "fdate=%fdate: =0%"
set "ftime=%ftime: =0%"
set "vtemp=%fdate%%ftime%"
del %vtemp%.* %fquiet%

rem Get current folder name
call :expand "%cd%\.."
for /f %%i in ("%ret%") do set "vpath=%%~nxi"

rem Check Doxygen installation
doxygen.exe -v 1>nul 2>nul
if !errorlevel! neq 0 (
	rem Download release page
	set "vpath=http://www.doxygen.nl/download.html"
	echo Doxygen not found, trying to download it from !vpath!...
	certutil.exe -urlcache -split -f "!vpath!" %vtemp%.html %quiet%
	if !errorlevel! equ 0 (
		rem Looking for setup file url
		echo   Scanning download page...
		findstr /r "http.*-setup\.exe" %vtemp%.html>%vtemp%.txt
		if exist %vtemp%.txt (
			rem Get setup file url (last line)
			for /f "delims=!" %%a in (%vtemp%.txt) do (
				set "url=%%a"
			)
			rem Seek " from start and end of line
			for /l %%l in (1,1,80) do if not "!url:~0,1!"==^"^"^" set "url=!url:~1!"
			for /l %%l in (1,1,80) do if not "!url:~-1!"==^"^"^" set "url=!url:~0,-1!"
			for /l %%l in (1,1,1) do if "!url:~0,1!"==^"^"^" set "url=!url:~1!"
			for /l %%l in (1,1,1) do if "!url:~-1!"==^"^"^" set "url=!url:~0,-1!"
			if not "!url!"=="" (
				rem Get setup file name
				for /f %%i in ("!url!") do set "vfile=%%~nxi"
				if not exist !vfile! (
					rem Setup file not already downloaded
					echo   Downloading !vfile!...
					certutil.exe -urlcache -split -f "!url!" "!vfile!" %quiet%
				)
				if exist !vfile! (
					rem Setup file already downloaded
					echo   Installing !vfile!...
					cmd /c "!vfile!"
				) else (
					echo     Error installing...
				)
			) else (
				echo     Error parsing...
			)
		) else (
			echo     Error scanning...
		)
	) else (
		echo   Error downloading...
	)
	del %vtemp%.* %fquiet%
) else (
	echo Doxygen already installed...
)

rem Check Graphviz installation (yeah, this could be improved instead than duplicated)
dot.exe -V 2>nul
if !errorlevel! neq 0 (
	rem Download release page
	set "vpath=https://graphviz.gitlab.io/_pages/Download/Download_windows.html"
	echo Graphviz not found, trying to download it from !vpath!...
	certutil.exe -urlcache -split -f "!vpath!" %vtemp%.html %quiet%
	if !errorlevel! equ 0 (
		rem Looking for setup file url
		echo   Scanning download page...
		findstr /r "windows/graphviz.*\.msi" %vtemp%.html>%vtemp%.txt
		if exist %vtemp%.txt (
			rem Get setup file url (last line)
			for /f "delims=!" %%a in (%vtemp%.txt) do (
				set "url=%%a"
			)
			rem Seek " from start and end of line
			for /l %%l in (1,1,80) do if not "!url:~0,1!"==^"^"^" set "url=!url:~1!"
			for /l %%l in (1,1,80) do if not "!url:~-1!"==^"^"^" set "url=!url:~0,-1!"
			for /l %%l in (1,1,1) do if "!url:~0,1!"==^"^"^" set "url=!url:~1!"
			for /l %%l in (1,1,1) do if "!url:~-1!"==^"^"^" set "url=!url:~0,-1!"
			if not "!url!"=="" (
				rem ,--- Graphviz specific ---------------------,
				rem Remove release page from vpath
				for /f %%i in ("!vpath!") do set "vfile=%%~nxi"
				call set "vpath=%%vpath:!vfile!=%%"
				rem Add setup file url to vpath
				set "url=!vpath!!url!"
				rem '--- Graphviz specific ---------------------'
				rem Get setup file name
				for /f %%i in ("!url!") do set "vfile=%%~nxi"
				if not exist !vfile! (
					rem Setup file not already downloaded
					echo   Downloading !vfile!...
					certutil.exe -urlcache -split -f "!url!" "!vfile!" %quiet%
				)
				if exist !vfile! (
					rem Setup file already downloaded
					echo   Installing !vfile!...
					cmd /c "!vfile!"
				) else (
					echo     Error installing...
				)
			) else (
				echo     Error parsing...
			)
		) else (
			echo     Error scanning...
		)
	) else (
		echo   Error downloading...
	)
	del %vtemp%.* %fquiet%
) else (
	echo Graphviz already installed...
)

goto :eof

:expand
	set "ret=%~f1"
goto :eof
