format ELF64

extrn printf
extrn scanf

public main

section '.bss'
    number1 rq 1
    number2 rq 1

section '.data'
    sfmt db "%d %d", 0
    pfmt db "[%d]", 0xA, 0

section '.text'
main:
    push rsp

    xor rax, rax
    mov rdi, sfmt
    mov rsi, number1
    mov rdx, number2
    call scanf

    pop rsp

    mov rax, [number1]
    add rax, [number2]
    mov [number1], rax

    xor rax, rax
    mov rdi, pfmt 
    mov rsi, [number1]
    call printf

    call exit

exit:
    mov rax, 1
    xor rbx, rbx
    int 0x80
