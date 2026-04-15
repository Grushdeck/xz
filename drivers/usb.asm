; USB Driver Module
; Basic USB host controller support

section .data
    usb_devices db 127 dup(0)
    usb_port_status dd 0
    usb_device_count db 0

    ; USB Hub Status Change
    usb_hub_status dw 0
    usb_port_connect dw 0
    usb_port_enable dw 0

section .text
    global init_usb
    global usb_enumerate
    global usb_read_device
    global usb_write_device

init_usb:
    ; Initialize USB Host Controller
    mov al, 0
    mov [usb_device_count], al
    
    ; Send USB reset to hub
    mov ax, 0xFF00
    mov dx, 0x3C4
    out dx, ax
    
    ; Wait for enumeration
    mov cx, 1000
.wait_enum:
    loop .wait_enum
    
    call usb_enumerate
    ret

usb_enumerate:
    ; Enumerate USB devices
    xor cx, cx
    xor dx, dx

.enum_loop:
    cmp cx, 127
    jge .enum_done
    
    ; Check port status
    mov ax, cx
    call usb_get_port_status
    
    test ax, 0x0001
    jz .next_device
    
    ; Device connected
    mov al, [usb_device_count]
    inc al
    mov [usb_device_count], al
    
    ; Get device descriptor
    call usb_get_device_descriptor
    
.next_device:
    inc cx
    jmp .enum_loop

.enum_done:
    ret

usb_get_port_status:
    ; Get status of USB port in AX
    ; Returns port status in AX
    mov dx, 0x3C6
    in ax, dx
    ret

usb_get_device_descriptor:
    ; Get device descriptor from USB device
    ; Returns descriptor data
    
    mov ax, 0x80
    mov cx, 8
    mov dx, 0x3C0
    mov si, usb_devices
    
.read_descriptor:
    in al, dx
    mov [si], al
    inc si
    loop .read_descriptor
    
    ret

usb_read_device:
    ; Read data from USB device
    ; AX = device ID, CX = length
    ; ES:BX = buffer
    
    push ax
    push cx
    push bx
    
    mov dx, 0x3C0
    
.read_loop:
    cmp cx, 0
    je .read_done
    
    in al, dx
    mov [bx], al
    inc bx
    dec cx
    jmp .read_loop

.read_done:
    pop bx
    pop cx
    pop ax
    ret

usb_write_device:
    ; Write data to USB device
    ; AX = device ID, CX = length
    ; ES:BX = buffer
    
    push ax
    push cx
    push bx
    
    mov dx, 0x3C0
    
.write_loop:
    cmp cx, 0
    je .write_done
    
    mov al, [bx]
    out dx, al
    inc bx
    dec cx
    jmp .write_loop

.write_done:
    pop bx
    pop cx
    pop ax
    ret