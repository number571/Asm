; input:
; - eax = string
; output:
; - eax = length
strlen:
    mov ebx, eax
    .next_iter:
        cmp byte[eax], 0
        je .end
        inc eax
        jne .next_iter
    .end:
        sub eax, ebx
        ret
