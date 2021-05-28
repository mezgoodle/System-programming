.386
;Початок програми
.model flat, stdcall
option CaseMap:None

;Під'єднання необхідної бібліотеки
include /masm32/include/masm32rt.inc


.data
	;Оголошення даних
	;;Результат
	calculation            DQ 0
	;;Усі вхідні дані
	numberTwoValue         DQ 2.0
	nulevinValue           DQ 1.0
	nulevinValue1          DQ -1.0
	numberFourValue        DQ 4.0
	;;Тексти помилок
	errorNulevinText       DB "Помилка, ділення на нуль", 0
	errorNulevinTangensText DB "Помилка, косинус дорівнює нулеві", 0
	
;Макрос для обрахунку рядка
.code
calculateTheRow proc bufferForResult:ptr dword, elementA:ptr qword, elementB:ptr qword, elementC:ptr qword, elementD:ptr qword
	;;Заповнення буферів коефіцієнтами
	mov ecx, elementA
	mov ebx, elementB
	mov eax, elementC
	mov edx, elementD
	
	finit
	;;Вставка першого числа
	fld qword ptr[eax]
	fld numberFourValue
	;;Перше множення в чисельнику
	fmul
	;;Вставка одиниці
	fld1
	;;Віднімання одиниці від попереднього обрахунку
	fsub
	;;Вставка другого числа
	fld qword ptr[edx]
	;;Сума в чисельнику
	fadd
	;;Вставка третього числа
	fld qword ptr[ebx]
	;;Вставка четвертого числа та підготовка його для тангенса
	fld qword ptr[ecx]
	fld numberTwoValue
	;;Ділення аргумента для тангенса
	fdiv
	;;Оскільки у тангенса в знаменнику косинус, а косинус може мати значення - нуль, то тут помилка
	;;По суті, ми робимо перевірку чи синус дорівнює 1 або -1
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
	;;Ділення аргумента для тангенса
	fdiv
	fcos
	;;Виконання тангенса
	fdiv
	;;Віднімання у знаменнику	
	fsub
	;;Перевірка на нуль у знаменнику
	fcom    nulevinValue 
    fstsw   AX
    SAHF
    JE      foundedNulevin
	;;Останнє ділення
	fdiv
	;;Вставка результату в буфер
	fstp calculation
	invoke FloatToStr2, calculation, addr bufferForResult
	
	JMP stukovGates
	
	foundedNulevin:
	;;Нуль у знаменнику
	invoke wsprintf, addr bufferForResult, addr errorNulevinText
	JMP stukovGates
	foundedTangensNulevin:
	;;Нуль в тангенсі
	invoke wsprintf, addr bufferForResult, addr errorNulevinTangensText
	JMP stukovGates
	;;Вихід з макросу обрахунку
	stukovGates:
	ret
calculateTheRow endp
end
