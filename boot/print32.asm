vga_printc:
    pusha
    ; al should be already set
    mov ebx, 0xb8000
    add ebx, [vga_cursor_position]
    mov [ebx], ax
    add [vga_cursor_position], word 0x2
    popa
    ret

vga_cls:
    pusha
    mov al, ' '
    mov ax, 0x0f
    mov ebx, 0x0
vga_cls_loop:
    call vga_printc
    add ebx, 0x1
    cmp ebx, VGA_LENGTH
    jne vga_cls_loop
    mov [vga_cursor_position], word 0
    popa
    ret

vga_print_string:
    pusha   ; addr. of string should be in ebx
vga_print_string_loop:
    cmp byte [ebx], byte 0
    je vga_print_string_end
    mov al, [ebx]
    call vga_printc
    add ebx, 0x1
    jmp vga_print_string_loop
vga_print_string_end:
    popa
    ret
