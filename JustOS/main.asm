use16
org 0x7C00 ; boot address

; start os
_start:
    call start

; segment data
    str_msg db "Operation system 0.0.1", 0
    msg db 'hello, world!', 0

start:
; null registers
    cli
    xor dx, dx
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x07C00 ; head stack
    sti

; clear screen
    mov ax, 0x02
    int 0x10

; print string
    mov ax, str_msg
    call print_string

; set cursor
    call new_line

; print string
    mov ax, msg
    call print_string

; ; set cursor
;     call new_line

; ; print string
;     mov ax, msg
;     call print_string

    ret

new_line:
    push ax
    push bx

    mov ah, 0x02
    add dh, 1
    xor bh, bh
    int 0x10

    pop bx
    pop ax
    ret

; | input:
; ax = string
print_string:
    push ax
    push bx
    push cx
    push bp

    mov bp, ax

    call length_string             
    mov cx, ax

    mov bl, 04h
    mov ax, 0x1301
    int 0x10

    pop bp
    pop cx
    pop bx
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

times(512-2-($-0x07C00)) db 0 ; align 512 bytes
db 0x55, 0xAA ; end boot section
