.386
.model flat, stdcall
option casemap: none
 
include /masm32/include/windows.inc
include /masm32/include/user32.inc
include /masm32/include/kernel32.inc
includelib /masm32/lib/user32.lib
includelib /masm32/lib/kernel32.lib

.data
    dlg_header DB "Lab 1", 0
	
	; Whole number:
    symbol_str DB "%s (Symbol)", 0
    symbol_buf DB 128 DUP (?)
    symbol DB "0911200", 0
	
	;A:
    a_byte_string DB "A = 09 = %x (Byte)", 0
    a_byte_buffer DB 32 DUP (?)
    a_byte DB +09
	
    a_negative_byte_string DB "-A = -09 = %x (Byte)", 0
    a_negative_byte_buffer DB 32 DUP (?)
    a_negative_byte DB -09
	
	;B:
    b_word_string DB "B = 0911 = %x (Byte)", 0
    b_word_buffer DB 32 DUP (?)
    b_word DW +0911
	
	b_negative_word_string DB "-B = -0911 = %x (Byte)", 0
    b_negative_word_buffer DB 32 DUP (?)
    b_negative_word DW -0911
	
	;C:
	c_shortint_string DB "C = 09112001 = %x (Shortint)", 0
    c_shortint_buffer DB 64 DUP (?)
    c_shortint DD +09112001
	
    c_negative_shortint_string DB "-C = -09112001 = %x (Shortint)", 0
    c_negative_shortint_buffer DB 64 DUP (?)
    c_negative_shortint DD -09112001
	
	c_longint_string DB "C = 09112001 = %x (Longint)", 0
    c_longint_buffer DB 64 DUP (?)
    c_longint DQ +09112001
	
    c_negative_longint_string DB "-C = -09112001 = %x (Longint)", 0
    c_negative_longint_buffer DB 64 DUP (?)
	c_negative_longint DQ -09112001
	
	;D:
	d_single_string DB "D = 0,001 = %x (Single)", 0
    d_single_buffer DB 64 DUP (?)
    d_single DD +0.001
	
    d_negative_single_string DB "-D = -0,001 = %x (Single)", 0
    d_negative_single_buffer DB 64 DUP (?)
    d_negative_single DD -0.001
	
	;E:
	e_double_string DB "E = 0,098 = %x%x (Double)", 0
    e_double_buffer DB 32 DUP (?)
    e_double DQ +0,098
	
    e_negative_double_string DB "-E = -0,098 = %x%x (Double)", 0
    e_negative_double_buffer DB 32 DUP (?)
    e_negative_double DQ -0,098
	
	;F:
	f_long_double_string DB "F = 978.522 = %x%x (Long Double)", 0
    f_long_double_buffer DB 64 DUP (?)
    f_long_double DT +978.522
	
    f_negative_long_double_string DB "-F = -978.522 = %x%x (Long Double)", 0
    f_negative_long_double_buffer DB 64 DUP (?)
    f_negative_long_double DT -978.522
	

    msg_str DB "%s", 13,
        "%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
		"%s", 13,
        0

    msg_buf DB 128 DUP (?)
	
.code
    start:
	invoke wsprintf, addr symbol_buf, addr symbol_str, addr symbol
	
	invoke wsprintf, addr a_byte_buffer, addr a_byte_string, a_byte
	invoke wsprintf, addr a_negative_byte_buffer, addr a_negative_byte_string, a_negative_byte
	invoke wsprintf, addr b_word_buffer, addr b_word_string, b_word
	invoke wsprintf, addr b_negative_word_buffer, addr b_negative_word_string, b_negative_word
	invoke wsprintf, addr c_shortint_buffer, addr c_shortint_string, c_shortint
	invoke wsprintf, addr c_negative_shortint_buffer, addr c_negative_shortint_string, c_negative_shortint
	invoke wsprintf, addr c_longint_buffer, addr c_longint_string, c_longint
	invoke wsprintf, addr c_negative_longint_buffer, addr c_negative_longint_string, c_negative_longint
	invoke wsprintf, addr d_single_buffer, addr d_single_string, d_single
	invoke wsprintf, addr d_negative_single_buffer, addr d_negative_single_string, d_negative_single
	invoke wsprintf, addr e_double_buffer, addr e_double_string, e_double
	invoke wsprintf, addr e_negative_double_buffer, addr e_negative_double_string, e_negative_double
	invoke wsprintf, addr f_long_double_buffer, addr f_long_double_string, f_long_double
	invoke wsprintf, addr f_negative_long_double_buffer, addr f_negative_long_double_string, f_negative_long_double

	invoke wsprintf, addr msg_buf, addr msg_str,
        addr symbol_buf,
        addr a_byte_buffer,
	    addr a_negative_byte_buffer,
		addr b_word_buffer,
		addr b_negative_word_buffer,
		addr c_shortint_buffer,
		addr c_negative_shortint_buffer,
		addr c_longint_buffer,
		addr c_negative_longint_buffer,
		addr d_single_buffer,
		addr d_negative_single_buffer,
		addr e_double_buffer,
		addr e_negative_double_buffer,
		addr f_long_double_buffer,
		addr f_negative_long_double_buffer
		
	invoke MessageBox, 0, addr msg_buf, addr dlg_header, MB_OK
    invoke ExitProcess, 0
    end start