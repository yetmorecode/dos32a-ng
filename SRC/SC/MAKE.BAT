@echo off
@echo Creating SUNSYS Compress Utility
@echo ********************************
@echo.

build	oemtitle.inf 66
tasm	scomp.asm
tasm	sload.asm
wcc386	-zq -oxs -zp1 -5r -fpi main.c
wcc386	-zq -oxs -zp1 -5r -fpi encode.c
wcl386	-zq -l=stub32ac -fe=sc -k65536 scomp.obj sload.obj encode.obj main.obj

rem	_sc -b -q sc
rem	_ss sc sc -q
rem	_ss sc -lock -q

rem	copy sc.exe %WATCOM%\BINW\sc.exe
rem	copy sc.exe %WATCOM%\BINW\_sc.exe

del *.obj
