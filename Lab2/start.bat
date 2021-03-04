set folder=%~dp0
set masm=C:\masm32\bin
set dosbox=C:\DosBox\DOSBox-0.74-3\DOSBox.exe
rem set filename=%1

%masm%\ml /Bl %masm%\link16.exe %folder%Lab2.asm
%dosbox% -c "mount c %folder% " -c c: -c "keyb none 866 " -c "Lab2 EXE "
