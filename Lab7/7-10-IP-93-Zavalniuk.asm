.386
;������� ��������
.model flat, stdcall
option CaseMap:None

;ϳ�'������� ��������� ��������
include /masm32/include/masm32rt.inc

.data
	;���������� �����
	;;���������
	calculation            DQ 0
	;;�� ������ ����
	coeffsA 			   DQ 0, 39.5, 6.35, 13.9, 27.5
	coeffsB			       DQ 0, -1.41, -9.74, 28.4, -2.66
	coeffsC				   DQ 24.3, 6.44, -16.25, 22.45, 5.53
	coeffsD				   DQ 35.9, 18.6, 32.4, 10.18, 19.18
	num2         		   DQ 2.0
	nulevinValue           DQ 1.0
	nulevinValue1          DQ -1.0
	nulevinValue2          DQ 0.0
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
    textOfWindow       	   DB "����������� ����������", 0
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
	dElement 			  DB 32 DUP(?)
	;;��������� �� ������� �����
	bufferForResult 	  DQ 128 DUP(?)
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
	
	res1 dq ?
	res2 dq ?


;������ ��� ��������� �����
calculateTheRow macro elementA, elementB, elementC, elementD, firstCoef, secondCoef
	
	;;���������� ������ �������������
	invoke FloatToStr2, elementA, addr aElement
	invoke FloatToStr2, elementB, addr bElement
	invoke FloatToStr2, elementC, addr cElement
	invoke FloatToStr2, elementD, addr dElement
	
	;"(4*c + d - 1) / (b - tg(a / 2))"
	
	lea ecx, coeffsC[8*edi]
	lea eax, firstCoef
	call RegisterProcedureMain
	
	lea edx, elementD
	lea eax, res1
	push edx
	push eax
	call StackProcedureMain
	
	call ExternPublicProcedureMain@0 ; ��������� ����� ���������

	finit
	fld res1
	fld res2
	
	;;�������� �� ���� � ����������
	fcom    nulevinValue2 
    fstsw   ax
    SAHF
    JE      foundedNulevin
	
	fdiv
	fstp calculation ; result = stack[0]
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

	
	
	stukovGates:
	
endm

;������ ��� ��������� ������ �����
getTheRow macro place, index
	;;����� �����������
	;;��������� �� ��������� �����������
    calculateTheRow coeffsA[index*8], coeffsB[index*8], coeffsC[index*8], coeffsD[index*8], numberFourValue, num2
	;;����� ������ �����
    invoke wsprintf, place, addr textOfRow, addr aElement, addr bElement, addr cElement, addr dElement, addr bufferForResult
endm

public coeffsA, coeffsB, num2, res2
extern ExternPublicProcedureMain@0:near
.code
RegisterProcedureMain proc
	finit
	;;������� ������� �����
	fld qword ptr [ecx]
	fld qword ptr [eax]
	;;����� �������� � ����������
	fmul
	;;������� �������
	fld1
	;;³�������� ������� �� ������������ ���������
	fsub
	mov eax, offset res1
	fstp qword ptr [eax]
	ret
RegisterProcedureMain endp 

StackProcedureMain proc
	finit
	push ebp
	mov ebp, esp
	mov eax, [ebp + 8]
	mov ebx, [ebp + 12]
	fld qword ptr [edx]
	fld qword ptr [eax]
	fadd
	fstp qword ptr [eax]
	pop ebp
	ret 8
	
StackProcedureMain endp

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
	