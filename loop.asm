section .text
	global _start

section .bss
	num resb 1

section .data
	msg db "hello, world", 0xA, 0
	len equ $-msg

_start:
	mov eax, 3
	mov [num], eax

	lp:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg
		mov edx, len
		int 0x80

		mov eax, [num]
		dec eax
		mov [num], eax

		cmp eax, 0
		jne lp

	mov eax, 1
	mov ebx, 0
	int 0x80
