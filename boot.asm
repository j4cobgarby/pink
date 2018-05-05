[org 0x7c00] ; start addressing at 0x7c00, which is where this will be in memory
;[bits 32]

main:
    mov [BOOT_DRIVE], dl    ; bios automatically stores the boot drive in dl
    mov bp, 0x8000          ; set stack base
    mov sp, bp

    mov bx, boot_msg
    call prints

    mov ax, BOOT_DRIVE
    call print_hex

    mov bx, 0x9000  ; load the sectors into es:0x9000
    mov dh, 0x05    ; 5 sectors
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov ax, [0x9000]
    call print_hex

    mov ax, [0x9000 + 512]
    call print_hex

    mov ax, [0x9000 + 1024]
    call print_hex

    mov ax, [0x9000 + 1026]
    call print_hex

    jmp $

    %include 'print.asm'
    %include 'disk.asm'

;; DATA

boot_msg:
    db "Booting!... ",0

BOOT_DRIVE: ; i'll set this to the value for the boot drive, which the bios
    db 0    ; will tell me

;; MAGIC NUMBER AND PADDING
    times  510-($-$$) db 0
    dw 0xaa55

    times 256 dw 0xdada ; the sector immediately after the boot sector
    times 256 dw 0xface ; the sector after that
    times 128 dw 0x1234,0x4321
