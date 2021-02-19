.386
.model flat, stdcall
option casemap: none
 
include /masm32/include/masm32rt.inc

.data?
	
	buff db 128 dup(?)
	buff_d db 32 dup(?)
	buff_d_n db 32 dup(?)
	buff_e db 32 dup(?)
	buff_e_n db 32 dup(?)
	buff_f db 32 dup(?)
	buff_f_n db 32 dup(?)


.data
    dlg_header DB "Lab 1", 0
	
	form db "Symbol = %d" ,10, 
		"A = %d", 10, "-A = %d", 10, 
		"B = %d", 10, "-B = %d", 10, 
		"C = %d", 10, "-C = %d", 10, 
		"D = %s", 10, "-D = %s", 10,
		"E = %s", 10, "-E = %s", 10, 
		"F = %s", 10, "-F = %s", 0 
	
	; Whole number:
    symbol DD 0911200
	
	;A:
    a DD +09
    a_negative DD -09
	
	;B:
    b DD +0911
    b_negative DD -0911
	
	;C:
    c_ DD +09112001
    c_negative DD -09112001
	
	;D:
    d DQ +0.001
    d_negative DQ -0.001
	
	;E:
    e DQ +0.098
    e_negative DQ -0.098
	
	;F:
    f DQ +978.522
    f_negative DQ -978.522
	
	
.code
    start:
	invoke FloatToStr2, d, addr buff_d
	invoke FloatToStr2, d_negative, addr buff_d_n
	invoke FloatToStr2, e, addr buff_e
	invoke FloatToStr2, e_negative, addr buff_e_n
	invoke FloatToStr2, f, addr buff_f
	invoke FloatToStr2, f_negative, addr buff_f_n

	invoke wsprintf, addr buff, addr form, symbol, a, a_negative, b, b_negative, c_, c_negative, 
		addr buff_d,
		addr buff_d_n,
		addr buff_e,
		addr buff_e_n,
		addr buff_f,
		addr buff_f_n
	invoke MessageBox, 0, addr buff, addr dlg_header, MB_OK
    invoke ExitProcess, 0
    end start