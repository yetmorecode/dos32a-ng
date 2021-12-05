@echo off
@echo Creating DOS/32 Advanced DOS Extender
@echo *************************************
@echo.

D:\tasm\bin\tasm -dEXEC_TYPE=0 -c -la kernel.asm, EXE\kernel.obj, EXE\kernel.lst
