.386
;Початок програми
.model flat, stdcall
option CaseMap:None

;Під'єднання необхідних бібліотек
include /masm32/include/masm32rt.inc

.data
	;Оголошення даних
	;;Результат
	calculation            DQ 0
	;;Усі вхідні дані
	coeffsA 			   DQ 0.3, 15.7, -3.6, 5.3, 11.2
	coeffsB			       DQ 1.98, -6.1, 5.7, 8.1, 18.3
	coeffsC				   DQ 3.9, -20.4, 17.5, -36.6, 21.1
	coeffsD				   DQ -1.0, -41.4, 3.1, -8.9, -8.4
	numberTwoValue         DQ 2.0
	nulevinValue           DQ 0.0
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
	dElement 			  DB 32 dup(?)
	;;Результат на кожному рядку
	bufferForResult db 128 dup(?)
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
	equationResultat      DB 128 DUP (?)


;Макрос для обрахунку рядка
calculateTheRow macro elementA, elementB, elementC, elementD, firstCoef, secondCoef
	;;Заповнення буферів коефіцієнтами
	invoke FloatToStr2, elementA, addr aElement
	invoke FloatToStr2, elementB, addr bElement
	invoke FloatToStr2, elementC, addr cElement
	invoke FloatToStr2, elementD, addr dElement

	finit
	;;Вставка першого числа
	fld elementC
	fld firstCoef
	;;Перше множення в чисельнику
	fmul
	;;Вставка другого числа
	fld elementD ; st(0) = d, st(1) = 4*c
	
	
	fadd ; st(0) = st(1) + st(0) = 4*c+d
	
	
	; 4*c+d = 11,5
	; ^ works

	fld1 ; st(0) = 1, st(1) = 4*c+d
	fsub ; st(0) = st(1) - st(0) = 4*c+d-1

	; 4*c+d-1 = 10,5
	; ^ works
	
	fld elementB ; st(0) = b, st(1) = 4*c+d-1
	
	fld elementA ; st(0) = a, st(1) = b, st(2) = 4*c+d-1
	fld secondCoef ; st(0) = 2, st(1) = a, st(2) = b, st(3) = 4*c+d-1
	
	fdiv ; st(0) = st(1)/st(0) = a/2, st(1) = b, st(2) = 4*c+d-1
	
	fcom    nulevinValue 
    fstsw   AX
    SAHF
    JE      foundedTangensNulevin
	
	; a/2 = 0,15
	; ^ works
	
	fptan ; st(0) = 1, st(1) = tg(st(0)) st(2) = b, st(3) = 4*c+d-1
	
	;; HERE CHECK

	fdiv ; st(0) = st(1)/st(0) = tg(a/2), st(1) = b, st(2) = 4*c+d-1
	
	; tg(a/2) = 0,151135
	; ^ works
	
	fsub ; st(0) = st(1)-st(0) = b-tg(a/2), st(1) = 4*c+d-1
	
	fcom    nulevinValue 
    fstsw   AX
    SAHF
    JE      foundedNulevin
	
	; b-tg(a/2) = 1,82886
	; ^ works
	
	fdiv ; st(0) = st(1)/st(0) = (4*c+d-1)/(b-tg(a/2))
	
	; (4*c+d-1)/(b-tg(a/2)) = 5,74128

	fstp calculation
	

	invoke FloatToStr2, calculation, addr bufferForResult
	
	JMP quit
	
	; (-2*c - sin(a/d) + 53)/(a/4 - b)
	foundedNulevin:
	invoke wsprintf, addr bufferForResult, addr errorNulevinText
	JMP quit
	foundedTangensNulevin:
	invoke wsprintf, addr bufferForResult, addr errorNulevinTangensText
	JMP quit
	quit:
endm

;Макрос для отримання усього рядка
getTheRow macro place, index
	;;Показ коефіцієнтів
	;;Обрахунок за допомогою коефіцієнтів
    calculateTheRow coeffsA[index*8], coeffsB[index*8], coeffsC[index*8], coeffsD[index*8], numberFourValue, numberTwoValue
	;;Показ попереднього обрахунку
	;;Показ усього рядка
    invoke wsprintf, place, addr textOfRow, addr aElement, addr bElement, addr cElement, addr dElement, addr bufferForResult
endm

.code
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