format ELF64
public _start

section '.data' writable
	buffer_size equ 20
	buffer db buffer_size

section '.text' executable 
_start:
	mov rax, 571
	mov rbx, 3
	mov rsi, buffer
	call number_to_string

	mov rax, 4
	mov rbx, 1
	mov rcx, buffer
	mov rdx, 3
	int 0x80

	call exit

section '.number_to_string' executable
; rax = number
; rbx = length 
; rsi = buffer
number_to_string:
	push rax
	push rbx
	push rsi
	mov rcx, rbx
	.next_iter:
		cmp rbx, 0
		jle .copy_number
		push rcx
		mov rcx, 10
		xor rdx, rdx
		div rcx
		pop rcx
		add rdx, '0'
		push rdx
		dec rbx
		jmp .next_iter
	.copy_number:
		cmp rcx, 0
		jle .close
		pop rax
		mov [rsi], rax
		inc rsi
		dec rcx
		jmp .copy_number
	.close:
		mov [rsi], byte 0x0
		pop rsi
		pop rbx
		pop rax
		ret

section '.exit' executable
exit:
	mov rax, 1
	xor rbx, rbx
	int 0x80
