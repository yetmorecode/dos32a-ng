@echo off
@echo Creating DOS/32 Advanced DOS Extender Beta
@echo ******************************************
@echo.

%dos32a%\src\sutils\build\build TEXT\oemtitle.asm 1958
tasm32 -dEXEC_TYPE=2 %TASMFLAGS% -c kernel.asm
tasm32 -dEXEC_TYPE=2 %TASMFLAGS% -c dos32a.asm
wcl %WCLFLAGS% -lr -fm=dos32a -fe=dos32a dos32a.obj kernel.obj
rem copy dos32a.exe %WATCOM%\BINW
del *.obj
copy dos32a.exe %DOS32A%\binw >nul