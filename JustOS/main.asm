use16
org 0x7C00 ; boot address

_start:
    call start

msg db 'hello, world!', 0     
len = $-msg

start:
; null registers
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x07C00 ; head stack
    sti

; clear screen
    mov ax, 0x02
    int 0x10

; set cursor
    mov dx, 0x00
    mov ah, 0x02
    xor bh, bh
    int 0x10

; print string
    mov bp, msg             
    mov cx, len
    mov bl, 04h
    mov ax, 0x1301
    int 0x10
    ret

times(512-2-($-0x07C00)) db 0 ; align 512 bytes
db 0x55, 0xAA ; end boot section
