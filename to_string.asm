section .text
    global _start

section .bss
    _buff resb 20
    buff resb 20

section .data
    newline db 0xA

reverse:
    mov esi, eax
    mov edi, ebx

    xor edx, edx

    _reverse_loop:
        mov eax, [edi+ecx]
        mov [esi+edx], eax

        inc edx
        dec ecx

        cmp ecx, -1
        jne _reverse_loop

    ret

to_string:
    xor edi, edi
    inc edi

    _loop:
        xor edx, edx
        mov ecx, 10
        div ecx

        add edx, '0'
        mov [_buff+edi], edx

        inc edi
        cmp eax, 0
        jne _loop

    mov byte[_buff], 0
    mov edx, edi
    inc edx

    mov eax, ebx
    mov ebx, _buff
    mov ecx, edx
    call reverse

    ret

_start:
    mov eax, 571
    mov ebx, buff
    call to_string

    mov eax, 4
    mov ebx, 1
    mov ecx, buff
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
