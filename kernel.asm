; =============================================
; MiniOS Kernel - Main Entry
; =============================================
[BITS 16]
[ORG 0x0000]

SECTION .text

kernel_start:
    ; Setup segments
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; Setup stack
    cli
    mov ax, 0x9000
    mov ss, ax
    mov sp, 0xFFFF
    sti

    ; Install custom interrupt handlers
    call install_interrupts

    ; Initialize mouse driver
    call mouse_init

    ; Switch to graphics mode 320x200 256 colors
    call gfx_set_mode13

    ; Draw desktop
    call desktop_draw

    ; Main kernel loop
.main_loop:
    ; Poll keyboard
    mov ah, 0x01
    int 0x16
    jz .no_key

    mov ah, 0x00
    int 0x16

    ; Check key
    cmp ah, 0x3B         ; F1 - graphics demo
    je .launch_gfx_demo
    cmp ah, 0x3C         ; F2 - music player
    je .launch_music
    cmp ah, 0x3D         ; F3 - paint
    je .launch_paint
    cmp ah, 0x01         ; ESC
    je .back_desktop
    jmp .no_key

.launch_gfx_demo:
    call program_gfx_demo
    call desktop_draw
    jmp .no_key

.launch_music:
    call program_music_player
    call desktop_draw
    jmp .no_key

.launch_paint:
    call program_paint
    call desktop_draw
    jmp .no_key

.back_desktop:
    call desktop_draw

.no_key:
    ; Update mouse cursor
    call mouse_update
    call mouse_draw_cursor

    ; Small delay
    mov cx, 0x0001
    mov dx, 0x8000
    mov ah, 0x86
    int 0x15

    jmp .main_loop

; =============================================
; Include all drivers and programs
; =============================================
%include "drivers/gfx.asm"
%include "drivers/mouse.asm"
%include "drivers/sound.asm"
%include "drivers/keyboard.asm"
%include "programs/desktop.asm"
%include "programs/gfx_demo.asm"
%include "programs/music_player.asm"
%include "programs/paint.asm"

; =============================================
; Interrupt installer
; =============================================
install_interrupts:
    ret

; =============================================
; Data section
; =============================================
SECTION .data

kernel_msg db 'MiniOS Kernel v0.1', 0