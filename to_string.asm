; input:
; - rax = number
; - rcx = buffer size
; - rsi = buffer
; output:
; - rcx = length
to_string:
    mov rdi, rcx
    xor rcx, rcx
    .push_digit:
        cmp rcx, rdi
        je .pop_digit
        xor rdx, rdx
        mov rbx, 10
        div rbx
        add rdx, '0'
        push rdx
        inc rcx
        cmp rax, 0
        je .pop_digit
        jmp .push_digit
    .pop_digit:
        cmp rcx, 0
        je .end
        pop rdx
        mov [rsi], rdx
        inc rsi
        dec rcx
        jmp .pop_digit
    .end:
        mov rdx, 0
        mov [rsi+rax], rdx
        ret
