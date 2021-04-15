INCLUDE \masm32\include\masm32rt.inc

; (c / b - 24 + a) / (2 * a * c - 1)
calc MACRO a, b, d
	xor ax,ax          ; очистили регистр ax
    MOV AL, 2    ; в al - 2
    IMUL a      ; 2 * a       -> AL
	cbw
    IMUL d   ; 2 * a * c      -> AL
	cbw
    DEC AL  ; 2 * a * c - 1 -> AL
	cbw
    MOV res, AL   ; 2 * a * c - 1 -> res
	cbw
    MOV AL, 1   ; preparing multiplication
	cbw
    IMUL d      ; 1 * с         -> AL
	cbw
    IDIV b    ; 1 * с / b     -> AL
	cbw
    SUB AL, 24      ; 1 * c / b - 24 -> AL
	cbw
	ADD AL, a   ; 1 * c / b - 24 + a
	cbw
    IDIV res ; (c / b - 24 + a) / (2 * a * c - 1) -> AL, AH = 0
cbw
	;cbw
ENDM

finalCalc MACRO n, buffer
    LOCAL odd
    LOCAL fin

    MOV BL, n
	cbw
    SAR BL, 1
	cbw
    JB odd

    INVOKE wsprintf, addr buffer, addr msg_even_format, BL
    JMP fin

    odd:
    MOV AL, 5
	cbw
    IMUL n
	cbw
    INVOKE wsprintf, addr buffer, addr msg_odd_format, AL
    
    fin:
ENDM

printNum MACRO n, buffer
    LOCAL pos
    LOCAL fin
    MOV     CL, n
    TEST    CL, CL
    JNS     pos

    NEG CL
    INVOKE wsprintf, addr buffer, addr msg_neg_format, CL
    JMP fin

    pos:
    INVOKE wsprintf, addr buffer, addr msg_pos_format, CL

    fin:
ENDM

getExpression MACRO i, buff
    printNum coeffs_a[i], a_element
    printNum coeffs_b[i], b_element
    printNum coeffs_c[i], c_element

    calc coeffs_a[i], coeffs_b[i], coeffs_c[i]
    MOV res, AL
    
    finalCalc res, buff_res_final

    INVOKE wsprintf, buff, addr msg_final,
        addr a_element,
        addr b_element,
        addr c_element,
        addr buff_res_final
ENDM

.data
    msg_title       DB "Лабораторна робота 5", 0
    msg_last_final  DB "1. %s", 10,
        "2. %s", 10,
        "3. %s", 10,
        "4. %s", 10,
        "5. %s", 0
    msg_final              DB "a = %s, b = %s, c = %s, результат = %s", 0
    msg_neg_format         DB "(-%d)", 0
    msg_pos_format         DB "%d", 0
    msg_odd_format         DB "%d", 0
    msg_even_format        DB "%d", 0

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
    coeffs_a                      DB -3, -3, -2, -1, 3
    coeffs_b                      DB 2, 2, -2, -1, -2
    coeffs_c                      DB 4, 2, 2, 3, 4
.code
    start:
        MOV EDI, 0
        MOV current_buff_addr, offset first_row

        hereWeGoAgain:
        getExpression EDI, current_buff_addr

        ADD current_buff_addr, 64
        INC EDI
        CMP EDI, 5
        JB hereWeGoAgain

        INVOKE wsprintf, addr buff_last_final, addr msg_last_final,
            addr first_row,
            addr second_row,
            addr third_row,
            addr fourth_row,
            addr fifth_row

        INVOKE MessageBox, 0, addr buff_last_final, addr msg_title, MB_OK
        INVOKE ExitProcess, 0
    END start