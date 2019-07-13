format ELF64 executable
entry _start

filename db "just_file.txt", 0

_start:
    ; Create
    mov rax, 8
    mov rbx, filename
    mov rcx, 0777
    int 0x80
    
    ; descriptor
    push rax
    
    ; Close
    mov rax, 6
    pop rbx
    int 0x80

    call exit

exit:
    mov rax, 1
    mov rbx, 0
    int 0x80
