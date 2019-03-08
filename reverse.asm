section .text
    global _start

section .bss
    buffer resb 50

section .data
    msg db "hello", 0
    len equ $-msg

_start:
    mov ecx, len-1
    mov edx, 0

    _loop:
        mov eax, [msg+ecx]
        mov [buffer+edx], eax

        inc edx
        dec ecx

        cmp ecx, -1
        jne _loop

    mov eax, 0xA
    mov [buffer+edx], eax

    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, len+1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
