; =============================================
; MiniOS Bootloader - Stage 1
; Loads kernel from disk into memory at 0x1000
; =============================================
[BITS 16]
[ORG 0x7C00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; Save boot drive
    mov [boot_drive], dl

    ; Print loading message
    mov si, msg_loading
    call print_string

    ; Load kernel (sectors 2-40) to 0x1000
    mov ax, 0x0100      ; segment 0x0100 = linear 0x1000
    mov es, ax
    xor bx, bx          ; offset 0

    mov ah, 0x02         ; BIOS read sectors
    mov al, 39           ; number of sectors to read
    mov ch, 0            ; cylinder 0
    mov cl, 2            ; start from sector 2
    mov dh, 0            ; head 0
    mov dl, [boot_drive]
    int 0x13
    jc disk_error

    ; Jump to kernel
    jmp 0x0100:0x0000

disk_error:
    mov si, msg_error
    call print_string
    jmp $

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp print_string
.done:
    ret

msg_loading db 'MiniOS Loading...', 13, 10, 0
msg_error   db 'Disk Error!', 0
boot_drive  db 0

times 510 - ($ - $$) db 0
dw 0xAA55