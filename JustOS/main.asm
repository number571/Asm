format binary
use16
;-----------------------------------------------------
;MBR всегда находится на первом секторе жесткого диска. 
;При загрузке компьютера, BIOS считывает этот сектор 
;с диска в память по адресу 0000:7C00h и передает ему 
;управление.
;-----------------------------------------------------
;Между сектором MBR и началом первого раздела диска
;всегда есть дополнительные неиспользуемые 63 сектора.
;-----------------------------------------------------
org 0x7C00 ; boot address

Goboot:		
;============== BOOT_ADDR  0x7C00  =====================================
	jmp	near BootStart		;Переходим на код загрузчика
;=======================================================================
mLoading	db 'Loading boot sector is OK ...', 10,13,0 
;=======================================================================
PrintSTR:
	cld					;печать строки на экран в позицию курсора
@@:				        ;средствами BIOS
	lodsb				;печать строки из DS:SI в позицию курсора
	cmp	al,0
	je	@F
	mov	ah, 0Eh
	int	10h
	jmp	@B
@@:
    ret
;=======================================================================
BootStart:
    mov	  si, mLoading
    Call  PrintSTR
;***********************************************************************
;-----------------------------------------------------
;Между сектором MBR и началом первого раздела диска
;всегда есть дополнительные неиспользуемые 63 сектора.
;Воспользуемся этим.
;-----------------------------------------------------
;=======================================================================
;=======  Загрузка кода со 2 сектора винча 80h  ========================
;номер диска (0=диск A...; 80h=HDD 0; 81h=HDD 1...)
;    по адресу  0000h:7E00h
;-----------------------------------------------------------------------
; Загружаем 2 сектор HDD0
	mov	ax, 0000h
	mov	es, ax	    ; сегмент буфера
	mov	ah, 02h     ; номер функции (читать с диска)
	mov	al, 4       ; число секторов для чтения.
	mov	bx, 0x7E00  ; начало буффера для данных, загружаемых с винча
	mov	ch, 0	    ; дорожка (всего 80 дорожек)
	mov	cl, 2	    ; сектор (1-63) (всего 63 секторов)
	mov	dh, 0	    ; головка
	mov	dl, 80h	    ; накопитель
	int 13h
;=======================================================================
; Передадим управление на загруженный код
; по адресу  0000h:7E00h

     jmp near Boot2
;=======================================================================
;--------------------------------------------------------------
db "End code bootloader!" ; Иногда полезно знать где конец кода.    
;--------------------------------------------------------------
db (512-2-($-0x07C00)) dup(0) ; align 512 bytes
db 0x55, 0xAA                 ; end boot section
;=======================================================================




;=======================================================================
;==================  Второй сектор диска    ============================
Boot2:
	jmp	near BootStart2 	 ;Переходим на код загрузчика 2 сектора
;=======================================================================
mLoading2	db 'Loading 2 sector is OK...', 10,13,0  
;=======================================================================
BootStart2:
    mov	  si, mLoading2
    Call  PrintSTR  
;***********************************************************************
;-------------------------
;    jmp $
;///////////////////////////////////////////////////////////////////////



; start os
_start:
    jmp	near start

; _segment const
    _buffer_size equ 80
    _default_color equ 0x07 ; white

; _segment bss
    _bss_char rb 1
    _bss_str_cursor db 0
    _bss_col_cursor db 0
    _bss_buffer rb _buffer_size

; _segment data
    _start_message db "Operation system 0.0.1", 0

; segment data
    msg_input db "> ", 0

start:
; null registers
    cli
    xor dx, dx
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x07BFF ; head stack
    sti

; clear screen
    call clear_screen


    mov	  si, _start_message
    Call  PrintSTR
;---------------------------------------------------------------
    push ax
    push bx
    push cx
    push bp   
    mov  ax, 0x32
    mov [_bss_char], al
    call  print_char.default_char

 jmp $
;======================================================================
;//////////////////////////////////////////////////////////////////////
; print string
    mov ax, _start_message
    call print_string

; set cursor
    call newline

; loop
    .next_iter:
    ; print string
        mov ax, msg_input
        call print_string

    ; input string 
        mov ax, _bss_buffer
        call input_string

    ; length string 
        mov ax, _bss_buffer
        call length_string

    ; compare zero string
        cmp ax, 0
        je .next_iter

    ; print string
        mov ax, _bss_buffer
        call print_string

        call newline
        jmp .next_iter
    ret

; | input:
; ax = buffer
input_string:
    push ax
    push bp
    push di
    xor di, di
    mov bp, ax
    .next_iter:
        mov ah, 10h
        int 16h
        call print_char
        cmp al, 0Dh
        je .close
        mov [bp+di], al
        inc di
        jmp .next_iter
    .close:
        mov [bp+di], byte 0
        pop di
        pop bp
        pop ax
        ret

left_shift:
    push ax
    push bx
    push dx

    mov dl, [_bss_col_cursor]
    dec dl
    mov [_bss_col_cursor], dl
    mov ah, 0x2
    xor bx, bx
    int 0x10

    pop dx
    pop bx
    pop ax
    ret

backspace:
    push ax
    push dx

    mov dl, [_bss_col_cursor]
    cmp dl, 2
    jle .close

    call left_shift
    xor ax, ax
    call print_char
    call left_shift

    .close:
        pop dx
        pop ax
        ret

clear_screen:
    push ax
    mov ax, 0x02
    int 0x10
    pop ax
    ret

newline:
    push ax
    push bx

    mov dh, [_bss_str_cursor]
    inc dh
    mov [_bss_str_cursor], dh

    mov dl, [_bss_col_cursor]
    mov dl, 0
    mov [_bss_col_cursor], dl

    mov ah, 0x02
    xor bx, bx
    int 0x10

    pop bx
    pop ax
    ret

; | input:
; ax = number
print_number:
    push ax
    push bx
    push cx
    push dx
    mov di, dx
    xor cx, cx
    .next_iter:
        cmp ax, 0
        je .next_iter_end
        mov bx, 10
        xor dx, dx
        div bx
        add dx, '0'
        push dx
        inc cx
        jmp .next_iter
    .next_iter_end:
        mov dx, di
        mov di, cx
    .print_iter:
        cmp cx, 0
        je .close
        pop ax
        call print_char
        dec cx
        jmp .print_iter
    .close:
        mov cx, di
        mov dl, [_bss_col_cursor]
        pop dx
        add dl, cl
        mov [_bss_col_cursor], dl
        pop cx
        pop bx
        pop ax
        ret

; | input:
; ax = char
print_char:
    push ax
    push bx
    push cx
    push bp

    mov dl, [_bss_col_cursor]
    mov [_bss_char], al

    cmp al, 08h
    je .backspace_char
    cmp al, 0Dh
    je .newline_char
    jmp .default_char

.newline_char:
    call newline
    jmp .close

.backspace_char:
    call backspace
    jmp .close

.default_char:
    mov cx, 1
    mov bp, _bss_char
    mov bl, _default_color
    mov ax, 0x1301
    int 0x10

    inc dl
    mov [_bss_col_cursor], dl

.close:
    pop bp
    pop cx
    pop bx
    pop ax
    ret

; | input:
; ax = string
print_string:
    push ax
    push bp
    push di
    mov bp, ax
    .next_iter:
        cmp [bp+di], byte 0
        je .close
        mov ax, [bp+di]
        call print_char
        inc di
        jmp .next_iter
    .close:
        pop di
        pop bp 
        pop ax
        ret

; | input
; ax = string
; | output
; ax = length
length_string:
    push di
    push bx
    xor di, di
    mov bx, ax
    .next_iter:
        cmp [bx+di], byte 0
        je .close
        inc di
        jmp .next_iter
    .close:
        mov ax, di
        pop bx
        pop di
        ret
;--------------------------------------------------------------
;db "End code bootloader!" ; Иногда полезно знать где конец кода.    
;--------------------------------------------------------------
;db (512-2-($-0x07C00)) dup(0) ; align 512 bytes
;db 0x55, 0xAA                 ; end boot section
;==============================================================
;=======================================================================
; Выравнивание размера образа на 512 байт                      
times 600h-($-$$)-14 db 0xF7
db 'END User boot!'
;======================================================================= 