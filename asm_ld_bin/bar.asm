.text:
    global bar

bar:
; not good!!
; because you don't know the abs address, if it's by ld
	mov si, msg

put_loop:
	mov al, [si]				; al = the char to show
	add si, 1
	cmp al, 0
	JE _hlt
	mov ah, 0xe					; ah = 0xe show char
	mov bx, 15
	INT 0x10
	jmp put_loop

_hlt:
	hlt
	jmp _hlt

.data:
msg:
	DB 0x0a,0x0a
	DB "hello bar"
	DB 0x0a
	DB 0