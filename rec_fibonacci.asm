; f(0) = 0
; f(1) = 1
; f(n) = f(n-1) + f(n-2)
; 0  1  2  3  4  5  6   7   8   9
; 0, 1, 1, 2, 3, 5, 8, 13, 21, 34 ...
section '.fibonacci' executable
; | input:
; rax = number
; | output:
; rax = number
fibonacci:
	push rbx
	xor ebx, ebx
	call .fibonacci
	mov rax, rbx
	pop rbx
	jmp .close
.fibonacci:
	cmp rax, 0
	je .close
	cmp rax, 1
	je .return
	push rax
	dec rax
	call .fibonacci
	pop rax
	dec rax
	dec rax
	call .fibonacci
	jmp .close
.return:
	inc rbx
.close:
	ret
