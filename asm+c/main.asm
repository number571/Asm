format ELF64

public factorial
public input_number
public print_number

section '.bss' writable
    buffsize equ 20
    buffer rb buffsize

section '.text' executable

factorial:
    mov rbx, rdi
    mov rax, 1
    .next_iter:
        cmp rbx, 1
        jle .end
        mul rbx
        dec rbx
        jmp .next_iter
    .end:
        ret

input_number:
    mov rax, 0
    mov rdi, 2
    mov rsi, buffer
    mov rdx, buffsize
    syscall

    mov rsi, buffer
    mov rcx, buffsize
    call to_number

    ret

print_number:
    mov rax, rdi
    mov rsi, buffer
    mov rcx, buffsize
    call to_string

    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, buffsize
    syscall

    mov rax, 1
    mov byte[rsi], 0xA
    mov rdx, 1
    syscall

    ret    

; input:
; - rax = number
; - rcx = buffer size
; - rsi = buffer
; output:
; - rcx = length
to_string:
    mov rdi, rcx
    xor rcx, rcx
    .push_digit:
        cmp rcx, rdi
        je .pop_digit
        xor rdx, rdx
        mov rbx, 10
        div rbx
        add rdx, '0'
        push rdx
        inc rcx
        cmp rax, 0
        je .pop_digit
        jmp .push_digit
    .pop_digit:
        cmp rcx, 0
        je .end
        pop rdx
        mov [rsi], rdx
        inc rsi
        dec rcx
        jmp .pop_digit
    .end:
        mov rdx, 0
        mov [rsi+rax], rdx
        ret

; input:
; - rsi = string
; - rcx = length
; output:
; - rax = number
to_number:
    xor rax, rax
    cmp rcx, 0
    je .end
    .next_value:
        dec rcx
        movzx rbx, byte[rsi]
        inc rsi
        sub rbx, '0'
        add rax, rbx
        cmp rcx, 0
        je .end
        cmp byte[rsi], 0xA
        je .end
        mov rbx, 10
        mul rbx
        jmp .next_value
    .end:
        ret
