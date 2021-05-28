@echo off
	set libname="8-10-IP-93-Zavalniuk-DynamicWithIn-module"
    set filename="8-10-IP-93-Zavalniuk-DynamicWithIn"

    \masm32\bin\ml /c /coff "%libname%.asm"
    \masm32\bin\Link.exe /OUT:"%libname%.dll" /DLL /EXPORT:calculateTheRow /NOENTRY "%libname%.obj"

    \masm32\bin\ml /c /coff "%filename%.asm"

    \masm32\bin\Link.exe /SUBSYSTEM:console "%filename%.obj"
    dir "%filename%.*"

%filename%.exe
pause
