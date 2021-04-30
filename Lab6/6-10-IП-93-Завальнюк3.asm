.386
;������� ��������
.model flat, stdcall
option CaseMap:None

;ϳ�'������� ���������� �������
include /masm32/include/masm32rt.inc

.data
	;���������� �����
	;;���������
	calculation            DQ 0
	;;�� ����� ���
	coeffsA 			   DQ 0.3, 15.7, -3.6, 5.3, 11.2
	coeffsB			       DQ 1.98, -6.1, 5.7, 8.1, 18.3
	coeffsC				   DQ 3.9, -20.4, 17.5, -36.6, 21.1
	coeffsD				   DQ -1.0, -41.4, 3.1, -8.9, -8.4
	numberTwoValue         DQ 2.0
	nulevinValue           DQ 0.0
	numberFourValue        DQ 4.0
	;;ʳ������ ����� 
	rows				   DD 5
	;;�������� �����
	stepWith         	   DD 0
	;;����� �������
	equationText           DB "(4*c + d - 1) / (b - tg(a / 2))", 0
	;;������ �������
	errorNulevinText       DB "�������, ������ �� ����", 0
	errorNulevinTangensText DB "�������, ������� ������� �����", 0
	;;����� ��������������� ���� ������
    textOfWindow       	   DB "���������� ����������", 0
	;;������ ��� ����������
    allResultsInOnePlace   DB "������� �i������ -  %s", 10, "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
	;;������ �����-����������
    textOfRow              DB "a = %s, b = %s, c = %s, d = %s, ��������� = %s", 0
	
.data?
	;���������� �����
	;;������� � ������ �
    aElement              DB 32 DUP (?)
	;;������� � ������ �
    bElement              DB 32 DUP (?)
	;;������� � ������ �
    cElement              DB 32 DUP (?)
	;;������� � ������ �
	dElement 			  DB 32 dup(?)
	;;��������� �� ������� �����
	bufferForResult db 128 dup(?)
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
	equationResultat      DB 128 DUP (?)


;������ ��� ��������� �����
calculateTheRow macro elementA, elementB, elementC, elementD, firstCoef, secondCoef
	;;���������� ������ �������������
	invoke FloatToStr2, elementA, addr aElement
	invoke FloatToStr2, elementB, addr bElement
	invoke FloatToStr2, elementC, addr cElement
	invoke FloatToStr2, elementD, addr dElement

	finit
	;;������� ������� �����
	fld elementC
	fld firstCoef
	;;����� �������� � ����������
	fmul
	;;������� �������
	fld1
	;;³������� ������� �� ������������ ���������
	fsub
	;;������� ������� �����
	fld elementD
	;;���� � ����������
	fadd
	;;������� �������� �����
	fld elementB
	;;������� ���������� ����� �� ��������� ���� ��� ��������
	fld elementA
	fld secondCoef
	;;ĳ����� ��������� ��� ��������
	fdiv
	;;������� � �������� � ���������� �������, � ������� �� ���� - ����, �� ��� �������
	;;�� ���, ����� ������ ��������� �� ���������� � ����
	fcom    nulevinValue 
    fstsw   AX
    SAHF
    JE      foundedTangensNulevin
	;;��������� ��������
	fptan
	fdiv
	;;³������� � ����������	
	fsub
	;;�������� �� ���� � ����������
	fcom    nulevinValue 
    fstsw   AX
    SAHF
    JE      foundedNulevin
	;;������ ������
	fdiv
	;;������� ���������� � �����
	fstp calculation
	invoke FloatToStr2, calculation, addr bufferForResult
	
	JMP stukovGates
	
	foundedNulevin:
	;;���� � ����������
	invoke wsprintf, addr bufferForResult, addr errorNulevinText
	JMP stukovGates
	foundedTangensNulevin:
	;;���� � �������
	invoke wsprintf, addr bufferForResult, addr errorNulevinTangensText
	JMP stukovGates
	;;����� � ������� ���������
	stukovGates:
endm

;������ ��� ��������� ������ �����
getTheRow macro place, index
	;;����� �����������
	;;��������� �� ��������� �����������
    calculateTheRow coeffsA[index*8], coeffsB[index*8], coeffsC[index*8], coeffsD[index*8], numberFourValue, numberTwoValue
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
        calculationLoop:
        getTheRow stepWith, EDI
        add stepWith, 128
		;;ϳ�������� �������
        add EDI, 1
		;��������� �� ����� ��������
        CMP EDI, rows
        JNE calculationLoop
		;����� ��� �����
		invoke wsprintf, addr equationResultat, addr equationText
        invoke wsprintf, addr endShowing, addr allResultsInOnePlace, addr equationResultat, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow
        invoke MessageBox, NULL, offset endShowing, offset textOfWindow, MB_OK
		;;��������� ��������
        invoke ExitProcess, NULL
    end start