.486
.model flat, stdcall
option casemap :none 

.data

.code
extern coeffsA: qword, coeffsB: qword, num2: qword, res2: qword
public ExternPublicProcedureMain
ExternPublicProcedureMain proc
	
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
	;;³�������� � ����������	
	fsub
	fstp res2
	
	ret
	
ExternPublicProcedureMain endp

end
