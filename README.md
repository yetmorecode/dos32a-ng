# DOS/32 Advanced DOS Extender (2021 next-gen!)
 
Happy hacking

## Building DOS/32A

You will need TASM 4+:

```
tasm32 /dEXEC_TYPE=0 /m /ml /c /la kernel.asm
tasm32 /dEXEC_TYPE=0 /m /ml /c /la dos32a.asm
tlink /3 dos32a kernel,DOS4GW.exe
```

## Legacy version

Check other branches for legacy versions:

* 7.1.0 SDK with full documentation and build instructions
* 8.0.0 source with build instructions
* 9.1.2 source 
