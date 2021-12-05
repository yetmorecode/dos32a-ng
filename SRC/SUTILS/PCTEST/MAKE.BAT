@echo off

tasm	pctest.asm
wcc386	-zq -oxt -5r -fpi main.c
wcl386	-zq -l=dos32a -fe=pctest -k65536 pctest.obj main.obj

del *.obj