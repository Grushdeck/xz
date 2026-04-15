; Mouse Driver Module
; Handles mouse input and cursor control

section .data
    mouse_x dw 160
    mouse_y dw 100
    mouse_buttons db 0
    cursor_char db 0xDB

section .text
    global init_mouse
    global get_mouse_pos
    global set_mouse_pos
    global draw_cursor

init_mouse:
    ; Initialize PS/2 mouse
    mov ax, 0xC205
    int 0x15
    ret

get_mouse_pos:
    ; Return current mouse position (CX = x, DX = y)
    mov cx, [mouse_x]
    mov dx, [mouse_y]
    ret

set_mouse_pos:
    ; Set mouse position (CX = x, DX = y)
    mov [mouse_x], cx
    mov [mouse_y], dx
    ret

draw_cursor:
    ; Draw cursor at current position
    mov cx, [mouse_x]
    mov dx, [mouse_y]
    mov al, 0x0F
    call set_pixel
    ret

handle_mouse:
    ; Mouse interrupt handler
    push ax
    in al, 0x60
    ; Update mouse coordinates based on movement data
    pop ax
    iret