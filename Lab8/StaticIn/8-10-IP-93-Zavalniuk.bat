@echo off
	set libname="8-10-IP-93-Zavalniuk-StaticIn-module"
    set filename="8-10-IP-93-Zavalniuk-StaticIn"

    \masm32\bin\ml /c /coff "%libname%.asm"
    \masm32\bin\Link.exe /OUT:"%libname%.dll" /DEF:%filename%.def /DLL "%libname%.obj"

    \masm32\bin\ml /c /coff "%filename%.asm"

    \masm32\bin\Link.exe /SUBSYSTEM:console "%filename%.obj"
    dir "%filename%.*"

%filename%.exe
pause
