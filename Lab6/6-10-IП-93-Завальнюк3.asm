.386
;������� ��������
.model flat, stdcall
option CaseMap:None

;ϳ�'������� ���������� �������
include /masm32/include/masm32rt.inc

.data
	;���������� �����
	;;���������
	calculation            Dq 0
	a_arr 			dq 0.3, 15.7, -3.6, 5.3, 11.2
	b_arr			dq 1.98, -6.1, 5.7, 8.1, 18.3
	c_arr			dq 3.9, -20.4, 17.5, -36.6, 21.1
	d_arr			dq -1.0, -41.4, 3.1, -8.9, -8.4
	y_output		dd 60,110,160,210,260
	constants       dq 4.0, 2.0
	;;ʳ������ �����
	rows				   DD 5
	;;�������� �����
	stepWith         DD 0
	;;������ ����������� �����
	textOfNegativeNumber   DB "-%i", 0
	;;������ ����������� �����
    textOfPossitiveNumber  DB "%i", 0
	TEXT  DB "(4*c + d - 1) / (b - tg(a / 2))", 0
	;;����� ��������������� ���� ������
    textOfWindow       	   DB "���������� ����������", 0
	;;������ ��� ����������
    allResultsInOnePlace   DB "������� �i������ -  %s", 10, "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
	;;������ �����-����������
    textOfRow              DB "a = %s, b = %s, c = %s, d = %s, ��������� = %s", 0
	zero DQ -1.0
    
	
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
	maininfo              DB 128 DUP (?)
	
.data?
	
	buff_res db 128 dup(?)
	buff_a db 32 dup(?)
	buff_b db 32 dup(?)
	buff_c db 32 dup(?)
	buff_d db 32 dup(?)
	

;������ ��� ��������� �����
calculateTheRow macro a_num, b_num, c_num, d_num
	finit
		
	fld constants[0] ; st(0) = 4
	fld c_num		 ; st(0) = c, st(1) = 4
	fmul 			 ; st(0) = st(1) * st(0)
	
	

	; 4*c = 15,6
	; ^ works

	fld d_num ; st(0) = d, st(1) = 4*c
	
	fcom    zero 
    fstsw   AX
    SAHF
    JE      division_by_zero
	
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

	fstp calculation
	
	; (-2*c - sin(a/d) + 53)/(a/4 - b)
	division_by_zero:
	JMP quit
	quit:
endm

;������ ��� ��������� ������ �����
getTheRow macro place, index
	;;����� �����������
	;;��������� �� ��������� �����������
    calculateTheRow a_arr[index*8], b_arr[index*8], c_arr[index*8], d_arr[index*8]
	;;����� ������������ ���������
	invoke FloatToStr2, a_arr[index*8], addr buff_a
	invoke FloatToStr2, b_arr[index*8], addr buff_b
	invoke FloatToStr2, c_arr[index*8], addr buff_c
	invoke FloatToStr2, d_arr[index*8], addr buff_d
	invoke FloatToStr2, calculation, addr buff_res
	;;����� ������ �����
    invoke wsprintf, place, addr textOfRow, addr buff_a, addr buff_b, addr buff_c, addr buff_d, addr buff_res
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
		invoke wsprintf, addr maininfo, addr TEXT
        invoke wsprintf, addr endShowing, addr allResultsInOnePlace, addr maininfo, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow
        invoke MessageBox, NULL, offset endShowing, offset textOfWindow, MB_OK
		;;��������� ��������
        invoke ExitProcess, NULL
    end start