; f(0) = 1
; f(n) = n * f(n-1)
; 6! = 1 * 2 * 3 * 4 * 5 * 6
section '.factorial' executable
; | input:
; rax = number
; | output:
; rax = number
factorial:
	push rbx
	call .factorial
	pop rbx
	jmp .close
.factorial:
	cmp rax, 0
	je .return
	push rax
	dec rax
	call .factorial
	pop rbx
	mul rbx
	jmp .close
.return:
	mov rax, 1
.close:
	ret
