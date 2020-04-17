format ELF64
public _start

include "asmlib/fmt.inc"
include "asmlib/sys.inc"

section '.text' executable
_start:
	mov rax, 8
	call fibonacci
	call print_number
	call print_line
	jmp exit

; f(0) = 0
; f(1) = 1
; f(2) = 1
; f(n) = f(n-1) + f(n-2)
; 0  1  2  3  4  5  6   7   8   9
; 0, 1, 1, 2, 3, 5, 8, 13, 21, 34 ...
section '.fibonacci' executable
; | input:
; rax = number
; | output:
; rax = number
fibonacci:
	push rcx
	mov rcx, 1
	call .fibonacci
	mov rax, rcx
	pop rcx
	ret
.fibonacci:
	cmp rax, 0
	je .return0
	cmp rax, 2
	jle .return1
	push rax
	dec rax
	call .fibonacci
	pop rax
	dec rax
	dec rax
	call .fibonacci
	inc rcx
	jmp .close
.return0:
	mov rax, 0
	ret
.return1:
	mov rax, 1
.close:
	ret
