.386
.model flat, stdcall
option casemap :none 

.code
;;����� ���������
extern coeffsA: qword, coeffsB: qword, numberTwoValue: qword, ViverraResultat: qword
public Viverra
Viverra proc
	finit
	;;������� �������� �����
	fld coeffsB[8*edi]
	;;������� ���������� ����� �� ��������� ���� ��� ��������
	fld coeffsA[8*edi]
	fld numberTwoValue
	;;ĳ����� ��������� ��� ��������
	fdiv
	;;������� � �������� � ���������� �������, � ������� ���� ���� �������� - ����, �� ��� �������
	;;�� ���, �� ������ �������� �� ����� ������� 1 ��� -1
	fsin
	fld coeffsA[8*edi]
	fld numberTwoValue
	;;ĳ����� ��������� ��� ��������
	fdiv
	fcos
	;;��������� ��������
	fdiv
	;;³������� � ����������	
	fsub
	fstp ViverraResultat
	ret
Viverra endp
end
