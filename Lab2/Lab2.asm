.model tiny
.stack 100h
.data
    START_MESSAGE       DB "Введiть пароль, для цього у вас є 3 спроби: $"
    ERROR_MESSAGE_1     DB "Помилка, введiть ще раз: $"
	ERROR_MESSAGE_2     DB "Ви вичерпали свої спроби $"
    PASSWORD            DB "genji"
    INFORMATION         DB "Завальнюк Максим Євгенович", 10, "IП-9312", 10, "09.11.2001 $"
    PASSWORD_LEN        DB 7
    INPUT_TEXT          DB 32 DUP (?)
	ATTEMPTS		    DB 0
.code
.startup
    MAIN: 
    ; Cleaning the screan
    MOV     AX, 03h
    INT     10h

    ; Print the start message on the screan
    MOV     AH, 09h
    MOV     DX, offset START_MESSAGE
    INT     21h

    INPUT:
    ; Read text from user
    MOV        AH, 3Fh
    MOV        DX, offset INPUT_TEXT
    INT        21h

    COMPARING:
	; Check the length of input text
    CMP        AX, 7
	JNE		   ERR
    MOV        DI, 0

    ; Compare by each character
    MOV        BL, INPUT_TEXT[DI]
    MOV        BH, PASSWORD[DI]
    CMP        BL, BH
    JNE        ERR

    ; INCREASING COUNTER
    INC        DI
    CMP        DI, 5
	JE		   CORRECT
    LOOP       COMPARING

	CORRECT:
	; Cleaning the screan
	MOV        AX, 03h
	INT        10h
    MOV        AH, 09h
    MOV        DX, offset INFORMATION
    INT        21h 
	JMP		   EXIT

    ; Last proccess
    EXIT:
    MOV        AH, 4Ch
    MOV        AL, 0
    INT        21h

    ERR:
        ; Cleaning the screan
        MOV AX, 03h
        INT 10h

        ; Print the error message on the screan
        MOV AH, 09h
        MOV dx, offset ERROR_MESSAGE_1
        INT 21h
		INC ATTEMPTS
		CMP ATTEMPTS, 3
		JNE INPUT
		
		; Cleaning the screan
        MOV AX, 03h
        INT 10h

		; Print the error message on the screan
        MOV AH, 09h
        MOV dx, offset ERROR_MESSAGE_2
		INT 21h
		JMP exit	
END
