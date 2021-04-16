.386
.model flat, stdcall
option CaseMap:None

include /masm32/include/windows.inc
includelib /masm32/lib/kernel32.lib
include /masm32/include/user32.inc
includelib /masm32/lib/user32.lib
include /masm32/include/kernel32.inc

.data
	calculation            DB 0
    coeffsA               DB -3, -3, -2, -1, 3
    coeffsB               DB 2, 2, -2, -1, 2
    coeffsC               DB 4, 2, 2, 3, 4
	rows				   DD 5
	stepWithBuffer         DD 0
	textOfNegativeNumber   DB "-%i", 0
    textOfPossitiveNumber  DB "%i", 0
    textOfWindow       	   DB "Математичні розрахунки", 0
    allResultsInOnePlace   DB "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
    textOfRow              DB "a = %s, b = %s, c = %s, результат = %s", 0
    
	
.data?
    aElement              DB 16 DUP (?)
    bElement              DB 16 DUP (?)
    cElement              DB 16 DUP (?)
	endShowing             DB 1024 DUP (?)
    firstRow              DB 128 DUP (?)
    secondRow             DB 128 DUP (?)
    thirdRow              DB 128 DUP (?)
    fourthRow             DB 128 DUP (?)
    fifthRow              DB 128 DUP (?)
	rowShowing       	   DB 32 DUP (?)

calculateTheRow MACRO a, b, c_
    MOV AL, 1
	INC AL
    IMUL a
    IMUL c_
    DEC AL
    MOV calculation, AL
    MOV AL, 1
    IMUL c_
    IDIV b
	ADD AL, a
    SUB AL, 24
	cbw
    IDIV calculation
ENDM

invokeFixedNumber MACRO buffer, number
    LOCAL QUIT
	LOCAL NOT_EVEN

    MOV AL, number
    SAR AL, 1
    JB NOT_EVEN

    INVOKE wsprintf, addr buffer, 
					 addr textOfPossitiveNumber, AL
    JMP QUIT

    NOT_EVEN:
    MOV AL, 5
    IMUL number
    INVOKE wsprintf, addr buffer, 
					 addr textOfPossitiveNumber, AL
    
    QUIT:
ENDM

invokeSingleNumber MACRO buffer, number
    LOCAL QUIT
	LOCAL POSITIVE_NUMBER
	MOV CL, -1
    MOV     AL, number
    TEST    AL, AL
    JNS     POSITIVE_NUMBER
	cbw
    IMUL CL
    INVOKE wsprintf, addr buffer, 
					 addr textOfNegativeNumber, AL
    JMP QUIT
    POSITIVE_NUMBER:
    INVOKE wsprintf, addr buffer, 
					 addr textOfPossitiveNumber, AL
    QUIT:
ENDM

get_the_row MACRO buffer, index
    invokeSingleNumber aElement, coeffsA[index]
    invokeSingleNumber bElement, coeffsB[index]
    invokeSingleNumber cElement, coeffsC[index]

    calculateTheRow coeffsA[index], coeffsB[index], coeffsC[index]
    MOV calculation, AL
    
    invokeFixedNumber rowShowing, calculation

    INVOKE wsprintf, buffer, addr textOfRow, addr aElement, addr bElement, addr cElement, addr rowShowing
ENDM


.code
    start:
        
        MOV stepWithBuffer, offset firstRow
		MOV EDI, 0
        calculation_loop:
        get_the_row stepWithBuffer, EDI

        ADD stepWithBuffer, 128
        ADD EDI, 1
        CMP EDI, rows
        JNE calculation_loop

        INVOKE wsprintf, addr endShowing, addr allResultsInOnePlace, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow

        INVOKE MessageBox, 0, addr endShowing, addr textOfWindow, MB_OK
        INVOKE ExitProcess, 0
    END start