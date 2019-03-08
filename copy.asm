section .text
    global _start

section .bss
    _len resb 4
    buff resb 20

section .data
    msg db "hello, world", 0xA, 0
    len equ $-msg

copy:
    mov [_len], ecx
    xor edx, edx

    __lp:
        mov ecx, [ebx+edx]
        mov [eax+edx], ecx 

        inc edx
        cmp edx, [_len]
        jne __lp

    ret

_start:
    mov eax, buff
    mov ebx, msg
    mov ecx, len
    call copy

    mov eax, 4
    mov ebx, 1
    mov ecx, buff
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
