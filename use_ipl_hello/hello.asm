; [org 0xc200]

mov ax, hello_msg
add ax, 0xc200
mov si, ax

putloop:	
	;; [si] is the char*
	mov al, [si]
	cmp al, 0
	je fi
	mov ah, 0xe		; ah is the color
	int 0x10		; 0x10 is put a char to screen, bx, is the color, al is the charactor
	add si, 1
	jmp putloop

fi:
    hlt
    jmp fi

hello_msg:
    db 0xa, 0xa
    db "Hello from hello"
    db 0xa, 0xa, 0x0


;; just clean?

; ORG 0xc200
; mov al, 0x13
; mov ah, 0x00
; int 0x10

; fin:
; 	hlt
; 	jmp fin