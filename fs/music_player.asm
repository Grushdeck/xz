; Music Player Program
; Simple music playback from note sequences

section .data
    current_track db 0
    is_playing db 0
    
    ; Simple melody data (frequency pairs)
    melody db 0x44, 0x46, 0x47, 0x49, 0x4B, 0x4C, 0x4E, 0x50
    melody_length equ $ - melody

section .text
    global init_player
    global play_track
    global stop_track
    global next_track

init_player:
    ; Initialize music player
    call init_sound
    mov byte [is_playing], 0
    mov byte [current_track], 0
    ret

play_track:
    ; Play current track
    mov byte [is_playing], 1
    mov si, melody
    mov cx, melody_length
.play_loop:
    cmp cx, 0
    je .play_done
    
    mov al, [si]
    mov ax, 440
    shl ax, al
    mov cx, 100
    call play_tone
    
    inc si
    dec cx
    jmp .play_loop
    
.play_done:
    mov byte [is_playing], 0
    ret

stop_track:
    ; Stop playback
    call stop_sound
    mov byte [is_playing], 0
    ret

next_track:
    ; Play next track
    call stop_track
    inc byte [current_track]
    call play_track
    ret