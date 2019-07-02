; input:
; - rax = number
; output:
; - rax = number
factorial:
    mov rbx, rax
    mov rax, 1
    .next_iter:
        cmp rbx, 1
        jle .end
        mul rbx
        dec rbx
        jmp .next_iter
    .end:
        ret
