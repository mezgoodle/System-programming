.386
;������� ��������
.model flat, stdcall
option CaseMap:None

;ϳ�'������� ���������� �������
include /masm32/include/masm32rt.inc

.data
	;���������� �����
	;;�� ����� ���
	coeffsA 			   DQ 7.36, 39.5, 6.35, 13.9, 27.5
	coeffsB			       DQ -2.25, -1.41, -9.74, 28.4, -2.66
	coeffsC				   DQ 24.3, 6.44, -16.25, 22.45, 5.53
	coeffsD				   DQ 35.9, 18.6, 32.4, 10.18, 19.18
	;;ʳ������ ����� 
	rows				   DD 5
	;;�������� �����
	stepWith         	   DD 0
	;;����� �������
	equationText           DB "(4*c + d - 1) / (b - tg(a / 2))", 0
	;;����� ��������������� ���� ������
    textOfWindow       	   DB "���������� ����������", 0
	;;������ ��� ����������
    allResultsInOnePlace   DB "������� �i������ -  %s", 10, "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
	;;������ �����-����������
    textOfRow              DB "a = %s, b = %s, c = %s, d = %s, ��������� = %s", 0
	;;��������� �� ������� �����
	bufferForResult 	   DB 2048 DUP(0)
	;;��� ��� ������
	module 			       DB "8-10-IP-93-Zavalniuk-DynamicWithIn-module", 0
	method                 DB "calculateTheRow", 0
	
.data?
	;���������� �����
	;;������� � ������ �
    aElement              DB 32 DUP (?)
	;;������� � ������ �
    bElement              DB 32 DUP (?)
	;;������� � ������ �
    cElement              DB 32 DUP (?)
	;;������� � ������ �
	dElement 			  DB 32 DUP(?)
	;;��������� ������
	endShowing            DB 1024 DUP (?)
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
	rowShowing       	  DB 32 DUP (?)
	;;����� ��� ��������� �����
	equationResultat      DQ 128 DUP (?)
	;;���� ��� ������� ������ � ������
	dict DD ?
	cityFunction DD ?


;������ ��� ��������� ������ �����
getTheRow macro place, index
	;;�������� ����������� � ������
	lea  edx, coeffsD[index*8]
	push  edx
	lea  edx, coeffsC[index*8]
	push  edx
	lea  edx, coeffsB[index*8]
	push  edx
	lea  edx, coeffsA[index*8]
	push  edx
	lea edx, bufferForResult
	push edx
	;;��������� �� ��������� �����������
	;;���������� �� ��������� ������� � ������
	;;������ ������ ���������� ������ calculateTheRow ��� ���������
	call [cityFunction]
	;;����� �����������
	invoke FloatToStr2, coeffsA[index*8], addr aElement
	invoke FloatToStr2, coeffsB[index*8], addr bElement
	invoke FloatToStr2, coeffsC[index*8], addr cElement
	invoke FloatToStr2, coeffsD[index*8], addr dElement
	;;����� ������ �����
    invoke wsprintf, place, addr textOfRow, addr aElement, addr bElement, addr cElement, addr dElement, addr bufferForResult
endm

.code
	;;������� ������ code
    start:
		;;���������� ������
        mov stepWith, offset firstRow
		;;�����������
		mov EDI, NULL
		;���� ��� �'��� �����
		invoke LoadLibrary, addr module
		mov dict, eax
		invoke GetProcAddress, dict, addr method
		mov cityFunction, eax
        calculationLoop:
        getTheRow stepWith, EDI
        add stepWith, 128
		;;ϳ�������� �������
        add EDI, 1
		;��������� �� ����� ��������
        CMP EDI, rows
        JNE calculationLoop
		invoke FreeLibrary, dict
		;����� ��� �����
		invoke wsprintf, addr equationResultat, addr equationText
        invoke wsprintf, addr endShowing, addr allResultsInOnePlace, addr equationResultat, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow
        invoke MessageBox, NULL, offset endShowing, offset textOfWindow, MB_OK
		
		;;��������� ��������
        invoke ExitProcess, NULL
    end start