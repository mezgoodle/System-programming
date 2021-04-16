macrosDeshifr macro symbols
	local quit
	; Macros for decrypting
	;; Decrypting the input text
	local decrypting
	MOV di, 0
	; Main part
    decrypting:
	MOV dh, generatedKey
    XOR symbols[di], dh
    INC di
    CMP di, santimeteres
    JE quit
	LOOP decrypting
	quit:
endm

invokeTexting macro text, y_ordinate
	; Macros for showing
	;;Show data in window interface
	invoke CreateWindowEx,NULL,
        addr attributeOne,
        text,
        WS_VISIBLE or WS_CHILD or SS_CENTER, 75, y_ordinate, 150, 100, hWnd, 4483, hInstance, NULL
endm

macrosConditional macro symbols
	local motorcycle
	; Macros for comparing
	;;Comparing the input text and password
	local quit
	MOV di, -1
	; Main part
    motorcycle:
	INC di
    CMP di, santimeteres
	JE quit
	MOV BL, symbols[di]
	MOV BH, password_array[di]
    CMP BL, BH
    JNE erroring
	LOOP motorcycle
	quit:
endm

