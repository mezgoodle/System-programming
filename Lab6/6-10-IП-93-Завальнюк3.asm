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
	a_arr 				   DQ 0.3, 15.7, -3.6, 5.3, 11.2
	b_arr			       DQ 1.98, -6.1, 5.7, 8.1, 18.3
	c_arr				   DQ 3.9, -20.4, 17.5, -36.6, 21.1
	d_arr				   DQ -1.0, -41.4, 3.1, -8.9, -8.4
	numberFourValue        DQ 4.0
	numberTwoValue         DQ 2.0
	;;Кількість рядків
	rows				   DD 5
	;;Кроковий буфер
	stepWith         	   DD 0
	equationText           DB "(4*c + d - 1) / (b - tg(a / 2))", 0
	errorNulevinText       DB "Помилка, ділення на нуль", 0
	errorNulevinTangensText DB "Помилка, косинус дорівнює нулеві", 0
	;;Текст користувацького вікна зверху
    textOfWindow       	   DB "Математичні розрахунки", 0
	;;Шаблон усіх результатів
    allResultsInOnePlace   DB "Головне рiвняння -  %s", 10, "1) %s", 10, "2) %s", 10, "3) %s", 10, "4) %s", 10, "5) %s", 0
	;;Шаблон рядка-результату
    textOfRow              DB "a = %s, b = %s, c = %s, d = %s, результат = %s", 0
	nulevinNumber          DQ 0.0
    
	
.data?
	;Оголошення даних
	;;Елемент з масиву а
    aElement              DB 16 DUP (?)
	;;Елемент з масиву б
    bElement              DB 16 DUP (?)
	;;Елемент з масиву с
    cElement              DB 16 DUP (?)
	;;Закінчення показу
	endShowing             DB 1024 DUP (?)
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
	rowShowing       	   DB 32 DUP (?)
	maininfo              DB 128 DUP (?)
	
.data?
	
	buff_res db 128 dup(?)
	buff_a db 32 dup(?)
	buff_b db 32 dup(?)
	buff_c db 32 dup(?)
	buff_d db 32 dup(?)
	

;Макрос для обрахунку рядка
calculateTheRow macro a_num, b_num, c_num, d_num, firstCoef, secondCoef
	invoke FloatToStr2, a_num, addr buff_a
	invoke FloatToStr2, b_num, addr buff_b
	invoke FloatToStr2, c_num, addr buff_c
	invoke FloatToStr2, d_num, addr buff_d

	finit
		
	fld firstCoef ; st(0) = 4
	fld c_num		 ; st(0) = c, st(1) = 4
	fmul 			 ; st(0) = st(1) * st(0)
	
	

	; 4*c = 15,6
	; ^ works

	fld d_num ; st(0) = d, st(1) = 4*c
	
	
	fadd ; st(0) = st(1) + st(0) = 4*c+d
	
	
	; 4*c+d = 11,5
	; ^ works

	fld1 ; st(0) = 1, st(1) = 4*c+d
	fsub ; st(0) = st(1) - st(0) = 4*c+d-1

	; 4*c+d-1 = 10,5
	; ^ works
	
	fld b_num ; st(0) = b, st(1) = 4*c+d-1
	
	fld a_num ; st(0) = a, st(1) = b, st(2) = 4*c+d-1
	fld secondCoef ; st(0) = 2, st(1) = a, st(2) = b, st(3) = 4*c+d-1
	
	fdiv ; st(0) = st(1)/st(0) = a/2, st(1) = b, st(2) = 4*c+d-1
	
	fcom    nulevinNumber 
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
	
	fcom    nulevinNumber 
    fstsw   AX
    SAHF
    JE      foundedNulevin
	
	; b-tg(a/2) = 1,82886
	; ^ works
	
	fdiv ; st(0) = st(1)/st(0) = (4*c+d-1)/(b-tg(a/2))
	
	; (4*c+d-1)/(b-tg(a/2)) = 5,74128

	fstp calculation
	

	invoke FloatToStr2, calculation, addr buff_res
	
	JMP quit
	
	; (-2*c - sin(a/d) + 53)/(a/4 - b)
	foundedNulevin:
	invoke wsprintf, addr buff_res, addr errorNulevinText
	JMP quit
	foundedTangensNulevin:
	invoke wsprintf, addr buff_res, addr errorNulevinTangensText
	JMP quit
	quit:
endm

;Макрос для отримання усього рядка
getTheRow macro place, index
	;;Показ коефіцієнтів
	;;Обрахунок за допомогою коефіцієнтів
    calculateTheRow a_arr[index*8], b_arr[index*8], c_arr[index*8], d_arr[index*8], numberFourValue, numberTwoValue
	;;Показ попереднього обрахунку
	;;Показ усього рядка
    invoke wsprintf, place, addr textOfRow, addr buff_a, addr buff_b, addr buff_c, addr buff_d, addr buff_res
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
		invoke wsprintf, addr maininfo, addr equationText
        invoke wsprintf, addr endShowing, addr allResultsInOnePlace, addr maininfo, addr firstRow, addr secondRow, addr thirdRow, addr fourthRow, addr fifthRow
        invoke MessageBox, NULL, offset endShowing, offset textOfWindow, MB_OK
		;;Закінчення програми
        invoke ExitProcess, NULL
    end start