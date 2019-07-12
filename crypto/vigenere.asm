format ELF64 executable
entry _start

    key db "WORLD", 0
    msg db "HELLOHELLO", 0xA, 0
    len = $-msg

macro vigenere mode, msg, key, len {
    local _iter, _end
    x = 0

; Key's length
    mov rax, key
    mov rdx, 0
_iter:
    cmp byte[rax+rdx], 0
    je _end
    inc rdx
    jmp _iter
_end:

    xor rcx, rcx
    while x <> len
        ; Encryption
        xor ax, ax
        mov al, [msg+x]
        if mode = 'e'
            add al, [key+rcx]
        else
            sub al, [key+rcx]
            add al, 26
        end if
        mov bl, 26
        div bl
        add ah, 'A'
        mov [msg+x], ah
        x = x + 1

        ; Key extension
        inc rcx
        push rdx
        mov rax, rcx
        mov rcx, rdx
        xor rdx, rdx
        div rcx
        mov rcx, rdx
        pop rdx
    end while
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
