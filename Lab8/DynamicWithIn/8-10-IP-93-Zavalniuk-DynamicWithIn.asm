.386
;Початок програми
.model flat, stdcall
option CaseMap:None

;Під'єднання необхідних бібліотек
include /masm32/include/masm32rt.inc

.data
	;Оголошення даних
	;;Усі вхідні дані
	coeffsA 			   DQ 7.36, 39.5, 6.35, 13.9, 27.5
	coeffsB			       DQ -2.25, -1.41, -9.74, 28.4, -2.66
	coeffsC				   DQ 24.3, 6.44, -16.25, 22.45, 5.53
	coeffsD				   DQ 35.9, 18.6, 32.4, 10.18, 19.18
	;;Кількість рядків 
	rows				   DD 5
	;;Кроковий буфер
	stepWith         	   DD 0
	;;Текст рівняння
	equationText           DB "(4*c + d - 1) / (b - tg(a / 2))", 0
	;;Текст користувацького вікна зверху
    textOfWindow       	   DB "Математичні розрахунки", 0
	;;Шаблон усіх результатів
    allResultsInOnePlace   DB "Головне рiвняння -  %s", 10, "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
	;;Шаблон рядка-результату
    textOfRow              DB "a = %s, b = %s, c = %s, d = %s, результат = %s", 0
	;;Результат на кожному рядку
	bufferForResult 	   DB 2048 DUP(0)
	;;Дані для модуля
	module 			       DB "8-10-IP-93-Zavalniuk-DynamicWithIn-module", 0
	method                 DB "calculateTheRow", 0
	
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
	;;Змінні для виклику методу з модуля
	dict DD ?
	cityFunction DD ?


;Макрос для отримання усього рядка
getTheRow macro place, index
	;;Передача коефіцієнтів у модуль
	lea  edx, coeffsD[index*8]
	push  edx
	lea  edx, coeffsC[index*8]
	push  edx
	lea  edx, coeffsB[index*8]
	push  edx
	lea  edx, coeffsA[index*8]
	push  edx
	lea edx, bufferForResult
	push edx
	;;Обрахунок за допомогою коефіцієнтів
	;;Обраховуємо за допомогою макросу з модуля
	;;Виклик нашого динамічного модуля calculateTheRow для обрахунку
	call [cityFunction]
	;;Показ коефіцієнтів
	invoke FloatToStr2, coeffsA[index*8], addr aElement
	invoke FloatToStr2, coeffsB[index*8], addr bElement
	invoke FloatToStr2, coeffsC[index*8], addr cElement
	invoke FloatToStr2, coeffsD[index*8], addr dElement
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
		invoke LoadLibrary, addr module
		mov dict, eax
		invoke GetProcAddress, dict, addr method
		mov cityFunction, eax
        calculationLoop:
        getTheRow stepWith, EDI
        add stepWith, 128
		;;Підвищення індекса
        add EDI, 1
		;Порівняння на кінець програми
        CMP EDI, rows
        JNE calculationLoop
		invoke FreeLibrary, dict
		;Показ усіх рядків
		invoke wsprintf, addr equationResultat, addr equationText
        invoke wsprintf, addr endShowing, addr allResultsInOnePlace, addr equationResultat, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow
        invoke MessageBox, NULL, offset endShowing, offset textOfWindow, MB_OK
		
		;;Закінчення програми
        invoke ExitProcess, NULL
    end start