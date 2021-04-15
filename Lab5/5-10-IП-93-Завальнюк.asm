INCLUDE \masm32\include\masm32rt.inc

.data
    msg_title       DB "Лабораторна робота 5", 0
    msg_last_final  DB "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
    msg_final              DB "a = %s, b = %s, c = %s, результат = %s", 0
    msg_neg_format         DB "-%d", 0
    msg_pos_format         DB "%d", 0
    msg_not_even_format    DB "%d", 0

    buff_last_final        DB 512 DUP (0)
    first_row              DB 064 DUP (0)
    second_row             DB 064 DUP (0)
    third_row              DB 064 DUP (0)
    fourth_row             DB 064 DUP (0)
    fifth_row              DB 064 DUP (0)
    a_element              DB 008 DUP (0)
    b_element              DB 008 DUP (0)
    c_element              DB 008 DUP (0)
    buff_res               DB 008 DUP (0)
    buff_res_final         DB 016 DUP (0)
    current_buff_addr      DD 0

    res                    DB 0
    coeffs_a               DB -3, -3, -2, -1, 3
    coeffs_b               DB 2, 2, -2, -1, -2
    coeffs_c               DB 4, 2, 2, 3, 4

; (c / b - 24 + a) / (2 * a * c - 1)
calculate_the_row MACRO a, b, c_
	xor ax,ax
    MOV AL, 1
	INC AL
    IMUL a
	cbw
    IMUL c_
	cbw
    DEC AL
	cbw
    MOV res, AL
	cbw
    MOV AL, 1
	cbw
    IMUL c_
	cbw
    IDIV b
	cbw
	ADD AL, a
	cbw
    SUB AL, 24
	cbw
    IDIV res
	cbw
ENDM

invoke_fixed_number MACRO buffer, number
    LOCAL NOT_EVEN
    LOCAL QUIT

    MOV BL, number
	cbw
    SAR BL, 1
	cbw
    JB NOT_EVEN

    INVOKE wsprintf, addr buffer, addr msg_not_even_format, BL
    JMP QUIT

    NOT_EVEN:
    MOV AL, 5
	cbw
    IMUL number
	cbw
    INVOKE wsprintf, addr buffer, addr msg_not_even_format, AL
    
    QUIT:
ENDM

invoke_single_number MACRO buffer, number
    LOCAL POSITIVE_NUMBER
    LOCAL QUIT
    MOV     CL, number
    TEST    CL, CL
    JNS     POSITIVE_NUMBER

    NEG CL
    INVOKE wsprintf, addr buffer, addr msg_neg_format, CL
    JMP QUIT

    POSITIVE_NUMBER:
    INVOKE wsprintf, addr buffer, addr msg_pos_format, CL

    QUIT:
ENDM

get_the_row MACRO buffer, index
    invoke_single_number a_element, coeffs_a[index]
    invoke_single_number b_element, coeffs_b[index]
    invoke_single_number c_element, coeffs_c[index]

    calculate_the_row coeffs_a[index], coeffs_b[index], coeffs_c[index]
    MOV res, AL
    
    invoke_fixed_number buff_res_final, res

    INVOKE wsprintf, buffer, addr msg_final,
        addr a_element,
        addr b_element,
        addr c_element,
        addr buff_res_final
ENDM


.code
    start:
        MOV EDI, 0
        MOV current_buff_addr, offset first_row

        calculation:
        get_the_row current_buff_addr, EDI

        ADD current_buff_addr, 64
        INC EDI
        CMP EDI, 5
        JNE calculation

        INVOKE wsprintf, addr buff_last_final, addr msg_last_final, addr first_row, addr second_row, addr third_row, addr fourth_row, addr fifth_row

        INVOKE MessageBox, 0, addr buff_last_final, addr msg_title, MB_OK
        INVOKE ExitProcess, 0
    END start