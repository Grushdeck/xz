; Keyboard Driver Module
; Handles keyboard input and interrupt handling

section .data
    key_buffer db 0
    key_pressed db 0

section .text
    global init_keyboard
    global get_key
    global wait_key

init_keyboard:
    ; Set up keyboard interrupt handler
    mov al, 0x20
    out 0x20, al
    mov al, 0x04
    out 0x21, al
    ret

get_key:
    ; Get last pressed key from buffer
    mov al, [key_buffer]
    mov byte [key_buffer], 0
    mov [key_pressed], 0
    ret

wait_key:
    ; Wait until a key is pressed
    mov byte [key_pressed], 0
.wait_loop:
    cmp byte [key_pressed], 0
    je .wait_loop
    call get_key
    ret

handle_keyboard:
    ; Keyboard interrupt handler
    in al, 0x60
    mov [key_buffer], al
    mov byte [key_pressed], 1
    mov al, 0x20
    out 0x20, al
    iret