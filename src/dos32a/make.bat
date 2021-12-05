@echo off
@echo Creating DOS/32 Advanced DOS Extender (2021 next-gen)
@echo *****************************************************
@echo.

del *.obj
del *.lst
del *.exe

..\..\bin\tasm32 /dEXEC_TYPE=0 /m /ml /c /la kernel.asm
..\..\bin\tasm32 /dEXEC_TYPE=0 /m /ml /c /la dos32a.asm

..\..\bin\tlink /3 dos32a kernel,dos32a-ng.exe
