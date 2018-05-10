[bits 16]
printc:
    mov ah, 0x0e ; BIOS teletype function
    int 0x10 ; BIOS interrupt
    ret

; modifies the memory at hex_digits to represent the low 4 bits
; of ax
; and then prints it with the bios, therefore this only works in
; 16 bit real mode
print_hex:
    pusha
    
    ; the value to be converted to hex is expected in ax.
    ; bx is the index to put the character in the string.
    mov bx, 3 ; amount of nibbles - 1
    mov cx, 0 ; a 4 bit section of the number, changed at each
              ; loop
hexloop:
    mov cx, ax
    and cx, 0xf ; put the lowest 4 bits in cx
    
    push bx ; i need bx here because i want to add the nibble to the hex_digits
            ; address to get the character to use. currently that nibble is stored
            ; in cx, but i can only use bx for effective addressing (thanks, x86),
            ; but i still want to keep the value i already had in bx
    mov bx, cx
    mov dl, [bx+hex_digits] ; use dl as a temporary register to store the character
    pop bx  ; bx is now the index to append the character to the string
    mov [bx+hex_out], dl
    
    shr ax, 4 ; mov the second lowest 4 bits to the end of the number
    sub bx, 1 ; decrease the position to append the character to the string
    
    cmp word bx, word 0 ; if the last character isn't reached yet, loop again
    jge hexloop

    mov bx, hex_pre ; print bx = the hex prefix
    call prints
    mov bx, hex_out ; print the hex digits
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
