; rax = buffer
; rbx = string
; rcx = length
copy:
    .next_value:
        mov rdx, [rbx+rcx]
        mov [rax+rcx], rdx
        cmp rcx, 0
        je .end
        dec rcx
        jmp .next_value
    .end:
        ret
