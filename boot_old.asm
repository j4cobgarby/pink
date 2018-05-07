[org 0x7c00] ; start addressing at 0x7c00, which is where this will be in memory

main:
    mov [BOOT_DRIVE], dl

    mov bp, 0x9000
    mov sp, bp

    mov bx, LOAD_MSG
    call prints

    call load_kernel

    mov bx, LOAD_MSG
    call prints

    call switch_to_32bit_pm ; SHOULD never return from here.

    jmp $

[bits 16]
switch_to_32bit_pm:
    cli
    lgdt [gdt_descript]

    ; now to switch to 32 bit protected mode, set first bit of cr0
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ;; 32 BIT PROTECTED MODE, NOW! :)
    ; now make a far jump so that the CPU finished all instructions it's working on

    jmp CODE_SEG:init_32bit_pm

    %include 'gdt.asm'
    %include 'bios/bios_print.asm'
    %include 'bios/bios_disk.asm'
    %include 'boot/print32.asm'

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET
    mov dh, 15 ; load the first 15 sectors after the boot sector
    mov dl, [BOOT_DRIVE]
    call disk_load

    mov bx, LOADED_MSG
    call prints

    ret

[bits 32]
init_32bit_pm:
    ; init 32 bit registers, and the stack

    mov ebx, TEST_MSG
    call prints

    ; first relocate all of segment registers to DATA_SEG
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; stack is right at top of free space
    mov esp, ebp

    mov ebx, INIT_MSG
    call vga_print_string
    
    call main_32bit_pm

main_32bit_pm:
    call vga_cls

    mov ebx, boot_msg
    mov ah, 0x0f
    call vga_print_string

    call KERNEL_OFFSET

    jmp $

;; DATA

boot_msg: db "Booting pink...", 0

vga_cursor_position: dw 0
VGA_LENGTH equ 0x7d0

BOOT_DRIVE db 0
LOAD_MSG db "Loading kernel. ", 0
LOADED_MSG db "Kernel loaded from disk. ", 0
INIT_MSG db "Protected mode initialised. ", 0
TEST_MSG db "Test. ", 0

KERNEL_OFFSET equ 0x1000

;; MAGIC NUMBER AND PADDING
    times  510-($-$$) db 0
    dw 0xaa55

