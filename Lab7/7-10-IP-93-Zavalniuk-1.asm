.486
.model flat, stdcall
option casemap :none 

.data

.code
extern coeffsA: qword, coeffsB: qword, num2: qword, res2: qword, nulevinValue2:qword, tempValue:qword
public KTZProc
KTZProc proc
	
	finit
	;;������� �������� �����
	fld coeffsB[8*edi]
	;;������� ���������� ����� �� ��������� ���� ��� ��������
	fld coeffsA[8*edi]
	fld num2
	;;ĳ����� ��������� ��� ��������
	fdiv
	;;������� � �������� � ���������� �������, � ������� ���� ���� �������� - ����, �� ��� �������
	;;�� ���, �� ������ �������� �� ����� ������� 1 ��� -1
	fsin
	fld coeffsA[8*edi]
	fld num2
	;;ĳ����� ��������� ��� ��������
	fdiv
	fcos
	;;��������� ��������
	fdiv
	
	;;�������� �� ���� � �������
	fcom    nulevinValue2 
    fstsw   ax
    SAHF
    JE      foundedNulevinTan
	
	foundedNulevinTan:
	
	mov ebx, tempValue
	mov
	jmp stukovGates
	
	;;³������� � ����������
	fsub
	fstp res2
	
	stukovGates:
	
	ret
	
KTZProc endp

end
