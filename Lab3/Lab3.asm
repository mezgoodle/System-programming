.386
.model flat, stdcall
option casemap :none   

include /masm32/include/windows.inc
include /masm32/include/user32.inc
include /masm32/include/kernel32.inc
includelib /masm32/lib/user32.lib
includelib /masm32/lib/kernel32.lib

szText macro name, text:vararg
	local lbl
	jmp	lbl
	name db text, 0
	lbl:
endm

WinMain proto :dword, :dword, :dword, :dword
WndProc proto :dword, :dword, :dword, :dword

.data
	data db "Завальнюк М.Є.", 13, "9312", 13, "09.11.2001", 0
	text db "Введіть пароль:", 0
	err db "Помилка! Перевірте введений вами пароль.", 0
	msg_title db "Дані", 0
	butt_text db "Ввести", 0
	static db "static", 0
	edit db "edit", 0
    butt db "button", 0
	pass db "genji"
	pass_len dw 5

.data?
	hInstance 		dd ?
	lpszCmdLine		dd ?
	hEditText 		HWND ?
	input db 64 DUP (?)

.code
start:
	invoke 	GetModuleHandle, NULL
	mov	hInstance, eax

	invoke	GetCommandLine
	mov	lpszCmdLine, eax

	invoke 	WinMain, hInstance, NULL, lpszCmdLine, SW_SHOWDEFAULT
	invoke	ExitProcess, eax

WinMain proc 	hInst 		:dword, 
		hPrevInst 	:dword,
		szCmdLine 	:dword,
		nShowCmd 	:dword

	local 	wc 	:WNDCLASSEX
	local 	msg 	:MSG
	local 	hWnd 	:HWND

	szText	szClassName, "BasicWindow"
	szText	szWindowTitle, "Лабораторна номер 3"

	mov	wc.cbSize, sizeof WNDCLASSEX
	mov	wc.style, CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNWINDOW
	mov 	wc.lpfnWndProc, WndProc
	mov 	wc.cbClsExtra, NULL
	mov	wc.cbWndExtra, NULL

	push	hInst
	pop 	wc.hInstance

	mov	wc.hbrBackground, COLOR_BTNFACE + 1
	mov	wc.lpszMenuName, NULL
	mov 	wc.lpszClassName, offset szClassName

	invoke	LoadIcon, hInst, IDI_APPLICATION
	mov	wc.hIcon, eax
	mov	wc.hIconSm, eax

	invoke	LoadCursor, hInst, IDC_ARROW
	mov	wc.hCursor, eax

	invoke	RegisterClassEx, addr wc

	invoke	CreateWindowEx, WS_EX_APPWINDOW, addr szClassName, addr szWindowTitle,
				WS_OVERLAPPEDWINDOW, 
				300, 300, 300, 300, 
				NULL, NULL, hInst, NULL

	mov	hWnd, eax

	invoke	ShowWindow, hWnd, nShowCmd
	invoke	UpdateWindow, hWnd

MessagePump:
	invoke 	GetMessage, addr msg, NULL, 0, 0

	cmp 	eax, 0
	je 	MessagePumpEnd

	invoke	TranslateMessage, addr msg
	invoke	DispatchMessage, addr msg

	jmp 	MessagePump

MessagePumpEnd:

	mov	eax, msg.wParam
	ret

WinMain endp


WndProc proc 	hWnd 	:dword,
		uMsg 	:dword,
		wParam 	:dword,
		lParam 	:dword

	.if uMsg==WM_CREATE
		invoke CreateWindowEx,NULL,
                addr static,
                addr text,
                WS_VISIBLE or WS_CHILD or SS_CENTER,
                70,
                90,
                150,
                20,
                hWnd,
                2001,
                hInstance,
                NULL
		invoke CreateWindowEx,NULL,
                addr edit,
                NULL,
                WS_VISIBLE or WS_CHILD or ES_LEFT or ES_AUTOHSCROLL or ES_AUTOVSCROLL or WS_BORDER,
                70,
                110,
                150,
                20,
                hWnd,
                2000,
                hInstance,
                NULL 
        mov hEditText, eax
        invoke CreateWindowEx,NULL,
                addr butt,
                addr butt_text,
                WS_VISIBLE or WS_CHILD,
                70,
                130,
                150,
                20,
                hWnd,
                2002,
                hInstance,
                NULL
	.elseif uMsg == WM_DESTROY
		invoke 	PostQuitMessage, 0
		xor	eax, eax
		ret
		.elseif uMsg == WM_COMMAND
    	cmp wParam, 2002
    	jne quit
    	invoke SendMessage, hEditText, WM_GETTEXT, 40, addr input
		mov di, 0
		cycle:
    	cmp ax, pass_len
		jne err_msg
    	
    	
    	mov BL, input[di]
		mov BH, pass[di]
    	cmp BL, BH
		JNE err_msg
		; INCREASING COUNTER
		inc di
		cmp di, pass_len
    	je data_msg
		LOOP       cycle
		
    	err_msg:
    	invoke MessageBox, hWnd, addr err, addr msg_title, MB_OK
    	jmp quit
    	data_msg:
    	invoke MessageBox, hWnd, addr data, addr msg_title, MB_OK
	.else
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam 
        ret
	.endif
		quit:
    	xor eax, eax
    	ret
WndProc endp

end start
