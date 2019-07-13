format ELF64 executable
entry _start

filename db "just_file.txt", 0
contents db "hello, world!!!", 0xA, 0
length = $-contents

_start:
    mov rax, 5
    mov rbx, filename
    mov rcx, 1
    int 0x80

    ; descriptor
    push rax

    mov rax, 19
    pop rbx
    mov rcx, 0 ; move cursor
    mov rdx, 0
    ; SEEK_SET = 0
    ; SEEK_CUR = 1
    ; SEEK_END = 2
    int 0x80

    ; Write
    mov rax, 4
    ; rbx = descriptor
    mov rcx, contents
    mov rdx, length
    int 0x80
    
    ; Close
    mov rax, 6
    ; rbx = descriptor
    int 0x80

    call exit

exit:
    mov rax, 1
    mov rbx, 0
    int 0x80
