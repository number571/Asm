; fasm main.asm
; gcc -no-pie main.o -o main

format ELF64

public main
extrn printf

section '.data'
msg db 'hello, world',0
fmt db '[%s]', 0xA, 0

section '.text'
main:
    xor rax, rax
    mov rdi, fmt 
    mov rsi, msg
    call printf
    ret
