set file=%~dp7-10-IП-93-Завальнюк


C:\masm32\bin\ml /c /coff "%file%.asm"
C:\masm32\bin\ml /c /coff "%file%-1.asm"
C:\masm32\bin\Link.exe /SUBSYSTEM:WINDOWS /out:%file%.exe "%file%.obj" "%file%-1.obj"
