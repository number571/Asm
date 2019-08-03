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
