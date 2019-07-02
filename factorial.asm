; input:
; - rax = number
; output:
; - rax = number
factorial:
    mov rbx, rax
    .next_iter:
        cmp rbx, 1
        je .end
        dec rbx
        mul rbx
        jmp .next_iter
    .end:
        ret
