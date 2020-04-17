format ELF64
public _start

include "asmlib/fmt.inc"
include "asmlib/sys.inc"

section '.text' executable
_start:
	mov rax, 6
	call factorial
	call print_number
	call print_line
	jmp exit

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
	ret
.factorial:
	cmp rax, 1
	jle .return
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
