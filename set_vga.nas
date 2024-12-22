; set video mode to vga 320x200x8 color mode, plate mode
mov al, 0x13
mov ah, 0x0
int 0x10

_hlt:
    hlt
    jmp _hlt