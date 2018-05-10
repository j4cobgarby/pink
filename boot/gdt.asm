; ACCESS BYTE:
; | Pr | Privl | 1 | Ex | DC | RW | Ac |
; Pr = always 1 (present bit for valid sectors, 0 for null sector)
; Privl = ring level (0 = kernel, 3 = user apps)
; Ex = Executable (1 if executable)
; DC = direction bit (0 for segment growing up, 1 for growing down)
; RW = readable or writeable (readable for code segs, writeable for data)
; Ac = set it to 0 - set to 1 automatically when accessed

; FLAGS:
; | Gr | Sz | 0 | 0 |
; Gr = granularity (0 for 1 byte blocks, 1 for 4KiB blocks) of page
; Sz = Size bit. 0 for 16 bit prot, 1 for 32 bit prot

gdt_start:
gdt_null: ; null segment descriptor is needed for some reason
    dd 0x0
    dd 0x0
    
gdt_code: ; code segment descriptor
    ; base: 0, limit: 0xfffff
    dw 0xffff       ; first 16 bits of the limit
    dw 0x0          ; first 16 bits of the base
    db 0x0          ; bits 16-23 of the base
    db 10011010b    ; acess byte (permissions, basically), refer above
    db 11001111b    ; 16-19 bits of limit, followed by flags (LITTLE endian, remember)
    db 0x0          ; bits 24-31 of base

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
