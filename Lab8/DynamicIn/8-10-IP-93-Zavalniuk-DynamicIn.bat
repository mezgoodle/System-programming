@echo off
	set module="8-10-IP-93-Zavalniuk-DynamicIn-module"
    set mainscript="8-10-IP-93-Zavalniuk-DynamicIn"

    \masm32\bin\ml /c /coff "%module%.asm"
    \masm32\bin\Link.exe /OUT:"%module%.dll" /DLL /EXPORT:calculateTheRow "%module%.obj"

    \masm32\bin\ml /c /coff "%mainscript%.asm"

    \masm32\bin\Link.exe /SUBSYSTEM:console "%mainscript%.obj"
    dir "%mainscript%.*"

%mainscript%.exe
pause
