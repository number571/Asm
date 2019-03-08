section .text
	global _start

section .bss
	buff resb 20

section .data
	msg db "hello, world", 0xA, 0
	len equ $-msg

_start:
	xor ecx, ecx

	lp:
		mov eax, [msg+ecx]
		mov [buff+ecx], eax 

		inc ecx
		cmp ecx, len
		jne lp

	mov eax, 4
	mov ebx, 1
	mov ecx, buff
	mov edx, len
	int 0x80

	mov eax, 1
	mov ebx, 0
	int 0x80
