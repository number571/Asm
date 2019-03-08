section .text
	global _start

section .bss
	buffer resb 20

section .data
	length equ 20

_start:
	mov eax, 3
	mov ebx, 2
	mov ecx, buffer
	mov edx, length
	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, buffer
	mov edx, length
	int 0x80

	mov eax, 1
	mov ebx, 0
	int 0x80
