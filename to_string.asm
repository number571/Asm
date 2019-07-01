; input:
; - rax = number
; - rsi = buffer
; output:
; - rcx = length
to_string:
    xor rcx, rcx
    .push_digit:
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
        cmp rax, rcx
        je .end
        pop rdx
        mov [rsi+rax], rdx
        inc rax
        jmp .pop_digit
    .end:
        mov rdx, 0
        mov [rsi+rax], rdx
        ret
