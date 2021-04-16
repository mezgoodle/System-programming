.386
.model flat, stdcall
option CaseMap:None

include /masm32/include/windows.inc
includelib /masm32/lib/kernel32.lib
include /masm32/include/user32.inc
includelib /masm32/lib/user32.lib
include /masm32/include/kernel32.inc



.data
    textOfWindow       DB "Математичні розрахунки", 0
    allResults  DB "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
    textOfRow              DB "a = %s, b = %s, c = %s, результат = %s", 0
    textOfNegativeNumber         DB "-%i", 0
    textOfPossitiveNumber         DB "%i", 0

    stepWithBuffer      DD 0

    calculation                    DB 0
    coeffs_a               DB -3, -3, -2, -1, 3
    coeffs_b               DB 2, 2, -2, -1, 2
    coeffs_c               DB 4, 2, 2, 3, 4
	rows				   DD 5
	
.data?
    a_element              DB 16 DUP (?)
    b_element              DB 16 DUP (?)
    c_element              DB 16 DUP (?)
	buff_last_final        DB 1024 DUP (?)
	buff_res_final         DB 32 DUP (?)
    first_row              DB 128 DUP (?)
    second_row             DB 128 DUP (?)
    third_row              DB 128 DUP (?)
    fourth_row             DB 128 DUP (?)
    fifth_row              DB 128 DUP (?)
    buff_res               DB 16 DUP (?)
    

; (c / b - 24 + a) / (2 * a * c - 1)
calculate_the_row MACRO a, b, c_
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

invoke_fixed_number MACRO buffer, number
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

invoke_single_number MACRO buffer, number
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
    invoke_single_number a_element, coeffs_a[index]
    invoke_single_number b_element, coeffs_b[index]
    invoke_single_number c_element, coeffs_c[index]

    calculate_the_row coeffs_a[index], coeffs_b[index], coeffs_c[index]
    MOV calculation, AL
    
    invoke_fixed_number buff_res_final, calculation

    INVOKE wsprintf, buffer, addr textOfRow, addr a_element, addr b_element, addr c_element, addr buff_res_final
ENDM


.code
    start:
        
        MOV stepWithBuffer, offset first_row
		MOV EDI, 0
        calculation_loop:
        get_the_row stepWithBuffer, EDI

        ADD stepWithBuffer, 128
        ADD EDI, 1
        CMP EDI, rows
        JNE calculation_loop

        INVOKE wsprintf, addr buff_last_final, addr allResults, addr first_row, addr second_row, addr third_row, addr fourth_row, addr fifth_row

        INVOKE MessageBox, 0, addr buff_last_final, addr textOfWindow, MB_OK
        INVOKE ExitProcess, 0
    END start