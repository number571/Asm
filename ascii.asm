; input:
; - rsi = buffer
ascii:
    mov rax, 32
    .next_value:
        cmp rax, 127
        je .end
        mov [byte rsi], rax
        inc rsi
        inc rax
        jmp .next_value
    .end:
        ret
