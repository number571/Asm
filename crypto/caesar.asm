format ELF64 executable
entry _start

msg db "HELLO", 0xA, 0
len = $-msg

macro caesar mode, msg, key, len {
    x = 0
    while x <> len
        xor ax, ax
        mov al, [msg+x]
        if mode = 'e'
            add al, key
        else
            sub al, key
        end if
        sub al, 13
        mov bl, 26
        div bl
        add ah, 'A'
        mov [msg+x], ah
        x = x + 1
    end while
}

_start:
    caesar 'e', msg, 3, len-2

    mov rax, 4
    mov rbx, 1
    mov rcx, msg
    mov rdx, len
    int 0x80

    call exit

exit:
    mov rax, 1
    mov rbx, 0
    int 0x80
