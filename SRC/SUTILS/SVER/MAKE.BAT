@echo off
wcl	/zq /lr /fe=sver /oxs /5 main.c

rem	copy sver.exe %WATCOM%\BINW

del *.obj


