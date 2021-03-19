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
	password db "genji"
	password_length dw 5
	; Attributes variables for windows
	static_attr db "static", 0
	edit_attr db "edit", 0
    button_attr db "button", 0
	; Text variables
	data db "ϲ�: ��������� �.�.", 13, "����� ������� �����: 9312", 13, "���� ����������: 09.11.2001", 0
	greeting_text db "������ ������:", 0
	error_text db "�������! �������� �������� ���� ������.", 0
	title_text db "����", 0
	error_title_text db "�������!", 0
	on_button_text db "������", 0
	hInstance 		dd ?
	lpszCmdLine		dd ?
	edit_field 		HWND ?
	input_text db 64 DUP (?)

Main_WINDOW proto :dword, :dword, :dword, :dword
Our_WINDOW proto :dword, :dword, :dword, :dword	

szText macro name, text:vararg
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

	local 	wc 	:WNDCLASSEX
	local 	msg 	:MSG
	local 	hWnd 	:HWND

	szText	szClassName, "Main_Window"
	szText	szWindowTitle, "����������� ����� 3"

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

	invoke CreateWindowEx, WS_EX_APPWINDOW, ADDR szClassName, ADDR szWindowTitle,
				WS_OVERLAPPEDWINDOW, 
				300, 300, 360, 63, 
				NULL, NULL, hInst, NULL

	MOV	hWnd, eax

	invoke	ShowWindow, hWnd, nShowCmd
	invoke	UpdateWindow, hWnd

PumpTheMessage:
	invoke GetMessage, ADDR msg, NULL, 0, 0

	CMP eax, 0
	JE PumpTheMessageEnd

	invoke TranslateMessage, ADDR msg
	invoke DispatchMessage, ADDR msg

	JMP PumpTheMessage

PumpTheMessageEnd:

	MOV	eax, msg.wParam
	RET

Main_WINDOW endp


Our_WINDOW proc 	hWnd 	:dword,
		uMsg 	:dword,
		wParam 	:dword,
		lParam 	:dword

	; Create the main window
	.if uMsg==WM_CREATE
	; Show greeting text
		invoke CreateWindowEx,NULL,
                ADDR static_attr,
                ADDR greeting_text,
                WS_VISIBLE or WS_CHILD or SS_CENTER,
                0,
                2,
                140,
                20,
                hWnd,
                0001,
                hInstance,
                NULL
	; Show input field for text
		invoke CreateWindowEx,NULL,
                ADDR edit_attr,
                NULL,
                WS_VISIBLE or WS_CHILD or ES_LEFT or ES_AUTOHSCROLL or ES_AUTOVSCROLL or WS_BORDER,
                140,
                0,
                100,
                20,
                hWnd,
                0000,
                hInstance,
                NULL 
        MOV edit_field, eax
	; Show button with text
        invoke CreateWindowEx,NULL,
                ADDR button_attr,
                ADDR on_button_text,
                WS_VISIBLE or WS_CHILD,
				251,
                0,
                80,
                20,
                hWnd,
                0002,
                hInstance,
                NULL
	; Close the window
	.elseif uMsg == WM_CLOSE
		invoke 	PostQuitMessage, 0
		XOR	eax, eax
		RET
	; Main part
	.elseif uMsg == WM_COMMAND
    	CMP wParam, 0002
    	JNE QUIT
    	invoke SendMessage, edit_field, WM_GETTEXT, 40, ADDR input_text
		MOV di, 0

		; COMPARING
		COMPARING:
    	CMP ax, password_length
		JNE SHOW_ERROR
    	MOV BL, input_text[di]
		MOV BH, password[di]
    	CMP BL, BH
		JNE SHOW_ERROR
		
		; INCREASING COUNTER
		INC di
		CMP di, password_length
		; Check the finish
    	JE SHOW_DATA
		LOOP COMPARING
		
    	SHOW_ERROR:
		; Show error while input text
    	invoke MessageBox, hWnd, ADDR error_text, ADDR error_title_text, MB_OK
    	JMP QUIT
		
    	SHOW_DATA:
		; Show my data
    	invoke MessageBox, hWnd, ADDR data, ADDR title_text, MB_OK
	.else
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam 
        RET
	.endif
		QUIT:
    	XOR eax, eax
    	RET
Our_WINDOW endp

end start