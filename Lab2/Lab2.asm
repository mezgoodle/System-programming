.model tiny
.stack 100h
.data
    START_MESSAGE       DB "����i�� ��஫�, ��� �쮣� � ��� � 3 �஡�: $"
    ERROR_MESSAGE_1     DB "�������, ����i�� � ࠧ: $"
	ERROR_MESSAGE_2     DB "�� ���௠�� ᢮� �஡� $"
    PASSWORD            DB "genji"
    INFORMATION         DB "������� ���ᨬ 򢣥�����", 10, "I�-9312", 10, "09.11.2001 $"
    PASSWORD_LEN        DB 7
    INPUT_TEXT          DB 32 DUP (?)
	ATTEMPTS		        DB 0
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
		INC ATTEMPTS
		CMP ATTEMPTS, 3
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
