; GUI System - Proper Interface
; Window manager, buttons, text input

section .data
    window_count db 0
    active_window db 0
    
    ; Window structure (max 10 windows)
    windows:
        window_x db 10, 0, 0, 0, 0, 0, 0, 0, 0, 0
        window_y db 10, 0, 0, 0, 0, 0, 0, 0, 0, 0
        window_w db 100, 0, 0, 0, 0, 0, 0, 0, 0, 0
        window_h db 80, 0, 0, 0, 0, 0, 0, 0, 0, 0
        window_visible db 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
    
    ; Colors
    color_window_bg equ 0x07
    color_titlebar equ 0x1F
    color_text equ 0x0F
    color_border equ 0x0E
    color_button equ 0x17
    color_button_hover equ 0x1F

section .text
    global gui_init
    global gui_create_window
    global gui_draw_window
    global gui_draw_button
    global gui_draw_textbox
    global gui_handle_click

gui_init:
    ; Initialize GUI system
    mov byte [window_count], 0
    mov byte [active_window], 0
    ret

gui_create_window:
    ; Create new window
    ; AL = window ID, CX = x, DX = y, AX = width, BX = height
    push ax
    mov al, [window_count]
    inc al
    mov [window_count], al
    pop ax
    ret

gui_draw_window:
    ; Draw window frame
    ; AL = window ID
    
    push ax
    push cx
    push dx
    
    mov cl, al
    xor ch, ch
    
    mov cx, [windows + 0]
    mov dx, [windows + 1]
    mov ax, [windows + 2]
    mov bx, [windows + 3]
    
    ; Draw title bar
    mov al, color_titlebar
    call draw_filled_rect
    
    ; Draw window body
    inc dx
    dec bx
    mov al, color_window_bg
    call draw_filled_rect
    
    ; Draw border
    mov al, color_border
    call draw_rect_outline
    
    pop dx
    pop cx
    pop ax
    ret

gui_draw_button:
    ; Draw button
    ; CX = x, DX = y, AX = width, BX = height
    ; DS:SI = button text
    
    push ax
    push bx
    push cx
    push dx
    push si
    
    mov al, color_button
    call draw_filled_rect
    
    mov al, 0x0F
    call draw_rect_outline
    
    ; Draw text
    add cx, 2
    add dx, 1
    call gui_draw_text
    
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

gui_draw_textbox:
    ; Draw text input box
    ; CX = x, DX = y, AX = width, BX = height
    
    push ax
    push bx
    push cx
    push dx
    
    mov al, 0x0F
    call draw_filled_rect
    
    mov al, 0x07
    call draw_rect_outline
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret

gui_draw_text:
    ; Draw text at CX:DX
    ; DS:SI = text pointer
    
.text_loop:
    lodsb
    or al, al
    jz .text_done
    
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    
    inc cx
    jmp .text_loop
    
.text_done:
    ret

gui_handle_click:
    ; Handle mouse click at CX:DX
    ; Check which window/button was clicked
    ret

draw_filled_rect:
    ; Draw filled rectangle at CX:DX with width AX, height BX, color AL
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov si, 0
.rect_loop:
    cmp si, bx
    jge .rect_done
    
    mov di, 0
.rect_h_loop:
    cmp di, ax
    jge .rect_next_line
    
    mov cx, di
    add cx, [esp + 8]
    mov dx, si
    add dx, [esp + 6]
    
    call set_pixel
    inc di
    jmp .rect_h_loop
    
.rect_next_line:
    inc si
    jmp .rect_loop
    
.rect_done:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

draw_rect_outline:
    ; Draw rectangle outline
    ; CX = x, DX = y, AX = width, BX = height, AL = color
    
    push ax
    push bx
    push cx
    push dx
    
    ; Top line
    mov si, 0
.top_loop:
    cmp si, ax
    jge .left_line
    mov cx, si
    add cx, [esp + 2]
    mov dx, [esp + 1]
    call set_pixel
    inc si
    jmp .top_loop
    
.left_line:
    mov si, 0
.left_loop:
    cmp si, bx
    jge .bottom_line
    mov cx, [esp + 2]
    mov dx, si
    add dx, [esp + 1]
    call set_pixel
    inc si
    jmp .left_loop
    
.bottom_line:
    mov si, 0
.bottom_loop:
    cmp si, ax
    jge .right_line
    mov cx, si
    add cx, [esp + 2]
    mov dx, bx
    add dx, [esp + 1]
    dec dx
    call set_pixel
    inc si
    jmp .bottom_loop
    
.right_line:
    mov si, 0
.right_loop:
    cmp si, bx
    jge .outline_done
    mov cx, ax
    add cx, [esp + 2]
    dec cx
    mov dx, si
    add dx, [esp + 1]
    call set_pixel
    inc si
    jmp .right_loop
    
.outline_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret