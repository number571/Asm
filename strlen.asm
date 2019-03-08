section .text
    global _start

section .data
    msg db "hello, world", 0xA, 0

strlen:
    xor edx, edx
    _loop:
        cmp byte[eax+edx], 0
        je _end
        inc edx
        jmp _loop
    _end:
    ret

_start:
    mov eax, msg
    call strlen

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
