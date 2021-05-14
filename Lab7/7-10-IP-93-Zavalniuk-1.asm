.386
.model flat, stdcall
option casemap :none 

.code
;;Третя процедура
extern coeffsA: qword, coeffsB: qword, numberTwoValue: qword, ViverraResultat: qword
public Viverra
Viverra proc
	finit
	;;Вставка третього числа
	fld coeffsB[8*edi]
	;;Вставка четвертого числа та підготовка його для тангенса
	fld coeffsA[8*edi]
	fld numberTwoValue
	;;Ділення аргумента для тангенса
	fdiv
	;;Оскільки у тангенса в знаменнику косинус, а косинус може мати значення - нуль, то тут помилка
	;;По суті, ми робимо перевірку чи синус дорівнює 1 або -1
	fsin
	fld coeffsA[8*edi]
	fld numberTwoValue
	;;Ділення аргумента для тангенса
	fdiv
	fcos
	;;Виконання тангенса
	fdiv
	;;Віднімання у знаменнику	
	fsub
	fstp ViverraResultat
	ret
Viverra endp
end
