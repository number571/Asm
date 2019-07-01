newline:
    mov rax, 4
    mov rbx, 1
    mov byte[rcx], 0xA
    mov rdx, 1
    int 0x80
