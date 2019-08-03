format ELF64
public _start

section '.data' writable
	message db "hello, world!", 0xA, 0

section '.text' executable 
_start:
	mov rax, message
	call print_string
	call exit

section '.print_string' executable
; rax = string
print_string:
	push rax
	push rbx
	push rcx
	
	call length_string
	mov rdx, rbx
	mov rcx, rax
	mov rax, 4
	mov rbx, 1
	int 0x80

	pop rcx
	pop rbx
	pop rax
	ret

section '.length_string' executable
; | input:
; rax = string
; | output:
; rbx = length
length_string:
	push rax
	xor rbx, rbx
	.next_iter:
		cmp [rax], byte 0
		je .close
		inc rbx
		inc rax
		jmp .next_iter
	.close:
		pop rax
		ret

section '.exit' executable
exit:
	mov rax, 1
	xor rbx, rbx
	int 0x80
