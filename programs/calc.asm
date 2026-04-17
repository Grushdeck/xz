; Calculator Program
; Simple arithmetic calculator with GUI

section .data
    calc_display db "0", 0
    calc_buffer db 32 dup(0)
    calc_result dq 0
    calc_operation db 0
    calc_operand dq 0
    calc_decimal_mode db 0
    
    calc_title db "Calculator", 0
    button_width equ 30
    button_height equ 10

section .text
    global init_calculator
    global calc_handle_input
    global calc_display_update
    global calc_perform_operation

init_calculator:
    ; Initialize calculator window
    mov cx, 50
    mov dx, 30
    mov ax, 200
    mov bx, 150
    call gui_create_window
    
    mov si, calc_title
    call gui_draw_window
    
    ; Draw number buttons (0-9)
    xor cx, cx
.draw_numbers:
    cmp cx, 10
    jge .draw_operations
    
    ; Position buttons in 3x3 grid
    mov ax, cx
    xor dx, dx
    mov bx, 3
    div bx
    
    ; Row in AX, Col in DX
    mov si, cx
    mov cx, si
    xor dx, dx
    mov bx, 3
    div bx
    
    mov cx, 60
    add cx, dx
    imul cx, button_width
    add cx, 10
    
    mov dx, 60
    add dx, ax
    imul dx, button_height
    add dx, 40
    
    mov ax, button_width
    mov bx, button_height
    
    ; Draw button
    call gui_draw_button
    
    inc cx
    jmp .draw_numbers
    
.draw_operations:
    ; Draw operation buttons (+, -, *, /, =)
    
    ; Plus button
    mov cx, 160
    mov dx, 60
    mov ax, 30
    mov bx, 10
    mov si, msg_plus
    call gui_draw_button
    
    ; Minus button
    mov cx, 160
    mov dx, 80
    mov ax, 30
    mov bx, 10
    mov si, msg_minus
    call gui_draw_button
    
    ; Multiply button
    mov cx, 160
    mov dx, 100
    mov ax, 30
    mov bx, 10
    mov si, msg_multiply
    call gui_draw_button
    
    ; Divide button
    mov cx, 160
    mov dx, 120
    mov ax, 30
    mov bx, 10
    mov si, msg_divide
    call gui_draw_button
    
    ; Equals button
    mov cx, 160
    mov dx, 140
    mov ax, 30
    mov bx, 10
    mov si, msg_equals
    call gui_draw_button
    
    ret

calc_handle_input:
    ; Handle input (AL = key)
    ; 0-9 = number, + = add, - = sub, * = mul, / = div, = = calculate
    
    cmp al, '0'
    jl .check_ops
    cmp al, '9'
    jg .check_ops
    
    ; Number input
    sub al, '0'
    mov bl, al
    mov rax, [calc_result]
    imul rax, 10
    add rax, rbx
    mov [calc_result], rax
    
    call calc_display_update
    ret

.check_ops:
    cmp al, '+'
    je .op_plus
    cmp al, '-'
    je .op_minus
    cmp al, '*'
    je .op_multiply
    cmp al, '/'
    je .op_divide
    cmp al, '='
    je .op_equals
    ret

.op_plus:
    mov [calc_operation], al
    mov rax, [calc_result]
    mov [calc_operand], rax
    mov qword [calc_result], 0
    call calc_display_update
    ret

.op_minus:
    mov [calc_operation], al
    mov rax, [calc_result]
    mov [calc_operand], rax
    mov qword [calc_result], 0
    call calc_display_update
    ret

.op_multiply:
    mov [calc_operation], al
    mov rax, [calc_result]
    mov [calc_operand], rax
    mov qword [calc_result], 0
    call calc_display_update
    ret

.op_divide:
    mov [calc_operation], al
    mov rax, [calc_result]
    mov [calc_operand], rax
    mov qword [calc_result], 0
    call calc_display_update
    ret

.op_equals:
    call calc_perform_operation
    call calc_display_update
    mov byte [calc_operation], 0
    ret

calc_display_update:
    ; Update display with current result
    mov rax, [calc_result]
    
    ; Convert to string
    mov si, calc_display
    mov cx, 0
    
    cmp rax, 0
    jne .convert_loop
    mov byte [si], '0'
    mov byte [si + 1], 0
    ret
    
.convert_loop:
    xor dx, dx
    mov cx, 10
    div cx
    
    add dl, '0'
    mov [si], dl
    inc si
    
    cmp ax, 0
    jne .convert_loop
    
    mov byte [si], 0
    ret

calc_perform_operation:
    ; Perform calculation based on operation
    mov al, [calc_operation]
    mov rax, [calc_operand]
    mov rbx, [calc_result]
    
    cmp al, '+'
    je .do_add
    cmp al, '-'
    je .do_sub
    cmp al, '*'
    je .do_mul
    cmp al, '/'
    je .do_div
    ret

.do_add:
    add rax, rbx
    mov [calc_result], rax
    ret

.do_sub:
    sub rax, rbx
    mov [calc_result], rax
    ret

.do_mul:
    imul rax, rbx
    mov [calc_result], rax
    ret

.do_div:
    xor dx, dx
    div rbx
    mov [calc_result], rax
    ret

msg_plus db "+", 0
msg_minus db "-", 0
msg_multiply db "*", 0
msg_divide db "/", 0
msg_equals db "=", 0