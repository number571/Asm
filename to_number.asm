; input:
; - rsi = string
; - rcx = length
; output:
; - rax = number
to_number:
    xor rax, rax
    cmp rcx, 0
    je .end
    .next_value:
        dec rcx
        movzx rbx, byte[rsi]
        inc rsi
        sub rbx, '0'
        add rax, rbx
        cmp rcx, 0
        je .end
        cmp byte[rsi], 0xA
        je .end
        mov rbx, 10
        mul rbx
        jmp .next_value
    .end:
        ret
