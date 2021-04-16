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
    coeffsA                DB -3, -3, -2, -1, 3
    coeffsB                DB 2, 2, -2, -1, 2
    coeffsC                DB 4, 2, 2, 3, 4
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

calculateTheRow macro A, B, C_
    mov AL, 1
	add AL, 1
    imul A
    imul C_
	add AL, -1
    mov calculation, AL
    mov AL, 1
    imul C_
    idiv B
	add AL, A
    add AL, -24
	cbw
    idiv calculation
endm

invokeFixedNumber macro place, number
    local quit
	local notEven
    mov AL, number
    sar AL, 1
    jb notEven
    invoke wsprintf, addr place, 
					 addr textOfPossitiveNumber, AL
    jmp quit
    notEven:
    mov BL, 5
    mov AL, number
    imul BL
    invoke wsprintf, addr place, 
					 addr textOfPossitiveNumber, AL
    
    quit:
endm

invokeSingleNumber macro place, number
    local quit
	local positiveNumber
	mov CL, -1
    mov     AL, number
    test    AL, AL
    jns     positiveNumber
	cbw
    imul CL
    invoke wsprintf, addr place, 
					 addr textOfNegativeNumber, AL
    jmp quit
    positiveNumber:
    invoke wsprintf, addr place, 
					 addr textOfPossitiveNumber, AL
    quit:
endm

getTheRow macro place, index
    invokeSingleNumber aElement, coeffsA[index]
    invokeSingleNumber bElement, coeffsB[index]
    invokeSingleNumber cElement, coeffsC[index]
    calculateTheRow coeffsA[index], coeffsB[index], coeffsC[index]
    mov calculation, AL
    invokeFixedNumber rowShowing, calculation
    invoke wsprintf, place, addr textOfRow, addr aElement, addr bElement, addr cElement, addr rowShowing
endm

.code
    start:
        mov stepWithBuffer, offset firstRow
		mov EDI, 0
        calculationLoop:
        getTheRow stepWithBuffer, EDI
        add stepWithBuffer, 128
        add EDI, 1
        CMP EDI, rows
        JNE calculationLoop
        invoke wsprintf, addr endShowing, addr allResultsInOnePlace, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow
        invoke MessageBox, 0, addr endShowing, addr textOfWindow, MB_OK
        invoke ExitProcess, 0
    end start