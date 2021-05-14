.486
.model flat, stdcall
option casemap :none 

.data

.code
extern coeffsA: qword, coeffsB: qword, num2: qword, res2: qword, nulevinValue2:qword, tempValue:qword
public KTZProc
KTZProc proc
	
	finit
	;;Вставка третього числа
	fld coeffsB[8*edi]
	;;Вставка четвертого числа та підготовка його для тангенса
	fld coeffsA[8*edi]
	fld num2
	;;Ділення аргумента для тангенса
	fdiv
	;;Оскільки у тангенса в знаменнику косинус, а косинус може мати значення - нуль, то тут помилка
	;;По суті, ми робимо перевірку чи синус дорівнює 1 або -1
	fsin
	fld coeffsA[8*edi]
	fld num2
	;;Ділення аргумента для тангенса
	fdiv
	fcos
	;;Виконання тангенса
	fdiv
	
	;;Перевірка на нуль у тангенсі
	fcom    nulevinValue2 
    fstsw   ax
    SAHF
    JE      foundedNulevinTan
	
	foundedNulevinTan:
	
	mov ebx, tempValue
	mov
	jmp stukovGates
	
	;;Віднімання у знаменнику
	fsub
	fstp res2
	
	stukovGates:
	
	ret
	
KTZProc endp

end
