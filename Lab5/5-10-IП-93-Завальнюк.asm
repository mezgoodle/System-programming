.386
; Початок програми
.model flat, stdcall
option CaseMap:None

Під'єднання необхідних бібліотек
include /masm32/include/windows.inc
includelib /masm32/lib/kernel32.lib
include /masm32/include/user32.inc
includelib /masm32/lib/user32.lib
include /masm32/include/kernel32.inc

.data
	Оголошення даних
	Результат
	calculation            DB 0
	Коефіцієнти а
    coeffsA                DB -3, -3, -2, -1, 3
	Коефіцієнти б
    coeffsB                DB 2, 2, -2, -1, 2
	Коефіцієнти с
    coeffsC                DB 4, 2, 2, 3, 4
	Кількість рядків
	rows				   DD 5
	Кроковий буфер
	stepWithBuffer         DD 0
	Шаблон негативного числа
	textOfNegativeNumber   DB "-%i", 0
	Шаблон позитивного числа
    textOfPossitiveNumber  DB "%i", 0
	Текст користувацького вікна зверху
    textOfWindow       	   DB "Математичні розрахунки", 0
	Шаблон усіх результатів
    allResultsInOnePlace   DB "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
	Шаблон рядка-результату
    textOfRow              DB "a = %s, b = %s, c = %s, результат = %s", 0
    
	
.data?
	Оголошення даних
	Елемент з масиву а
    aElement              DB 16 DUP (?)
	Елемент з масиву б
    bElement              DB 16 DUP (?)
	Елемент з масиву с
    cElement              DB 16 DUP (?)
	Закінчення показу
	endShowing             DB 1024 DUP (?)
	Перший результат
    firstRow              DB 128 DUP (?)
	Другий результат
    secondRow             DB 128 DUP (?)
	Третій результат
    thirdRow              DB 128 DUP (?)
	Четвертий результат
    fourthRow             DB 128 DUP (?)
	П'ятий показ
    fifthRow              DB 128 DUP (?)
	Показ рядку
	rowShowing       	   DB 32 DUP (?)

Макрос для обрахунку рядка
calculateTheRow macro A, B, C_
	Призначення
    mov AL, 1
	add AL, 1
	Множення
    imul A
    imul C_
	add AL, -1
    mov calculation, AL
    mov AL, 1
    imul C_
	Ділення
    idiv B
	add AL, A
    add AL, -24
	Конвертація у word
	cbw
    idiv calculation
endm

Макрос для показу кінцевого результату
invokeFixedNumber macro place, number
	Оголошення областей
    local quit
	local notEven
	Призначення
    mov AL, number
	Здвиг у право
    sar AL, 1
    jb notEven
	Парне число
	Показ числа
    invoke wsprintf, addr place, 
					 addr textOfPossitiveNumber, AL
    jmp quit
	Непарне число
    notEven:
    mov BL, 5
    mov AL, number
    imul BL
	Показ числа
    invoke wsprintf, addr place, 
					 addr textOfPossitiveNumber, AL
    Вихід з макросу
    quit:
endm

Макрос для показу коефіцієнта
invokeSingleNumber macro place, number
	Оголошення областей
    local quit
	local plusNumber
	Призначення
	mov CL, -1
    mov     AL, number
    test    AL, AL
    jns     plusNumber
	cbw
	Множення
    imul CL
	Від'ємне число
	Показ числа
    invoke wsprintf, addr place, 
					 addr textOfNegativeNumber, AL
    jmp quit
	Додатнє числа
    plusNumber:
	Показ числа
    invoke wsprintf, addr place, 
					 addr textOfPossitiveNumber, AL
	Вихід з макросу
    quit:
endm

getTheRow macro place, index
    invokeSingleNumber aElement, coeffsA[index]
    invokeSingleNumber bElement, coeffsB[index]
    invokeSingleNumber cElement, coeffsC[index]
    calculateTheRow coeffsA[index], coeffsB[index], coeffsC[index]
    mov calculation, AL
    invokeFixedNumber rowShowing, calculation
    invoke wsprintf, place, addr textOfRow, addr aElement, addr bElement, addr cElement, addr rowShowing
endm

.code
    start:
        mov stepWithBuffer, offset firstRow
		mov EDI, 0
        calculationLoop:
        getTheRow stepWithBuffer, EDI
        add stepWithBuffer, 128
        add EDI, 1
        CMP EDI, rows
        JNE calculationLoop
        invoke wsprintf, addr endShowing, addr allResultsInOnePlace, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow
        invoke MessageBox, 0, addr endShowing, addr textOfWindow, MB_OK
        invoke ExitProcess, 0
    end start