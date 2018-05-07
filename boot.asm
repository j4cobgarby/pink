[org 0x7c00]
KERNEL_OFFSET equ 0x1000

    mov [BOOT_DRIVE], dl

    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call prints

    call load_kernel

    call switch_to_pm

    jmp $

    %include "bios/bios_print.asm"
    %include "bios/bios_disk.asm"
    %include "gdt.asm"
    %include "boot/print32.asm"
    %include "boot/switch_to_pm.asm"

    [bits 16]

    load_kernel:
        mov bx, MSG_LOAD_KERNEL
        call prints

        mov bx, KERNEL_OFFSET
        mov dh, 15
        mov dl, [BOOT_DRIVE]
        call disk_load

        ret

    [bits 32]

BEGIN_PM:
    ;mov ebx, 0xdeadbeef
    ;jmp $

    mov ah, 0x0f
    mov al, 'A'
    mov [0xb8000], ax

    ;mov ah, 0x0f
    ;mov ebx, MSG_PROT_MODE
    ;call vga_print_string

    call KERNEL_OFFSET

    jmp $

vga_cursor_position dw 0
VGA_LENGTH equ 0x7d0

BOOT_DRIVE db 0
MSG_REAL_MODE db "in 16 bit ", 0
MSG_PROT_MODE db "in prot mode ", 0
MSG_LOAD_KERNEL db "loading kernel ", 0
MSG_FARJMP db "farjmp ", 0
MSG_PMINIT db "PM Init. ", 0

times 510-($-$$) db 0
dw 0xaa55
