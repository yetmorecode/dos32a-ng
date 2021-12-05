@echo off
echo Creating SUNSYS Debugger Library
echo ********************************
echo.

tasm32 %TASMFLAGS% sdebug.asm
wlib -b -c sdebug.lib +-sdebug.obj
rem copy sdebug.lib %WATCOM%\LIB386\L32
copy sdebug.lib  %DOS32A%\l32 >nul
del *.obj