disk_load:
    push dx

    mov ah, 0x02 ; bios read sector function
    mov al, dh   ; read dh sectors
    mov ch, 0x00 ; cyl 0
    mov dh, 0x00 ; head 0
    mov cl, 0x02 ; start after the boot sector

    int 0x13

    jc disk_error

    pop dx
    cmp dh, al
    jne disk_error
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call prints
    jmp $

DISK_ERROR_MSG db "Disk read error.", 0
