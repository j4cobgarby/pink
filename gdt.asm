gdt_start:
gdt_null: ; null segment descriptor is needed for some reason
    dd 0x0
    dd 0x0

gdt_code: ; code segment descriptor
    ; base: 0, limit: 0xfffff
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

gdt_descript:
    dw gdt_end - gdt_start - 1  ; size of GDT - 1
    dd gdt_start                ; start of the GDT

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
