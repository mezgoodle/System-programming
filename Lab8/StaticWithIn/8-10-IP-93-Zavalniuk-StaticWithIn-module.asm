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
	;;�� ����� ���
	numberTwoValue         DQ 2.0
	nulevinValue           DQ 1.0
	nulevinValue1          DQ -1.0
	numberFourValue        DQ 4.0
	;;������ �������
	errorNulevinText       DB "�������, ������ �� ����", 0
	errorNulevinTangensText DB "�������, ������� ������� �����", 0
	
;������ ��� ��������� �����
.code
calculateTheRow proc bufferForResult:ptr dword, elementA:ptr qword, elementB:ptr qword, elementC:ptr qword, elementD:ptr qword
	;;���������� ������ �������������
	mov ecx, elementA
	mov ebx, elementB
	mov eax, elementC
	mov edx, elementD
	
	finit
	;;������� ������� �����
	fld qword ptr[eax]
	fld numberFourValue
	;;����� �������� � ����������
	fmul
	;;������� �������
	fld1
	;;³������� ������� �� ������������ ���������
	fsub
	;;������� ������� �����
	fld qword ptr[edx]
	;;���� � ����������
	fadd
	;;������� �������� �����
	fld qword ptr[ebx]
	;;������� ���������� ����� �� ��������� ���� ��� ��������
	fld qword ptr[ecx]
	fld numberTwoValue
	;;ĳ����� ��������� ��� ��������
	fdiv
	;;������� � �������� � ���������� �������, � ������� ���� ���� �������� - ����, �� ��� �������
	;;�� ���, �� ������ �������� �� ����� ������� 1 ��� -1
	fsin
	fcom    nulevinValue 
    fstsw   AX
    SAHF
    JE      foundedTangensNulevin
	fcom    nulevinValue1 
    fstsw   AX
    SAHF
    JE      foundedTangensNulevin
	fld qword ptr[ecx]
	fld numberTwoValue
	;;ĳ����� ��������� ��� ��������
	fdiv
	fcos
	;;��������� ��������
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
	ret
calculateTheRow endp
end
