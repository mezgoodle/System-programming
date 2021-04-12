SHOW_TEXT macro text, y_ordinate
	; Macros for showing
	;;Show data in window interface
	invoke CreateWindowEx,NULL,
        addr static_attr,
        text,
        WS_VISIBLE or WS_CHILD or SS_CENTER,
        75, y_ordinate, 150, 100, hWnd, 4483, hInstance, NULL
endm

COMPARE macro input
	; Macros for comparing
	;;Comparing the input text and password
	local COMPARING
	local QUIT
	MOV di, -1
	; Main part
    COMPARING:
	INC di
    CMP di, length_of_password
	JE QUIT
	MOV BL, input[di]
	MOV BH, password[di]
    CMP BL, BH
    JNE SHOW_ERROR
	LOOP COMPARING
	QUIT:
endm

DECRYPT macro input
	; Macros for decrypting
	;; Decrypting the input text
	local DECRYPTING
	local QUIT
	MOV di, 0
	; Main part
    DECRYPTING:
	MOV dh, KEY
    XOR input[di], dh
    INC di
    CMP di, length_of_password
    JE QUIT
	LOOP DECRYPTING
	QUIT:
endm