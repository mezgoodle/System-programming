.386
.model flat, stdcall
option casemap :none   

include /masm32/include/windows.inc
include /masm32/include/user32.inc
include /masm32/include/kernel32.inc
includelib /masm32/lib/user32.lib
includelib /masm32/lib/kernel32.lib
include 4-10-IП-93-Завальнюк-1.inc

.data
	; Attributes variables for windows
	attributeOne db "static", 0
	; Text variables
	myName db "ПІБ: Завальнюк М.Є.", 0
	someDigit db "Номер залікової книги: 9312", 0
	goodDay db "Дата народження: 09.11.2001", 0
	attributeDva db "edit", 0
	; Password
	password_array db "nlgc`"
	santimeteres dw 5
	generatedKey DB 9h
	; Text for windows
	hInstance 		dd ?
	lpszCmdLine		dd ?
	edit_field 		HWND ?
	input_text db 64 DUP (?)
	neutralText db "Введіть пароль:", 0
	badText db "Помилка! Перевірте введений вами пароль.", 0
	on_button_text db "Ввести", 0
	attributeThree db "button", 0

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
                OFFSET attributeOne,
                OFFSET neutralText,
                WS_VISIBLE or WS_CHILD or SS_CENTER,
                0, 2, 140, 20, hWnd, 5146, hInstance, NULL
	; Show input field for text
		invoke CreateWindowEx,NULL,
                OFFSET attributeDva,
                NULL,
                WS_VISIBLE or WS_CHILD or ES_LEFT or ES_AUTOHSCROLL or ES_AUTOVSCROLL or WS_BORDER,
                140, 0, 100, 20, hWnd, 9273, hInstance, NULL 
        MOV edit_field, eax
	; Show button with text
        invoke CreateWindowEx,NULL,
                OFFSET attributeThree,
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
    	JNE finishing
    	invoke SendMessage, edit_field, WM_GETTEXT, 40, OFFSET input_text
		MOV edi, 0

		; COMPARING
		motorcycling:
    	CMP ax, santimeteres
		JNE erroring
		; Call macroses
		macrosDeshifr input_text
		macrosConditional input_text
		cmp bl, 0
		jne printing
    	erroring:
		; Show error while input text
		invokeTexting OFFSET badText, 50
    	JMP finishing
		
    	printing:
		; Show my data
		invokeTexting OFFSET myName, 50
		invokeTexting OFFSET someDigit, 70
		invokeTexting OFFSET goodDay, 110
	.else
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam 
        RET
	.endif
		finishing:
    	XOR eax, eax
    	RET
Our_WINDOW endp

end start