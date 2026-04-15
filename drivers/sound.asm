; Sound Driver Module
; Handles PC speaker sound generation

section .data
    speaker_port equ 0x61
    timer_port equ 0x42
    timer_control equ 0x43

section .text
    global init_sound
    global play_tone
    global stop_sound
    global play_beep

init_sound:
    ; Initialize PC speaker and timer
    mov al, 0x36
    out timer_control, al
    ret

play_tone:
    ; Play tone at frequency in AX, duration in CX (ms)
    push cx
    push ax
    
    mov cx, 1193180
    xor dx, dx
    div cx
    mov cx, ax
    
    mov al, 0xB6
    out timer_control, al
    mov al, cl
    out timer_port, al
    mov al, ch
    out timer_port, al
    
    in al, speaker_port
    or al, 0x03
    out speaker_port, al
    
    pop ax
    pop cx
    ret

stop_sound:
    ; Stop sound output
    in al, speaker_port
    and al, 0xFC
    out speaker_port, al
    ret

play_beep:
    ; Quick beep sound
    mov ax, 1000
    mov cx, 100
    call play_tone
    mov ax, 0
    call stop_sound
    ret