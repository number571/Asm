section .bss
	res resb 1

section .text
	global _start

_start:
	mov eax, 32
	mov [res], eax

	mov ebx, 1
	mov ecx, res
	mov edx, 1

	lp:
		mov eax, 4
		int 0x80

		mov eax, [res]
		inc eax

		mov [res], eax

		cmp eax, 127
		jne lp

	mov eax, 0xA
	mov [res], eax

	mov eax, 4
	mov ebx, 1
	mov ecx, res
	mov edx, 1
	int 0x80

	mov eax, 1
	mov ebx, 0
	int 0x80
