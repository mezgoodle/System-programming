SHOW_TEXT macro text, x, y
	; Macros for showing
	;; Show data in window interface
	invoke CreateWindowEx,NULL,
        addr static_attr,
        text,
        WS_VISIBLE or WS_CHILD or SS_CENTER,
        x,
        y,
        150,
        100,
        hWnd,
        2001,
        hInstance,
        NULL
endm

COMPARE macro input
	; Macros for comparing
	;; Comparing the input text and password
	local COMPARING
	local QUIT
	MOV di, -1
    COMPARING:
	INC di
    CMP di, password_length
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
    DECRYPTING:
	MOV dh, KEY
    XOR input[di], dh
    INC di
    CMP di, password_length
    JE QUIT
	LOOP DECRYPTING
	QUIT:
endm