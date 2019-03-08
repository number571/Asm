section .text
    global _start

section .data
    msg db "hello, world", 0xA, 0
    len equ $-msg

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
