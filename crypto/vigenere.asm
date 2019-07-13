format ELF64 executable
entry _start

    key db "WORLD", 0
    msg db "HELLOHELLO", 0xA, 0
    len = $-msg

macro vigenere mode, msg, key, len {
; Key's length
    mov rdx, 0
@@:
    cmp byte[key+rdx], 0
    je @f
    inc rdx
    jmp @b
@@:

; Default values
    xor rcx, rcx
    xor rbx, rbx
    push rbx
@@:
; Encryption
    pop rbx
    cmp rbx, len
    je @f
    push rbx
    xor ax, ax
    mov al, [msg+rbx]
    if mode = 'e'
        add al, [key+rcx]
    else
        sub al, [key+rcx]
        add al, 26
    end if
    mov bl, 26
    div bl
    add ah, 'A'
    pop rbx
    mov [msg+rbx], ah
    inc rbx
    push rbx

; Key extension
    inc rcx
    push rdx
    mov rax, rcx
    mov rcx, rdx
    xor rdx, rdx
    div rcx
    mov rcx, rdx
    pop rdx
    jmp @b
@@:
}

macro print msg, len {
    mov rax, 4
    mov rbx, 1
    mov rcx, msg
    mov rdx, len
    int 0x80
}

_start:
    vigenere 'e', msg, key, len-2
    print msg, len

    vigenere 'd', msg, key, len-2
    print msg, len

    call exit

exit:
    mov rax, 1
    mov rbx, 0
    int 0x80
