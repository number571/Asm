format ELF64 executable
entry _start

buffsize equ 20
buffer rb buffsize

filename db "just_file.txt", 0

macro print msg, len {
    mov rax, 4
    mov rbx, 1
    mov rcx, msg
    mov rdx, len
    int 0x80
}

_start:
    ; Open
    mov rax, 5
    mov rbx, filename
    mov rcx, 0
    int 0x80
    ; 0 = O_RDONLY
    ; 1 = O_WRONLY
    ; 2 = O_RDWR

    ; descriptor
    push rax

    ; Read
    mov rax, 3
    pop rbx
    mov rcx, buffer
    mov rdx, buffsize
    int 0x80

    ; Close
    mov rax, 6
    ; rbx = descriptor
    int 0x80

    print buffer, buffsize

    call exit

exit:
    mov rax, 1
    mov rbx, 0
    int 0x80
