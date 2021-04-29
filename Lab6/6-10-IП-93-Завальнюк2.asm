    .486
    .model flat, stdcall
    option casemap :none 
	.lall


    include /masm32/include/windows.inc
    include /masm32/include/user32.inc
    include /masm32/include/kernel32.inc
    include /masm32/include/fpu.inc
    include /masm32/include/msvcrt.inc
 
    includelib /masm32/lib/user32.lib
    includelib /masm32/lib/kernel32.lib
    includelib /masm32/lib/fpu.lib
    includelib /masm32/lib/msvcrt.lib

	szText macro name, text
		local 	lbl
		jmp	lbl
		name 	db text, 0
		lbl:
	endm

	showData macro x_cor, y_cor, text 
		invoke CreateWindowEx,NULL,
                addr classStatic,
                text,
                WS_VISIBLE or WS_CHILD or SS_CENTER,
                x_cor,
                y_cor,
                400,
                60,
                hWnd,
                2001,
                hInstance,
                NULL
	endm

	;(4*c+d-1)/(b-tg(a/2))
	count macro index, a_num, b_num, c_num, d_num
		finit
		
		fld constants[0] ; st(0) = 4
		fld c_num		 ; st(0) = c, st(1) = 4
		fmul 			 ; st(0) = st(1) * st(0)

		; 4*c = 15,6
		; ^ works

		fld d_num ; st(0) = d, st(1) = 4*c
		
		fadd ; st(0) = st(1) + st(0) = 4*c+d
		
		; 4*c+d = 11,5
		; ^ works

		fld1 ; st(0) = 1, st(1) = 4*c+d
		fsub ; st(0) = st(1) - st(0) = 4*c+d-1

		; 4*c+d-1 = 10,5
		; ^ works
		
		fld b_num ; st(0) = b, st(1) = 4*c+d-1
		
		fld a_num ; st(0) = a, st(1) = b, st(2) = 4*c+d-1
		fld constants[8] ; st(0) = 2, st(1) = a, st(2) = b, st(3) = 4*c+d-1
		
		fdiv ; st(0) = st(1)/st(0) = a/2, st(1) = b, st(2) = 4*c+d-1
		
		; a/2 = 0,15
		; ^ works
		
		fptan ; st(0) = 1, st(1) = tg(st(0)) st(2) = b, st(3) = 4*c+d-1
		fdiv ; st(0) = st(1)/st(0) = tg(a/2), st(1) = b, st(2) = 4*c+d-1
		
		; tg(a/2) = 0,151135
		; ^ works
		
		fsub ; st(0) = st(1)-st(0) = b-tg(a/2), st(1) = 4*c+d-1
		
		; b-tg(a/2) = 1,82886
		; ^ works
		
		fdiv ; st(0) = st(1)/st(0) = (4*c+d-1)/(b-tg(a/2))
		
		; (4*c+d-1)/(b-tg(a/2)) = 5,74128
		; ^ works
		
		; ////////////////////////////
		
		; fld constants[0] ; st(0) = 2
		; fld c_num		 ; st(0) = c, st(1) = 2
		; fmul 			 ; st(0) = st(1) * st(0)
		
		; -2*c
		
		; fld	a_num 		 ; st(0) = a, st(1) = -2*c
		; fld d_num		 ; st(0) = d, st(1) = a, st(2) = -2*c
		; fdiv			 ; st(0) = st(1)/st(0) = a/d, st(1) = -2*c
		; fsin 			 ; st(0) = sin(st(0)) = sin(a/d), st(1) = -2*c
		; fsub			 ; st(0) = st(1) - st(0) = -2*c - sin(a/d)
		
		; -2*c - sin(a/d)
		
		; fld constants[8] ; st(0) = 53, st(1) = -2*c - sin(a/d)
		; fadd			 ; st(0) = st(1) + st(0) = -2*c - sin(a/d) + 53

		; -2*c - sin(a/d) + 53

		; fld a_num		 ; st(0) = a, st(1) = -2*c - sin(a/d) + 53
		; fld constants[16]; st(0) = 4, st(1) = a, st(2) = -2*c - sin(a/d) + 53
		; fdiv			 ; st(0) = st(1)/st(0) = a/4, st(1) = -2*c - sin(a/d) + 53

		; a/4

		; fld b_num		 ; st(0) = b, st(1) = a/4, st(2) = -2*c - sin(a/d) + 53
		; fsub 			 ; st(0) = st(1) - st(0) = a/4 - b, st(1) = -2*c - sin(a/d) + 53
		; fdiv			 ; st(0) = st(1)/st(0) = (-2*c - sin(a/d) + 53)/(a/4 - b) 

		fstp res
		
		; (-2*c - sin(a/d) + 53)/(a/4 - b)

		;invoke FpuFLtoA, addr res, 20, addr buffer, SRC1_REAL - использовал это для промежуточных(res dt, для ответа поменял на dq)
		invoke crt_sprintf, addr res_str, addr output, index, a_num, b_num, c_num, d_num, res
	endm

	WinMain proto :dword, :dword, :dword, :dword
	WndProc proto :dword, :dword, :dword, :dword

	.data
		classStatic db "static", 0
		a_arr 			dq 0.3, 15.7, -3.6, 5.3, 11.2
		b_arr			dq 1.98, -6.1, 5.7, 8.1, 18.3
		c_arr			dq 3.9, -20.4, 17.5, -36.6, 21.1
		d_arr			dq -4.1, -41.4, 3.1, -8.9, -8.4
		y_output		dd 60,110,160,210,260
		constants       dq 4.0, 2.0
		temp dq 1.905

		example 		db "( 2 * c - d / 23 ) / ( ln ( b - a / 4 ) )", 0
		output			db "%d. a:%f b:%f c:%f d:%f", 13,
						   "the answer is: %f", 0

	.data?
		hInstance 		dd ?
		lpszCmdLine		dd ?
		res				dq ? 
		buffer 			db 128 dup (?)
		res_str			db 128 dup (?)

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
	szText	szWindowTitle, "Calculation"

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
				300, 300, 450, 380, 
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
	.if uMsg == WM_CREATE
		mov edi, 0
		showData 0, 30, addr example
		cycle:
			count edi, a_arr[8*edi], b_arr[8*edi], c_arr[8*edi], d_arr[8*edi]
			showData 30, y_output[4*edi], addr res_str
			inc edi
    		cmp edi, 5
    	jne cycle

	.elseif uMsg == WM_DESTROY
		invoke 	PostQuitMessage, 0
		xor	eax, eax
		ret
	.else
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
		ret
	.endif
		stop:
    	xor eax,eax
    	ret
WndProc endp
end start
