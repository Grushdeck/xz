; Graphics Driver Module
; Handles basic video mode initialization and pixel drawing

section .data
    video_mode db 0x13        ; VGA 320x200x256
    screen_width equ 320
    screen_height equ 200
    video_memory equ 0xA0000

section .text
    global init_graphics
    global set_pixel
    global clear_screen
    global set_palette

init_graphics:
    ; Initialize VGA 320x200x256 mode
    mov ax, 0x0013
    int 0x10
    ret

set_pixel:
    ; Input: CX = x, DX = y, AL = color
    push dx
    mov ax, dx
    mov dx, screen_width
    imul dx
    add ax, cx
    mov di, video_memory
    add di, ax
    mov byte [es:di], al
    pop dx
    ret

clear_screen:
    ; Clear entire screen with color in AL
    push ax
    mov cx, screen_width
    imul cx, screen_height
    mov di, video_memory
    rep stosb
    pop ax
    ret

set_palette:
    ; Set color palette entry (AL = index, BX = RGB)
    mov dx, 0x3C8
    out dx, al
    mov dx, 0x3C9
    mov al, bh
    out dx, al
    mov al, bl
    out dx, al
    mov al, cl
    out dx, al
    ret