set file=%~dp07-7-IP-93-Zavalniuk


D:\masm32\bin\ml /c /coff "%file%.asm"
D:\masm32\bin\ml /c /coff "%file%-1.asm"
D:\masm32\bin\Link.exe /SUBSYSTEM:WINDOWS /out:%file%.exe "%file%.obj" "%file%-1.obj"
