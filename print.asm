printc:
    ;push ebx
    ;push eax
    ;mov ah, MODE_WHITE_ON_BLACK
    ;mov ebx, [write_index]
    ;mov [ebx + VID_MEM], ax
    ;pop eax
    ;pop ebx
    mov ah, 0x0e
    int 0x10
    ret

print_hex:
    pusha
    
    ; the value to be converted to hex is expected in ax.
    ; bx is the index to put the character in the string.
    mov bx, 3 ; amount of nibbles - 1
    mov cx, 0 ; digit index
hexloop:
    mov cx, ax
    and cx, 0xf
    
    push bx
    mov bx, cx
    mov dl, [bx+hex_digits]
    pop bx
    mov [bx+hex_out], dl
    
    shr ax, 4
    sub bx, 1
    
    cmp word bx, word 0
    jge hexloop

    mov bx, hex_pre
    call prints

    popa
    ret

prints:
    pusha   ; The address of the first character in the string should be in bx
printloop:       
    cmp byte [bx], byte 0    ; since the null char (ascii 0) is the string terminator,
    je printend              ; it makes sense to exit the loop when this character is seen.
    mov al, [bx]        ; printc wants the character to print in the lower bytes of the accumulator
    call printc         ; print the current character
    add bx, 1           ; go to the next character
    jmp printloop            ; loop back
printend:                    
    popa                ; return the accumulators to their previous values
    ret

hex_pre:
    db '0x'
hex_out:
    db '0000', 0
hex_digits:
    db '0123456789abcdef', 0

write_index:
    dw 0
