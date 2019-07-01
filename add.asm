section .text
    global _start

section .bss
    result resb 10

section .data
    n1 db "111", 0
    n2 db "222", 0
    
_start:
    lea rsi, [n1]
    mov rcx, 3
    call to_number

    mov [result], rax

    lea rsi, [n2]
    mov rcx, 3
    call to_number

    ; sum
    add rax, [result]
    lea rsi, [result]
    call to_string

    ; print result
    mov rax, 4
    mov rbx, 1
    mov rcx, result
    mov rdx, 10
    int 0x80

    call newline
    call exit

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
        mov rbx, 10
        mul rbx
        jmp .next_value
    .end:
        ret

; input:
; - rax = number
; - rsi = buffer
; output:
; - rcx = length
to_string:
    xor rcx, rcx
    .push_digit:
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
        cmp rax, rcx
        je .end
        pop rdx
        mov [rsi+rax], rdx
        inc rax
        jmp .pop_digit
    .end:
        mov rdx, 0
        mov [rsi+rax], rdx
        ret

newline:
    mov rax, 4
    mov rbx, 1
    mov byte[rcx], 0xA
    mov rdx, 1
    int 0x80

exit:
    xor rax, rax
    inc rax
    xor rbx, rbx
    int 0x80
