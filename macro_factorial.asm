; output:
; - rax = number
macro factorial integer {
    x = integer
    s = 1
    while x <> 0
        s = s * x
        x = x - 1
    end while
    mov rax, s
}
