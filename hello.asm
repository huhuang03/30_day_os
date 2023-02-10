mov ax, hello_msg
mov si, ax

putLoop:
    mov al, [si]    ; just check '\0'
    cmp al, 0
    je fi           ; this is the dnd
    ; when ah = 0xe
    ; AL = Character, BH = Page Number, BL = Color (only in graphic mode)
    mov ah, 0xe		; ah is the color
    int 0x10		; 0x10 is put a char to screen, bx, is the color, al is the charactor
    add si, 1
    jmp putLoop

fi:
    hlt
    jmp fi

hello_msg:
	db 0xa, 0xa		; I can't figure out why 0xa is new line for now
	db "hello simple os"
	db 0xa
	db 0
