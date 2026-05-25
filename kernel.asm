[bits 32]
pmain:
    mov al, 'A'
    mov ah, 0x0f
    mov [0xb8000], ax
    jmp $
