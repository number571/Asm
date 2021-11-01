format binary
use16
;-----------------------------------------------------
;MBR всегда находится на первом секторе жесткого диска. 
;При загрузке компьютера, BIOS считывает этот сектор 
;с диска в память по адресу 0000:7C00h и передает ему 
;управление.
;-----------------------------------------------------
;Между сектором MBR и началом первого раздела диска
;всегда есть дополнительные неиспользуемые 62 сектора.
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
;всегда есть дополнительные неиспользуемые 62 сектора.
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
;=======================================================================
;***********************************************************************
; Выравнивание размера образа на 512 байт                      
times 200h-($-$$)-66 db 0xF7
;***********************************************************************
;  резерв для файловой системы    
dq ?    ; 1 раздел
dq ?    ; *
dq ?    ; 2 раздел
dq ?    ; *
dq ?    ; 3 раздел
dq ?    ; *
dq ?    ; 4 раздел
dq ?    ; *
BootMagic	 	 dw 0xAA55	      ; Сигнатура загрузочного сектора
;=======================================================================
;***********************************************************************



org 0x7E00
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
;///////////////////////////////////////////////////////////////////////




    jmp	near start
;=======================================================================
; Ядро OS
;-----------------------------------------------------------------------

include "core.fasm"


;=======================================================================
; Выравнивание размера образа на 512 байт                      
times 0A00h-($-$$)-14 db 0xF0
db 'END User boot!'
;=======================================================================