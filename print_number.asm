format ELF64
public _start

section '.text' executable 
_start:
	mov rax, 571
	mov rbx, 3
	call print_number
	call exit

section '.print_number' executable
; rax = number
; rbx = length 
print_number:
	push rax
	push rbx
	mov rcx, rbx
	.next_iter:
		cmp rbx, 0
		jle .print_iter
		push rcx
		mov rcx, 10
		xor rdx, rdx
		div rcx
		pop rcx
		add rdx, '0'
		push rdx
		dec rbx
		jmp .next_iter
	.print_iter:
		cmp rcx, 0
		jle .close
		pop rax
		call print_char
		dec rcx
		jmp .print_iter
	.close:
		mov rax, 0xA
		call print_char
		pop rbx
		pop rax
		ret

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
