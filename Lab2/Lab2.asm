.model tiny
.stack 100h
.data
    START_MSG     DB "����?�� ��஫�: $"
    ERROR_MSG     DB "������� $"
    PASSWD        DB "genji"
    DATA          DB "������� ���ᨬ 򢣥�����", 10, "I�-9312", 10, "09.11.2001 $"
    PASSWD_LEN    DB 7
    USR_INPUT     DB 32 DUP (?)
	TEMO		  DB 2
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
    CMP     AX, PASSWD_LEN
    JNE     ERR
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
		cmp TEMO,3
		je exit
END
