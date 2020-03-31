@echo off
setlocal enabledelayedexpansion
rem doxygen_template_generate.bat
rem Generate empty Doxygen template

rem Have Doxygen installed and within your PATH environment variable
rem http://www.doxygen.nl/download.html

rem Change default helpers
set "sepa=tokens=1,* delims=:"
set "quiet=1>nul 2>nul"
set "fquiet=/f /q 1>nul 2>nul"

rem Get current folder name
call :expand "%cd%\.."
for /f %%i in ("%ret%") do set "vpath=%%~nxi"

set "fsrc=%vpath%.doxygen"
set "ftpl=doxygen.template"
set "fcpy=%ftpl%.__cpy"

rem Generate template
doxygen.exe -g "%fsrc%"

if exist "%fsrc%" if exist "%ftpl%" (
	echo Please while updating the configuration file...
	rem Replace default Doxygen settings with template project settings
	copy "%ftpl%" "%fcpy%" %quiet%
	echo PROJECT_NAME           = "%vpath%">>"%fcpy%"
	echo OUTPUT_DIRECTORY       = "doxygen">>"%fcpy%"
	for /f "%sepa%=" %%i in (%fcpy%) do (
		call :string_strip "%%i" && set "vkey=!ret!"
		call :string_strip "%%j" && set "vpar=!ret!"
		call :file_line_find "%fsrc%" "^^!vkey! *="
		if not "!ret!"=="" (
			set "vnew=!ret!"
			rem Remove parameter
			for /l %%l in (1,1,80) do if not "!vnew:~-1!"=="=" set "vnew=!vnew:~0,-1!"
			if not "!vpar!"=="" set "vnew=!vnew! !vpar!"
			if not "!ret!"=="!vnew!" (
				set "ret=!ret:"=""!"
				set "vnew=!vnew:"=""!"
				call :file_line_replace "%fsrc%" "!ret_num!" "!ret!" "!vnew!"
			)
		)
	)
	del "%fcpy%" %fquiet%
)

goto :eof

:expand
	set "ret=%~f1"
goto :eof

:file_line_find
	rem Find first line from a file (include blank lines through 'findstr')
	rem src = file to look for
	rem str = findstr's string to find
	rem ret = first line with str
	set "vsrc=%~1"
	if not "!vsrc!"=="" (
		set "vstr=%~2"
		rem Remove escape character doubling
		set "vstr=!vstr:""="!"
		set "vstr=!vstr:^^=^!"
		if not "!vstr!"=="" (
			rem Find first line
			set "vcmd=findstr /n "!vstr!" ^"!vsrc!^""
			for /f "%sepa%" %%a in ('!vcmd!') do (
				rem Read tokens from 'findstr'
				set "ret_num=%%a"
				set "ret=%%b"
				rem Exit when found
				exit /b
			)
		)
	)
goto :eof

:file_line_replace
	rem Replace line from a file (include blank lines through 'findstr')
	rem src = file source
	rem num = line number
	rem str = line source
	rem par = line destination
	set "vsrc=%~1"
	set "vdst=!vsrc!.___cpy"
	if not "!vsrc!"=="" (
		set "vcmd=findstr /n ^"^^^^" ^"!vsrc!^""
		set "lstr=%~3"
		set "lstr=!lstr:""="!"
		set "lstr=!lstr:^^=^!"
		set "ldst=%~4"
		set "ldst=!ldst:""="!"
		set "ldst=!ldst:^^=^!"
		>"!vdst!" (
			rem Disabling expansion locally to avoid '!' being removed
			setlocal disabledelayedexpansion
			for /f "tokens=* delims=" %%a in ('findstr /n "^" "%~1"') do (
				set "vstr=%%a"
				setlocal enabledelayedexpansion
				rem Yeah, copy line per line, slow but no other way natively
				set "vstr=!vstr:*:=!"
				if "!vstr!" neq "!lstr!" (
					if not "!vstr!"=="" (
						echo !vstr!
					) else (
						echo;
					)
				) else (
					echo !ldst!
				)
				endlocal
			)
			endlocal
		)
		move /y "!vdst!" "!vsrc!" %quiet%
	)
goto :eof


:string_strip
	rem Strip string from leading and trailing specified character
	rem src = "  string to strip   "
	rem chr = " " (optional)
	rem len = 80 (optional)
	rem ret = "string to strip"
	set "ret=%~1"
	if not "!ret!"=="" (
		if not "%~2"=="" (
			set "par_char=%2"
		) else (
			set par_char=" "
		)
		if not "%~3"=="" (
			set /a "par_len=%~3"
		) else (
			set /a "par_len=80"
		)
		rem Stripping string with final parameters
		for /l %%l in (1,1,!par_len!) do if "!ret:~-1!"==!par_char! set "ret=!ret:~0,-1!"
		for /l %%l in (1,1,!par_len!) do if "!ret:~0,1!"==!par_char! set "ret=!ret:~1!"
	)
goto :eof
