@echo off
@echo Creating SUNSYS Bind Utility
@echo ****************************
@echo.

build	oemtitle.inf 62
tasm	sbind.asm
wcc386	-zq -oxs -zp1 -5r -fpi main.c
wcl386	-zq -l=stub32ac -fe=sb -k65536 sbind.obj main.obj

rem	_sc -b -q sb
rem	_ss sb sb -q
rem	_ss sb -lock -q

rem	copy sb.exe %WATCOM%\BINW\sb.exe
rem	copy sb.exe %WATCOM%\BINW\_sb.exe

del *.obj
