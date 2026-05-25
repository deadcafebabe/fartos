org 0x7C00
bits 16

KERNEL_LOCATION equ 0x1000
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; Header
jmp short end_header
nop

bdb_oem:                    db 'MSWIN4.1'           ; 8 bytes
bdb_bytes_per_sector:       dw 512
bdb_sectors_per_cluster:    db 1
bdb_reserved_sectors:       dw 1
bdb_fat_count:              db 2
bdb_dir_entries_count:      dw 0x0E0
bdb_total_sectors:          dw 2880                 ; 2880 * 512 = 1.44MB
bdb_media_descriptor_type:  db 0x0F0                 ; F0 = 3.5" floppy disk
bdb_sectors_per_fat:        dw 9                    ; 9 sectors/fat
bdb_sectors_per_track:      dw 18
bdb_heads:                  dw 2
bdb_hidden_sectors:         dd 0
bdb_large_sector_count:     dd 0

; extended boot record
ebr_drive_number:           db 0                    ; 0x00 floppy, 0x80 hdd, useless
                            db 0                    ; reserved
ebr_signature:              db 0x29
ebr_volume_id:              db 0x12, 0x34, 0x56, 0x78   ; serial number, value doesn't matter
ebr_volume_label:           db 'FARTOS     '        ; 11 bytes, padded with spaces
ebr_system_id:              db 'FAT12   '           ; 8 bytes

rootdir_addr: dw 0 

end_header:
    jmp main

puts:
    mov si, ax
    mov ah, 0xE
    cld

.loop:
    lodsb
    cmp al, 0
    jz .endloop
    int 0x10
    jmp .loop

.endloop:
    ret

read_disk:
    push ax
    push cx
    push dx
    
    xor dx, dx                          ; dx = 0
    div word [bdb_sectors_per_track]    ; ax = LBA / SectorsPerTrack
                                        ; dx = LBA % SectorsPerTrack

    inc dx                              ; dx = (LBA % SectorsPerTrack + 1) = sector
    mov cx, dx                          ; cx = sector

    xor dx, dx                          ; dx = 0
    div word [bdb_heads]                ; ax = (LBA / SectorsPerTrack) / Heads = cylinder
                                        ; dx = (LBA / SectorsPerTrack) % Heads = head
    mov dh, dl                          ; dh = head
    mov ch, al                          ; ch = cylinder (lower 8 bits)
    shl ah, 6
    or cl, ah                           ; put upper 2 bits of cylinder in CL
    
    pop ax
    mov dl, al ; restore disk number to dl
    
    pop ax
    mov ah, 2
    int 0x13

    pop ax
    ret

main:
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov cx, ax
    mov sp, 0x8000

    mov ax, 3
    int 0x10

    mov ax, word [bdb_sectors_per_fat]
    mul [bdb_fat_count]
    add ax, [bdb_reserved_sectors]

    mov bx, KERNEL_LOCATION
    mov cx, 1
    call read_disk

    mov cx, 512
    mul cx
    mov word [rootdir_addr], ax

.search_kernel:
    mov si, kernel_filename
    mov di, bx
    xor cl, cl

.loop:
    mov al, [si]
    inc si
    mov dl, [di]
    inc di

    cmp al, dl
    jne .endloop

    inc cl
    jmp .loop

.endloop:
    cmp cl, 11
    je .kernel_found
    
    cmp al, 0
    jz .end

    add bx, 32
    jmp .search_kernel

.kernel_found:
    mov ax, 32
    mul word [bdb_dir_entries_count]
    add ax, word [rootdir_addr]
    xor dx, dx

    mov cx, 512
    div cx

    mov cx, word [bx + 0x1A]
    sub cx, 2

    add ax, cx

    mov bx, KERNEL_LOCATION
    mov cx, 1
    call read_disk

    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x8:KERNEL_LOCATION

.end:
    mov ax, kernel_404
    call puts
    jmp $

gdt_start:
    gdt_null:
        dd 0x0
        dd 0x0

    gdt_code:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0

    gdt_data:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

kernel_filename: db "KERNEL  BIN"
kernel_404: db "Kernel not found", 0xA, 0xD, 0

times 510-($-$$) db 0
dw 0xAA55
