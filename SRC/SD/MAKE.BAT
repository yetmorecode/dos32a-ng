@echo off
@echo Creating SUNSYS Debugger
@echo ************************
@echo.

build	oemtitle.inf 50
tasm	-dSVR=0 sd.asm
wcl386	-zq -l=stub32ac -fe=sd sd.obj

rem	_sc -b -q sd
rem	_ss sd sd -q
rem	_ss sd -lock -q

rem	copy sd.exe %WATCOM%\BINW\sd.exe
rem	copy sd.exe %WATCOM%\BINW\_sd.exe

del *.obj
