SHOW_TEXT macro text, y
	; Macros for showing
	;; Show data in window interface
	invoke CreateWindowEx,NULL,
        addr static_attr,
        text,
        SS_CENTER or WS_CHILD or WS_VISIBLE,
        75, y, 150, 100, hWnd, 2001, hInstance, NULL
endm

COMPARE macro input
	; Macros for comparing
	;; Comparing the input text and password
	local COMPARING
	local QUIT
	MOV edi, -1
    COMPARING:
	INC edi
    CMP edi, length_of_password
	JE QUIT
	MOV BL, input[edi]
	MOV BH, password[edi]
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
	MOV edi, 0
    DECRYPTING:
	MOV dh, KEY
    XOR input[edi], dh
    INC edi
    CMP edi, length_of_password
    JE QUIT
	LOOP DECRYPTING
	QUIT:
endm