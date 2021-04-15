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
    SAR BL, 1
    JB odd

    INVOKE wsprintf, addr buffer, addr msg_even_format, BL
    JMP fin

    odd:
    MOV AL, 5
    IMUL n
    INVOKE wsprintf, addr buffer, addr msg_odd_format, AL
    
    fin:
ENDM

printNum MACRO n, buffer
    LOCAL pos
    LOCAL fin
    MOV     CL, n
    TEST    CL, CL
    JNS     pos

    IMUL -1
    INVOKE wsprintf, addr buffer, addr msg_neg_format, CL
    JMP fin

    pos:
    INVOKE wsprintf, addr buffer, addr msg_pos_format, CL

    fin:
ENDM



getExpression MACRO i, buff
    printNum a[i], a_element
    printNum b[i], b_element
    printNum d[i], c_element
    calc a[i], b[i], d[i]
    MOV res, AL
    finalCalc res, buff_res_final
	INVOKE wsprintf, buff, addr row,
		addr a_element,
		addr b_element,
		addr c_element,
		addr buff_res_final
ENDM

.data
    msg_title       DB "Ћабораторна робота 5", 0
    msg_last_final  DB "–езультати обчислень:", 10,
        "1. %s", 10,
        "2. %s", 10,
        "3. %s", 10,
        "4. %s", 10,
        "5. %s", 0
    msg_odd_format         DB "%d", 0
    msg_even_format        DB "%d", 0
	row					   DB "a = %s, b = %s, c = %s, результат = %s", 0

    buff_last_final        DB 512 DUP (0)
    buff_final_1           DB 064 DUP (0)
    buff_final_2           DB 064 DUP (0)
    buff_final_3           DB 064 DUP (0)
    buff_final_4           DB 064 DUP (0)
    buff_final_5           DB 064 DUP (0)
    buff_a                 DB 008 DUP (0)
    buff_b                 DB 008 DUP (0)
    buff_d                 DB 008 DUP (0)
    buff_res               DB 008 DUP (0)
    buff_res_final         DB 016 DUP (0)
    current_buff_addr      DD 0

    res                    DB 0
    a                      DB -3, -3, -2, -1, -3
    b                      DB 2, 2, -2, -1, 2
    d                      DB 4, 2, 2, 3, 4
.code
    start:
        MOV EDI, 0
        MOV current_buff_addr, offset buff_final_1

        hereWeGoAgain:
        getExpression EDI, current_buff_addr

        ADD current_buff_addr, 64
        INC EDI
        CMP EDI, 5
        JB hereWeGoAgain

        INVOKE wsprintf, addr buff_last_final, addr msg_last_final,
            addr buff_final_1,
            addr buff_final_2,
            addr buff_final_3,
            addr buff_final_4,
            addr buff_final_5

        INVOKE MessageBox, 0, addr buff_last_final, addr msg_title, MB_OK
        INVOKE ExitProcess, 0
    END start