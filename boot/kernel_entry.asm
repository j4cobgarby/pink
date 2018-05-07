[bits 32]
[extern main]

    ; asm procedure to call the main function in the high level kernel

    call main
    jmp $
