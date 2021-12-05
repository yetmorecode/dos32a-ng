@echo off

wcl	-zq -l=dos -oxs -3 build.c

del *.obj
