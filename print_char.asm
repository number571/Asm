format ELF64
public _start

section '.text' executable 
_start:
	mov rax, 'A'
	call print_char
	call exit

section '.print_char' executable
; rax = char
print_char:
	push rdx
	push rcx
	push rax

	mov rax, 1
	mov rdi, 1
	mov rsi, rsp
	mov rdx, 1
	syscall

	pop rax
	pop rcx
	pop rdx
	ret

section '.exit' executable
exit:
	mov rax, 1
	xor rbx, rbx
	int 0x80
