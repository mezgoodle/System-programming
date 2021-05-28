set mainscript="8-10-IP-93-Zavalniuk-StaticWithIn"
\masm32\bin\ml /c /coff "%mainscript%-module.asm"
\masm32\bin\Link.exe /OUT:"%mainscript%-module.dll" /DEF:%mainscript%.def /NOENTRY /DLL "%mainscript%-module.obj"
\masm32\bin\ml /c /coff "%mainscript%.asm"
\masm32\bin\Link.exe /SUBSYSTEM:console "%mainscript%.obj"
%mainscript%.exe
pause
