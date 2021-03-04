.model tiny
.stack 100h
.data
    START_MESSAGE       DB "Введiть пароль, для цього у вас є 3 спроби: $"
    ERROR_MESSAGE_1     DB "Помилка, введiть ще раз: $"
	ERROR_MESSAGE_2     DB "Ви вичерпали свої спроби $"
    PASSWORD          DB "genji"
    INFORMATION            DB "Завальнюк Максим Євгенович", 10, "IП-9312", 10, "09.11.2001 $"
    PASSWORD_LEN      DB 7
    INPUT_TEXT       DB 32 DUP (?)
	TEMP		    DB 0
.code
.startup
    MAIN: 
    ; Cleaning the screan
    MOV     AX, 03h
    INT     10h

    ; PRINTING START MESSAGE
    MOV     AH, 09h
    MOV     DX, offset START_MESSAGE
    INT     21h

    INPUT:
    ; READING USER'S INPUT
    MOV        AH, 3Fh
    MOV        DX, offset INPUT_TEXT
    INT        21h

    ; CHECKING LENGTH
    CMP        AX, 7
	JNE		   ERR
    MOV        DI, 0
    CHECKING:
    ; COMPARING CHARACTERS
    MOV        BL, INPUT_TEXT[DI]
    MOV        BH, PASSWORD[DI]
    CMP        BL, BH
    JNE        ERR

    ; INCREASING COUNTER
    INC        DI
    CMP        DI, 5
	JE		   CORRECT
    LOOP       CHECKING

	CORRECT:
	; Cleaning the screan
	MOV        AX, 03h
	INT        10h
    MOV        AH, 09h
    MOV        DX, offset INFORMATION
    INT        21h 
	JMP		   EXIT

    ; END PROCESS
    EXIT:
    MOV        AH, 4Ch
    MOV        AL, 0
    INT        21h

    ERR:
        ; Cleaning the screan
        MOV AX, 03h
        INT 10h

        ;error msg
        MOV AH, 09h
        MOV dx, offset ERROR_MESSAGE_1
        INT 21h
		INC TEMP
		CMP TEMP, 3
		JNE INPUT
		; Cleaning the screan
        MOV AX, 03h
        INT 10h
		;error msg
        MOV AH, 09h
        MOV dx, offset ERROR_MESSAGE_2
		INT 21h
		JMP exit	
END
