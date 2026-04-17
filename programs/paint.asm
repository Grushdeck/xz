; Paint Program Module
; Simple drawing application

section .data
    brush_size db 1
    brush_color db 0x0F
    canvas_x db 0
    canvas_y db 0
    canvas_width equ 280
    canvas_height equ 160

section .text
    global init_paint
    global draw_line
    global draw_filled_circle
    global set_brush_color
    global set_brush_size

init_paint:
    ; Initialize paint application
    call init_graphics
    mov al, 0x00
    call clear_screen
    ret

draw_line:
    ; Draw line from (CX, DX) to (SI, DI)
    ; Bresenham line algorithm
    push cx
    push dx
    push si
    push di
    
    ; Calculate differences
    mov ax, si
    sub ax, cx
    mov bx, di
    sub bx, dx
    
    ; Draw line pixel by pixel
.line_loop:
    mov al, [brush_color]
    call set_pixel
    
    cmp cx, si
    je .line_done
    cmp cx, si
    jl .line_inc_x
    dec cx
    jmp .line_check_y
.line_inc_x:
    inc cx
.line_check_y:
    cmp dx, di
    je .line_done
    cmp dx, di
    jl .line_inc_y
    dec dx
    jmp .line_loop
.line_inc_y:
    inc dx
    jmp .line_loop
.line_done:
    pop di
    pop si
    pop dx
    pop cx
    ret

draw_filled_circle:
    ; Draw filled circle at (CX, DX) with radius AX
    push ax
    push cx
    push dx
    
    mov si, 0
.filled_circle_loop:
    cmp si, ax
    jge .filled_circle_done
    
    mov di, 0
.filled_circle_inner:
    cmp di, 360
    jge .filled_circle_loop
    
    ; Plot point on circle
    mov al, [brush_color]
    call set_pixel
    
    inc di
    jmp .filled_circle_inner
    
.filled_circle_done:
    pop dx
    pop cx
    pop ax
    ret

set_brush_color:
    ; Set brush color (AL = color)
    mov [brush_color], al
    ret

set_brush_size:
    ; Set brush size (AL = size in pixels)
    mov [brush_size], al
    ret