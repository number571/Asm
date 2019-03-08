section .bss
    _buff resb 1

section .text
    global copy, caesar

; eax, buff
; ebx, msg
; ecx, len
copy:
    mov [_buff], ecx
    xor ecx, ecx

    __lp:
        mov edx, [ebx+ecx]
        mov [eax+ecx], edx 

        inc ecx
        cmp ecx, [_buff]
        jne __lp

    ret

; eax, buff
; ebx, key
; ecx, len
; edx, 1 ; -1
caesar:
    cmp edx, 1
    je _encrypt

    cmp edx, -1
    je _decrypt

    ret

; eax, buff
; ebx, key
; ecx, len
_encrypt:
    mov [_buff], ecx
    xor ecx, ecx

    __enc_loop:
        mov edx, [eax+ecx]
        add edx, ebx
        mov [eax+ecx], edx

        inc ecx
        cmp ecx, [_buff]
        jne __enc_loop
    
    ret

; eax, buff
; ebx, key
; ecx, len
_decrypt:
    mov [_buff], ecx
    xor ecx, ecx

    __dec_loop:
        mov edx, [eax+ecx]
        sub edx, ebx
        mov [eax+ecx], edx

        inc ecx
        cmp ecx, [_buff]
        jne __dec_loop
    
    ret
