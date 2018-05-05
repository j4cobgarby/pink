; load dh amount of sectors following the boot sector
; puts the loaded data in es:bx
disk_load:
    ; dl should already be set when this is called

    ; for the bios call to read a sector, the following registers mean:
    ; ah = 0x02
    ; al = total sector count
    ; ch = cylinder
    ; cl = sector to read from
    ; dh = head
    ; dl = drive number
    ; (PARAM) bx = address in es segment to load to

    push dx ; dh is the amount of sectors to read

    mov ah, 0x02    ; BIOS sector read
    mov al, dh      ; al is the amount of sectors to read
    mov ch, 0x00    ; cylinder 0
    mov dh, 0x00    ; head 0
    mov cl, 0x02    ; start sector (the second one, after the boot sector)

    int 0x13        ; call the bios interrupt to do the read

    jc disk_err   ; the carry flag is set if there is a disk read
                    ; error, so if this happens, jump to the disk error
                    ; code

    pop dx          ; this is how many sectors i initially wanted
                    ; (well, dh is, anyway)
    cmp dh, al      ; if these are the same, then i got as many sectors
                    ; as i wanted, otherwise there was some error.
    jne disk_err
    ret

disk_err:
    mov bx, disk_err_msg
    call prints
    jmp $

disk_err_msg:
    db 'Disk error occurred!', 0
