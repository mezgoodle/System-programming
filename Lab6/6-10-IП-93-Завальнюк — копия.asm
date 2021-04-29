.386
;������� ��������
.model flat, stdcall
option CaseMap:None

;ϳ�'������� ���������� �������
include /masm32/include/windows.inc
include /masm32/include/user32.inc
include /masm32/include/kernel32.inc
include /masm32/include/fpu.inc
include /masm32/include/msvcrt.inc

includelib /masm32/lib/user32.lib
includelib /masm32/lib/kernel32.lib
includelib /masm32/lib/fpu.lib
includelib /masm32/lib/msvcrt.lib

.data
	;���������� �����
	;;���������
	calculation            DB 0
	;;����������� �
    coeffsA                DB -3, -3, -2, -1, 3
	;;����������� �
    coeffsB                DB 2, 2, -2, -1, -2
	;;����������� �
    coeffsC                DB 4, 2, 2, 3, 4
	;;ʳ������ �����
	rows				   DD 5
	;;�������� �����
	stepWith         DD 0
	;;������ ����������� �����
	textOfNegativeNumber   DB "-%i", 0
	;;������ ����������� �����
    textOfPossitiveNumber  DB "%i", 0
	;;����� ��������������� ���� ������
    textOfWindow       	   DB "���������� ����������", 0
	;;������ ��� ����������
    allResultsInOnePlace   DB "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
	;;������ �����-����������
    textOfRow              DB "a = %s, b = %s, c = %s, ��������� = %s", 0
    
	
.data?
	;���������� �����
	;;������� � ������ �
    aElement              DB 16 DUP (?)
	;;������� � ������ �
    bElement              DB 16 DUP (?)
	;;������� � ������ �
    cElement              DB 16 DUP (?)
	;;��������� ������
	endShowing             DB 1024 DUP (?)
	;;������ ���������
    firstRow              DB 128 DUP (?)
	;;������ ���������
    secondRow             DB 128 DUP (?)
	;;����� ���������
    thirdRow              DB 128 DUP (?)
	;;��������� ���������
    fourthRow             DB 128 DUP (?)
	;;�'���� �����
    fifthRow              DB 128 DUP (?)
	;;����� �����
	rowShowing       	   DB 32 DUP (?)

;������ ��� ��������� �����
calculateTheRow macro index, a_num, b_num, c_num, d_num
	finit
		
	fld 4.0 ; st(0) = 4
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
	fld 2.0 ; st(0) = 2, st(1) = a, st(2) = b, st(3) = 4*c+d-1
	
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

	;invoke FpuFLtoA, addr res, 20, addr buffer, SRC1_REAL - ����������� ��� ��� �������������(res dt, ��� ������ ������� �� dq)
	invoke crt_sprintf, addr res_str, addr output, index, a_num, b_num, c_num, d_num, res
endm

;������ ��� ������ �������� ����������
invokeFixedNumber macro place, number
	;;���������� ��������
    local quit
	local notEven
	;;�����������
    mov AL, number
	;;����� � �����
    sar AL, 1
    jb notEven
	;;����� �����
	;;����� �����
	cwde
    invoke wsprintf, addr place, 
					 addr textOfPossitiveNumber, eax
    jmp quit
	;;������� �����
    notEven:
    mov BL, 5
    mov AL, number
    imul BL
	;;����� �����
	cwde
    invoke wsprintf, addr place, 
					 addr textOfPossitiveNumber, eax
    ;;����� � �������
    quit:
endm

;������ ��� ������ �����������
invokeSingleNumber macro place, number
	;;���������� ��������
    local quit
	local plusNumber
	;;�����������
	mov CL, -1
    mov     AL, number
    test    AL, AL
    jns     plusNumber
	cbw
	;;��������
    imul CL
	;;³�'���� �����
	;;����� �����
    invoke wsprintf, addr place, 
					 addr textOfNegativeNumber, AL
    jmp quit
	;;������ �����
    plusNumber:
	;;����� �����
    invoke wsprintf, addr place, 
					 addr textOfPossitiveNumber, AL
	;;����� � �������
    quit:
endm

;������ ��� ��������� ������ �����
getTheRow macro place, index
	;;����� �����������
    invokeSingleNumber aElement, coeffsA[index]
    invokeSingleNumber bElement, coeffsB[index]
    invokeSingleNumber cElement, coeffsC[index]
	;;��������� �� ��������� �����������
    calculateTheRow coeffsA[index], coeffsB[index], coeffsC[index]
    mov calculation, AL
	;;����� ������������ ���������
    invokeFixedNumber rowShowing, calculation
	;;����� ������ �����
    invoke wsprintf, place, addr textOfRow, addr aElement, addr bElement, addr cElement, addr rowShowing
endm

.code
	;;������� ������ code
    start:
		;;���������� ������
        mov stepWith, offset firstRow
		;;�����������
		mov EDI, NULL
		;���� ��� �'��� �����
        calculationLoop:
        getTheRow stepWith, EDI
        add stepWith, 128
		;;ϳ�������� �������
        add EDI, 1
		;��������� �� ����� ��������
        CMP EDI, rows
        JNE calculationLoop
		;����� ��� �����
        invoke wsprintf, addr endShowing, addr allResultsInOnePlace, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow
        invoke MessageBox, NULL, offset endShowing, offset textOfWindow, MB_OK
		;;��������� ��������
        invoke ExitProcess, NULL
    end start