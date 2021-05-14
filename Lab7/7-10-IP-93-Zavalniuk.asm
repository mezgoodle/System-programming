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
	coeffsA 			   DQ 0, 39.5, 6.35, 13.9, 27.5
	coeffsB			       DQ 0, -1.41, -9.74, 28.4, -2.66
	coeffsC				   DQ 24.3, 6.44, -16.25, 22.45, 5.53
	coeffsD				   DQ 35.9, 18.6, 32.4, 10.18, 19.18
	numberTwoValue         		   DQ 2.0
	nulevinValue           DQ 1.0
	nulevinValue1          DQ -1.0
	nulevinValue2          DQ 0.0
	numberFourValue        DQ 4.0
	;;Кількість рядків 
	rows				   DD 5
	;;Кроковий буфер
	stepWith         	   DD 0
	;;Текст рівняння
	equationText           DB "(4*c + d - 1) / (b - tg(a / 2))", 0
	;;Тексти помилок
	errorNulevinText       DB "Помилка, ділення на нуль", 0
	errorNulevinTangensText DB "Помилка, косинус дорівнює нулеві", 0
	;;Текст користувацького вікна зверху
    textOfWindow       	   DB "Математичні розрахунки", 0
	;;Шаблон усіх результатів
    allResultsInOnePlace   DB "Головне рiвняння -  %s", 10, "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
	;;Шаблон рядка-результату
    textOfRow              DB "a = %s, b = %s, c = %s, d = %s, результат = %s", 0
	
.data?
	;Оголошення даних
	;;Елемент з масиву а
    aElement              DB 32 DUP (?)
	;;Елемент з масиву б
    bElement              DB 32 DUP (?)
	;;Елемент з масиву с
    cElement              DB 32 DUP (?)
	;;Елемент з масиву д
	dElement 			  DB 32 DUP(?)
	;;Результат на кожному рядку
	bufferForResult 	  DQ 128 DUP(?)
	;;Закінчення показу
	endShowing            DB 1024 DUP (?)
	;;Перший результат
    firstRow              DB 128 DUP (?)
	;;Другий результат
    secondRow             DB 128 DUP (?)
	;;Третій результат
    thirdRow              DB 128 DUP (?)
	;;Четвертий результат
    fourthRow             DB 128 DUP (?)
	;;П'ятий показ
    fifthRow              DB 128 DUP (?)
	;;Показ рядку
	rowShowing       	  DB 32 DUP (?)
	;;Буфер для обрахунків рядка
	equationResultat      DQ 128 DUP (?)
	
	res1 dq ?
	res2 dq ?


;Макрос для обрахунку рядка
calculateTheRow macro elementA, elementB, elementC, elementD, firstCoef, secondCoef
	
	;;Заповнення буферів коефіцієнтами
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
	
	call ExternPublicProcedureMain@0 ; викликаємо третю процедуру

	finit
	fld res1
	fld res2
	
	;;Перевірка на нуль у знаменнику
	fcom    nulevinValue2 
    fstsw   ax
    SAHF
    JE      foundedNulevin
	
	fdiv
	fstp calculation ; result = stack[0]
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

	
	
	stukovGates:
	
endm

;Макрос для отримання усього рядка
getTheRow macro place, index
	;;Показ коефіцієнтів
	;;Обрахунок за допомогою коефіцієнтів
    calculateTheRow coeffsA[index*8], coeffsB[index*8], coeffsC[index*8], coeffsD[index*8], numberFourValue, numberTwoValue
	;;Показ усього рядка
    invoke wsprintf, place, addr textOfRow, addr aElement, addr bElement, addr cElement, addr dElement, addr bufferForResult
endm

public coeffsA, coeffsB, numberTwoValue, res2
extern ExternPublicProcedureMain@0:near
.code
RegisterProcedureMain proc
	finit
	;;Вставка першого числа
	fld qword ptr [ecx]
	fld qword ptr [eax]
	;;Перше множення в чисельнику
	fmul
	;;Вставка одиниці
	fld1
	;;Віднімання одиниці від попереднього обрахунку
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

;;Початок області code
start:
	;;Заповнення буферу
	mov stepWith, offset firstRow
	;;Призначення
	mov EDI, NULL
	;Цикл для п'яти рядків
	calculationLoop:
	getTheRow stepWith, EDI
	add stepWith, 128
	;;Підвищення індекса
	add EDI, 1
	;Порівняння на кінець програми
	CMP EDI, rows
	JNE calculationLoop
	;Показ усіх рядків
	invoke wsprintf, addr equationResultat, addr equationText
	invoke wsprintf, addr endShowing, addr allResultsInOnePlace, addr equationResultat, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow
	invoke MessageBox, NULL, offset endShowing, offset textOfWindow, MB_OK
	;;Закінчення програми
	invoke ExitProcess, NULL
end start
	