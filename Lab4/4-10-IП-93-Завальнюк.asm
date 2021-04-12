.386
.model flat, stdcall
option casemap :none   

include /masm32/include/windows.inc
include /masm32/include/user32.inc
include /masm32/include/kernel32.inc
includelib /masm32/lib/user32.lib
includelib /masm32/lib/kernel32.lib

.data
	; Password
	password db "nlgc`"
	length_of_password dw 5
	KEY DB 9h
	; Attributes variables for windows
	static_attr db "static", 0
	edit_attr db "edit", 0
    button_attr db "button", 0
	; Text variables
	student_name db "ПІБ: Завальнюк М.Є.", 0
	student_number db "Номер залікової книги: 9312", 0
	student_date db "Дата народження: 09.11.2001", 0
	; Text for windows
	greeting_text db "Введіть пароль:", 0
	error_text db "Помилка! Перевірте введений вами пароль.", 0
	on_button_text db "Ввести", 0
	hInstance 		dd ?
	lpszCmdLine		dd ?
	edit_field 		HWND ?
	input_text db 64 DUP (?)

Main_WINDOW proto :dword, :dword, :dword, :dword
Our_WINDOW proto :dword, :dword, :dword, :dword	

szText macro name, text:vararg
	; Macros for changing text
	;; Useless thing
	local lbl
	jmp	lbl
	name db text, 0
	lbl:
endm

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

.code
start:
	invoke 	GetModuleHandle, NULL
	MOV	hInstance, eax

	invoke	GetCommandLine
	MOV	lpszCmdLine, eax

	invoke 	Main_WINDOW, hInstance, NULL, lpszCmdLine, SW_SHOWDEFAULT
	invoke	ExitProcess, eax

Main_WINDOW proc hInst:dword, hPrevInst:dword, szCmdLine:dword, nShowCmd:dword
	; Our main window
	local 	wc 	:WNDCLASSEX
	local 	msg 	:MSG
	local 	hWnd 	:HWND

	; Set title texts with macroses
	szText	szClassName, "Main_Window"
	szText	szWindowTitle, "Лабораторна номер 4"
	
	MOV	wc.cbSize, sizeof WNDCLASSEX
	MOV	wc.style, CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNWINDOW
	MOV wc.lpfnWndProc, Our_WINDOW
	MOV wc.cbClsExtra, NULL
	MOV	wc.cbWndExtra, NULL

	PUSH hInst
	POP wc.hInstance

	MOV	wc.hbrBackground, COLOR_BTNFACE + 1
	MOV	wc.lpszMenuName, NULL
	MOV wc.lpszClassName, offset szClassName

	invoke LoadIcon, hInst, IDI_APPLICATION
	MOV	wc.hIcon, eax
	MOV	wc.hIconSm, eax

	invoke LoadCursor, hInst, IDC_ARROW
	MOV	wc.hCursor, eax

	invoke RegisterClassEx, ADDR wc

	invoke CreateWindowEx, WS_EX_APPWINDOW, OFFSET szClassName, OFFSET szWindowTitle,
				WS_OVERLAPPEDWINDOW, 
				300, 300, 360, 263, 
				NULL, NULL, hInst, NULL

	MOV	hWnd, eax

	invoke	ShowWindow, hWnd, nShowCmd
	invoke	UpdateWindow, hWnd

MessageCreating:
	; Create the message window
	;; Useless thing
	invoke GetMessage, ADDR msg, NULL, 0, 0
	CMP eax, 0
	JE MessageDestructing
	invoke TranslateMessage, ADDR msg
	invoke DispatchMessage, ADDR msg
	JMP MessageCreating

MessageDestructing:
	; Destruct the message window
	;; Usefull thing
	MOV	eax, msg.wParam
	RET

Main_WINDOW endp


Our_WINDOW proc hWnd: dword, uMsg: dword, wParam: dword, lParam: dword
	; Create our window
	; Create the main window
	.if uMsg==WM_CREATE
	; Show greeting text
		invoke CreateWindowEx,NULL,
                OFFSET static_attr,
                OFFSET greeting_text,
                WS_VISIBLE or WS_CHILD or SS_CENTER,
                0, 2, 140, 20, hWnd, 5146, hInstance, NULL
	; Show input field for text
		invoke CreateWindowEx,NULL,
                OFFSET edit_attr,
                NULL,
                WS_VISIBLE or WS_CHILD or ES_LEFT or ES_AUTOHSCROLL or ES_AUTOVSCROLL or WS_BORDER,
                140, 0, 100, 20, hWnd, 9273, hInstance, NULL 
        MOV edit_field, eax
	; Show button with text
        invoke CreateWindowEx,NULL,
                OFFSET button_attr,
                OFFSET on_button_text,
                WS_VISIBLE or WS_CHILD,
				251, 0, 80, 20, hWnd, 44832, hInstance, NULL
	; Close the window
	.elseif uMsg == WM_CLOSE
		invoke 	PostQuitMessage, 0
		XOR	eax, eax
		RET
	; Main part
	.elseif uMsg == WM_COMMAND
    	CMP wParam, 44832
    	JNE QUIT
    	invoke SendMessage, edit_field, WM_GETTEXT, 40, OFFSET input_text
		MOV di, 0

		; COMPARING
		COMPARING:
    	CMP ax, length_of_password
		JNE SHOW_ERROR
		; Call macroses
		DECRYPT input_text
		COMPARE input_text
		cmp bl, 0
		jne SHOW_DATA
    	SHOW_ERROR:
		; Show error while input text
		SHOW_TEXT OFFSET error_text, 50
    	JMP QUIT
		
    	SHOW_DATA:
		; Show my data
		SHOW_TEXT OFFSET student_name, 50
		SHOW_TEXT OFFSET student_number, 70
		SHOW_TEXT OFFSET student_date, 110
	.else
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam 
        RET
	.endif
		QUIT:
    	XOR eax, eax
    	RET
Our_WINDOW endp

end start