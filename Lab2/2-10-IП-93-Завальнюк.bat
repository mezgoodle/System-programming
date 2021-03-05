set folder=%~dp0
set masm=%1		rem C:\masm32\bin
set dosbox=%2   rem C:\DosBox\DOSBox-0.74-3\DOSBox.exe
set filename=%3 rem Lab2

%masm%\ml /Bl %masm%\link16.exe %folder%%filename%.asm
%dosbox% -c "mount c %folder% " -c c: -c "keyb none 866 " -c "%filename% EXE "
