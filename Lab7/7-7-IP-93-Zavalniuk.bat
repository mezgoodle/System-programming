set file=%~dp07-10-IP-93-Zavalniuk


C:\masm32\bin\ml /c /coff "%file%.asm"
C:\masm32\bin\ml /c /coff "%file%-1.asm"
C:\masm32\bin\Link.exe /SUBSYSTEM:WINDOWS /out:%file%.exe "%file%.obj" "%file%-1.obj"
pause
