; rax = buffer
; rbx = string
; rcx = length
reverse:
    xor rdx, rdx
    dec rcx
    .next_value:
        push word [rbx+rcx]
        pop word [rax+rdx]
        cmp rcx, 0
        je .end
        dec rcx
        inc rdx
        jmp .next_value
    .end:
        ret
