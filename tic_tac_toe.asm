format ELF64 
public _start

include "asmlib/fmt.inc"
include "asmlib/sys.inc"

section '.const' writeable
	is_nothing	equ 0
	is_win		equ 1
	is_win_x	equ 2
	is_win_o	equ 3
	is_draw		equ 4

section '.data' writeable
	input 	db ">> ", 0
	clear	db 0x1B, "[H", 0x1B, "[2J", 0
	win_x	db ">> Winner: X", 0xA, 0
	win_o 	db ">> Winner: O", 0xA, 0
	draw	db ">> Draw", 0xA, 0
	chars	db 0, 'X', 'O'
	cells	db 0, 72, 76, 80, 44, 48, 52, 16, 20, 24
	rsrvd	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	field	db "-------------", 0xA
			db "| 7 | 8 | 9 |", 0xA
			db "|---|---|---|", 0xA
			db "| 4 | 5 | 6 |", 0xA
			db "|---|---|---|", 0xA
			db "| 1 | 2 | 3 |", 0xA
			db "-------------", 0xA, 0

section '.text' executable
_start:
	xor rax, rax
	.next_iter:
		call refresh
		call check
		cmp rax, is_win_x
		je .winner_x
		cmp rax, is_win_o
		je .winner_o
		cmp rax, is_draw
		je .draw
		call write
		jmp .next_iter
	.winner_x:
		mov rax, win_x
		call print_string
		jmp .close
	.winner_o:
		mov rax, win_o
		call print_string
		jmp .close
	.draw:
		mov rax, draw
		call print_string
		jmp .close
	.close:
		jmp exit

section '.refresh' executable
refresh:
	push rax
	mov rax, clear
	call print_string
	mov rax, field
	call print_string
	pop rax
	ret

; | output:
; rax = game result
; ; nothing
; ; win_x
; ; win_y
; ; draw
section '.check' executable
check:
	mov al, [chars+1]
	call check_char
	cmp rax, is_win
	je .win_x
	mov al, [chars+2]
	call check_char
	cmp rax, is_win
	je .win_o
	call check_draw
	cmp rax, is_draw
	je .draw
	jmp .nothing
	.win_x:
		mov rax, is_win_x
		jmp .close
	.win_o:
		mov rax, is_win_o
		jmp .close
	.draw:
		mov rax, is_draw
		jmp .close
	.nothing:
		mov rax, is_nothing
		jmp .close
	.close:
		ret

; | input:
; al = char (x, o)
; | output:
; rax = (is_nothing | is_win)
section '.check_char' executable
check_char:
	push rbx
	mov bl, al
	.check_1c:
		mov rax, 1
		cmp [rsrvd+rax], bl
		jne .check_2c
		mov rax, 4
		cmp [rsrvd+rax], bl
		jne .check_2c
		mov rax, 7
		cmp [rsrvd+rax], bl
		jne .check_2c
		mov rax, is_win
		jmp .close
	.check_2c:
		mov rax, 2
		cmp [rsrvd+rax], bl
		jne .check_3c
		mov rax, 5
		cmp [rsrvd+rax], bl
		jne .check_3c
		mov rax, 8
		cmp [rsrvd+rax], bl
		jne .check_3c
		mov rax, is_win
		jmp .close
	.check_3c:
		mov rax, 3
		cmp [rsrvd+rax], bl
		jne .check_1r
		mov rax, 6
		cmp [rsrvd+rax], bl
		jne .check_1r
		mov rax, 9
		cmp [rsrvd+rax], bl
		jne .check_1r
		mov rax, is_win
		jmp .close
	.check_1r:
		mov rax, 1
		cmp [rsrvd+rax], bl
		jne .check_2r
		mov rax, 2
		cmp [rsrvd+rax], bl
		jne .check_2r
		mov rax, 3
		cmp [rsrvd+rax], bl
		jne .check_2r
		mov rax, is_win
		jmp .close
	.check_2r:
		mov rax, 4
		cmp [rsrvd+rax], bl
		jne .check_3r
		mov rax, 5
		cmp [rsrvd+rax], bl
		jne .check_3r
		mov rax, 6
		cmp [rsrvd+rax], bl
		jne .check_3r
		mov rax, is_win
		jmp .close
	.check_3r:
		mov rax, 7
		cmp [rsrvd+rax], bl
		jne .check_d1
		mov rax, 8
		cmp [rsrvd+rax], bl
		jne .check_d1
		mov rax, 9
		cmp [rsrvd+rax], bl
		jne .check_d1
		mov rax, is_win
		jmp .close
	.check_d1:
		mov rax, 1
		cmp [rsrvd+rax], bl
		jne .check_d2
		mov rax, 5
		cmp [rsrvd+rax], bl
		jne .check_d2
		mov rax, 9
		cmp [rsrvd+rax], bl
		jne .check_d2
		mov rax, is_win
		jmp .close
	.check_d2:
		mov rax, 3
		cmp [rsrvd+rax], bl
		jne .next
		mov rax, 5
		cmp [rsrvd+rax], bl
		jne .next
		mov rax, 7
		cmp [rsrvd+rax], bl
		jne .next
		mov rax, is_win
		jmp .close
	.next:
		mov rax, is_nothing
		jmp .close
	.close:
		pop rbx
		ret

; | output:
; rax = (is_nothing | is_draw)
section '.check_draw' executable
check_draw:
	mov rax, 1
	.next_iter:
		cmp rax, 10
		je .close_iter
		cmp [rsrvd+rax], 0
		je .close_iter
		inc rax
		jmp .next_iter
	.close_iter:
		cmp rax, 10
		je .draw
		jmp .nothing
	.draw:
		mov rax, is_draw
		jmp .close
	.nothing:
		mov rax, is_nothing
		jmp .close
	.close:
		ret

section '.write' executable
write:
	push rax
	push rbx
	push rcx
	mov rax, input
	call print_string
	call input_number
	cmp rax, 0
	jle .close
	cmp rax, 10
	jge .close
	cmp [rsrvd+rax], 0
	jne .close
	xor rbx, rbx
	mov bl, [chars]
	mov cl, [chars+rbx+1]
	mov bl, [cells+rax]
	mov [rsrvd+rax], cl
	mov [field+rbx], cl
	mov bl, [chars]
	cmp bl, 0
	je .bl_to_1
	jmp .bl_to_0
	.bl_to_1:
		mov bl, 1
		jmp .replace
	.bl_to_0:
		mov bl, 0
		jmp .replace
	.replace:
		mov [chars], bl
	.close:
		pop rcx
		pop rbx
		pop rax
		ret
