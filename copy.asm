; rax = buffer
; rbx = string
; rcx = length
copy:
    .next_value:
        push word [rbx+rcx]
        pop word [rax+rcx]
        cmp rcx, 0
        je .end
        dec rcx
        jmp .next_value
    .end:
        ret
