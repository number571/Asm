use16
org 0x7C00 ; boot address

; start os
_start:
    call start

; segment bss
    bss_char db 1

; segment data
    str_msg db "Operation system 0.0.1", 0
    msg_hello db "hello, world! ", 0
    msg_number db "Number: ", 0

; constants
    number equ 571

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
    call clear_screen

; print string
    mov ax, str_msg
    call print_string

; set cursor
    call new_line

; print string
    mov ax, msg_hello
    call print_string

    mov ax, msg_number
    call print_string

    mov ax, number
    call print_number

    mov ax, '.'
    call print_char

    call new_line
    ret

clear_screen:
    push ax
    mov ax, 0x02
    int 0x10
    pop ax
    ret

new_line:
    push ax
    push bx

    mov ah, 0x02
    add dh, 1
    xor dl, dl
    xor bh, bh
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
        pop dx
        add dl, cl
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

    mov [bss_char], al

    mov cx, 1
    mov bp, bss_char
    mov bl, 0x04 ; color
    mov ax, 0x1301
    int 0x10

    inc dl

    pop bp
    pop cx
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

    mov bl, 0x04 ; color
    mov ax, 0x1301
    int 0x10

    add dl, cl

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
