; ASCII Art Program
; Display MiniOS logo and ASCII art

section .data
    logo db 13, 10
        db "    __  ___     _     ____  _____ ", 13, 10
        db "   |  \/  (_)   (_)   / __ \/ ____| ", 13, 10
        db "   | |  | |_ _ __ _ _| |  | | (___  ", 13, 10
        db "   | |  | | | '__| '_| |  | |\___ \ ", 13, 10
        db "   | |__| | | |  | | | |__| |____) |", 13, 10
        db "   |_____/|_|_|  |_|  \____/|_____/ ", 13, 10
        db 13, 10
        db "       16-bit Operating System v0.1", 13, 10
        db "     For Educational Purposes Only", 13, 10
        db 13, 10, 0
    
    system_info db "System Information:", 13, 10
        db "- CPU: 8086 (16-bit)", 13, 10
        db "- Video: VGA 320x200x256", 13, 10
        db "- Memory: 640KB", 13, 10
        db "- Storage: FAT12 Floppy", 13, 10
        db "- USB Support: Enabled", 13, 10
        db 13, 10, 0
    
    features db "Features:", 13, 10
        db "- Preemptive Multitasking", 13, 10
        db "- Graphical User Interface", 13, 10
        db "- File System (FAT12)", 13, 10
        db "- USB Device Support", 13, 10
        db "- Built-in Programs:", 13, 10
        db "  * Graphics Demo", 13, 10
        db "  * Music Player", 13, 10
        db "  * Paint Application", 13, 10
        db "  * Calculator", 13, 10
        db "  * File Browser", 13, 10
        db 13, 10, 0
    
    controls db "Controls:", 13, 10
        db "- F1: Graphics Demo", 13, 10
        db "- F2: Music Player", 13, 10
        db "- F3: Paint Application", 13, 10
        db "- F4: Calculator", 13, 10
        db "- F5: ASCII Art", 13, 10
        db "- ESC: Return to Desktop", 13, 10
        db 13, 10, 0
    
    footer db "=================================", 13, 10
        db "Press any key to continue...", 13, 10, 0

section .text
    global init_ascii_art
    global display_logo
    global display_system_info

init_ascii_art:
    ; Clear screen for ASCII art display
    mov al, 0x00
    call clear_screen
    
    ; Set text mode
    mov ax, 0x0003
    int 0x10
    
    ; Display logo
    call display_logo
    
    ; Display system info
    call display_system_info
    
    ; Display features
    mov si, features
    call print_string
    
    ; Display controls
    mov si, controls
    call print_string
    
    ; Display footer
    mov si, footer
    call print_string
    
    ; Wait for key
    mov ah, 0x00
    int 0x16
    
    ret

display_logo:
    ; Display MiniOS logo
    mov si, logo
    call print_string
    ret

display_system_info:
    ; Display system information
    mov si, system_info
    call print_string
    ret

print_string:
    ; Print string at DS:SI
.print_loop:
    lodsb
    or al, al
    jz .print_done
    
    cmp al, 13
    je .print_cr
    
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp .print_loop
    
.print_cr:
    lodsb
    cmp al, 10
    jne .print_loop
    
    mov ah, 0x0E
    mov al, 13
    int 0x10
    
    mov al, 10
    int 0x10
    
    jmp .print_loop
    
.print_done:
    ret