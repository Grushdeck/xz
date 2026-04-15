; Graphics Demo Program
; Demonstrates drawing capabilities

section .data
    demo_title db "Graphics Demo", 0
    color_index db 0

section .text
    global run_gfx_demo
    global draw_shapes
    global animate_colors

run_gfx_demo:
    ; Initialize graphics demo
    call init_graphics
    call draw_shapes
    call animate_colors
    ret

draw_shapes:
    ; Draw various shapes for demonstration
    push ax
    
    ; Draw lines and rectangles
    mov cx, 50
    mov dx, 50
    mov ax, 100
    mov bx, 100
    mov al, 0x0F
    call draw_rectangle
    
    ; Draw circles
    mov cx, 160
    mov dx, 100
    mov ax, 30
    call draw_circle
    
    pop ax
    ret

draw_circle:
    ; Draw circle at (CX, DX) with radius AX, color AL
    push ax
    push cx
    push dx
    
    mov si, 0
.circle_loop:
    cmp si, ax
    jge .circle_done
    
    ; Bresenham circle algorithm stub
    mov di, 0
.circle_inner:
    cmp di, 360
    jge .circle_loop
    
    inc di
    jmp .circle_inner
    
.circle_done:
    pop dx
    pop cx
    pop ax
    ret

animate_colors:
    ; Animate color transitions
    mov byte [color_index], 0
.color_loop:
    mov al, [color_index]
    cmp al, 256
    jge .color_done
    
    ; Update palette
    inc byte [color_index]
    jmp .color_loop
.color_done:
    ret