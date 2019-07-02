; input:
; - rax = number
; output:
; - rax = number
fibonacci:
    mov rbx, rax
    xor rax, rax
    mov rcx, 1
    .next_iter:
        cmp rbx, 0
        jle .end
        dec rbx
        push rcx
        add rcx, rax
        pop rax
        jmp .next_iter
    .end:
        ret
