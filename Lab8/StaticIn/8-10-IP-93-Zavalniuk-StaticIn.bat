@echo off
	set module="8-10-IP-93-Zavalniuk-StaticIn-module"
    set mainscript="8-10-IP-93-Zavalniuk-StaticIn"

    \masm32\bin\ml /c /coff "%module%.asm"
    \masm32\bin\Link.exe /OUT:"%module%.dll" /DEF:%mainscript%.def /DLL "%module%.obj"

    \masm32\bin\ml /c /coff "%mainscript%.asm"

    \masm32\bin\Link.exe /SUBSYSTEM:console "%mainscript%.obj"
    dir "%mainscript%.*"

%mainscript%.exe
pause
