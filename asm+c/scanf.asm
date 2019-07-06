format ELF64

extrn printf
extrn scanf

public main

section '.bss'
    number rq 1

section '.data'
    sfmt db "%d", 0
    pfmt db "[%d]", 0xA, 0

section '.text'
main:
    push rsp

    xor rax, rax
    mov rdi, sfmt
    mov rsi, number
    call scanf

    pop rsp

    mov rax, [number]
    mov rbx, 3
    mul rbx
    mov [number], rax

    xor rax, rax
    mov rdi, pfmt 
    mov rsi, [number]
    call printf

    call exit

exit:
    mov rax, 1
    xor rbx, rbx
    int 0x80
