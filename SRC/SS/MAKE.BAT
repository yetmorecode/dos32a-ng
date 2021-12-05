@echo off
@echo Creating SUNSYS Setup Utility
@echo *****************************
@echo.

build	oemtitle.inf 63
tasm	setup.asm
wcc386	-zq -oxs -s -zp1 -5r -fpi main.c
wcl386	-zq -l=stub32ac -fe=ss -k65536 setup.obj main.obj

rem	_sc -b -q ss
rem	_ss ss ss -q
rem	_ss ss -lock -q

rem	copy ss.exe %WATCOM%\BINW\ss.exe
rem	copy ss.exe %WATCOM%\BINW\_ss.exe

del *.obj
