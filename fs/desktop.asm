; Desktop Environment Module
; Provides basic GUI and window management

section .data
    desktop_bg_color db 0x01
    window_title db "Simple OS Desktop", 0
    taskbar_height equ 20
    
section .text
    global init_desktop
    global draw_desktop
    global draw_window
    global draw_taskbar

init_desktop:
    ; Initialize desktop environment
    mov al, [desktop_bg_color]
    call clear_screen
    call draw_taskbar
    ret

draw_desktop:
    ; Redraw entire desktop
    call init_desktop
    ret

draw_window:
    ; Draw a window at (CX, DX) with width AX, height BX
    ; Title in DS:SI
    push ax
    push bx
    push cx
    push dx
    
    ; Draw window frame
    mov al, 0x0F
    call draw_rectangle
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

draw_taskbar:
    ; Draw taskbar at bottom of screen
    mov cx, 0
    mov dx, 180
    mov ax, 320
    mov bx, 20
    mov al, 0x07
    call draw_rectangle
    ret

draw_rectangle:
    ; Draw rectangle at (CX, DX) with width AX, height BX, color AL
    push ax
    push cx
    mov di, 0
.draw_loop:
    cmp di, bx
    jge .done
    mov si, 0
.draw_h_loop:
    cmp si, ax
    jge .next_line
    mov cx, si
    add cx, [esp]
    mov dx, di
    add dx, [esp + 4]
    call set_pixel
    inc si
    jmp .draw_h_loop
.next_line:
    inc di
    jmp .draw_loop
.done:
    pop cx
    pop ax
    ret