macro to_string buffer, integer {
    x = integer

    c = 0
    while x <> 0 
        push (x mod 10) + '0'
        x = x / 10
        c = c + 1
    end while

    lea rsi, [buffer]
    while c <> 0 
        pop rdx
        mov [rsi], rdx
        inc rsi
        c = c - 1
    end while
}
