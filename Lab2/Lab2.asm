.model tiny
.stack 100h
.data
    START_MSG     DB "Введ?ть пароль: $"
    ERROR_MSG     DB "Помилка $"
    PASSWD        DB "genji"
    DATA          DB "Хогер не ?мба", 10, "IП-9312", 10, "30.11.2001 $"
    PASSWD_LEN    DB 5
    USR_INPUT     DB 32 DUP (?)
.code
.startup
    MAIN: 
      ; CLEARING SCREEN
    MOV     AX, 03h
    INT     10h

    ; PRINTING START MESSAGE
    MOV     AH, 09h
    MOV     DX, offset START_MSG
    INT     21h

    INPUT:
    ; READING USER'S INPUT
    MOV        AH, 3Fh
    MOV        DX, offset USR_INPUT
    INT     21h

    ; CHECKING LENGTH
    CMP     AX, 7
    JNE        ERR
    MOV     DI, 0
    VALIDATION:
    ; COMPARING CHARACTERS
    MOV        BL, USR_INPUT[DI]
    MOV        BH, PASSWD[DI]
    CMP        BL, BH
    JNE        ERR

    ; INCREASING COUNTER
    INC        DI
    CMP        DI, 5
    JB        VALIDATION

    MOV     AH, 09h
    MOV     DX, offset DATA
    INT     21h 

    ; END PROCESS
    EXIT:
    MOV     AH, 4Ch
    MOV     AL, 0
    INT     21h

    ERR:
        ;clean console
        mov ax, 03h
        int 10h

        ;error msg
        mov ah, 09h
        mov dx, offset ERROR_MSG; msg of output
        int 21h

        jmp exit
END
