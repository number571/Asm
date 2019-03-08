section .text
    global _start

section .bss
    buff resb 20

section .data
    msg db "hello, world!", 0
    len equ $-msg

reverse:
    mov esi, eax
    mov edi, ebx

    xor edx, edx
    _loop:
        mov eax, [edi+ecx]
        mov [esi+edx], eax

        inc edx
        dec ecx

        cmp ecx, -1
        jne _loop

    ret

_start:
    mov eax, buff
    mov ebx, msg
    mov ecx, len-1
    call reverse

    mov byte[buff+edx], 0xA

    mov eax, 4
    mov ebx, 1
    mov ecx, buff
    mov edx, len+1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
