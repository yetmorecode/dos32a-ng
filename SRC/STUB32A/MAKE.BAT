@echo off
build	oemtitle.inf 15
tasm	-dEXEC_TYPE=0 stub32a.asm
tasm	-dEXEC_TYPE=0 stub32c.asm
wcl	-zq -lr -fe=stub32a stub32a.obj
wcl	-zq -lr -fe=stub32c stub32c.obj

rem	copy stub32a.exe %WATCOM%\BINW
rem	copy stub32c.exe %WATCOM%\BINW

del *.obj
