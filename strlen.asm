; input:
; - rax = string
; output:
; - rax = length
strlen:
    mov rbx, rax
    .next_iter:
        cmp byte[rax], 0
        je .end
        inc rax
        jne .next_iter
    .end:
        sub rax, rbx
        ret
