ORG 0x7e00

start:
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

err_msg:
	DB 0x0a,"load sector wrong",0x0a
	DB 0

	DB "CURRENT ADDRESS: ", $
	DB "END"
	DB "$$ADDRESS: ", $$
	DB "END"

msg:
	DB 0x0a,0x0a
	DB "Hello, world"
	DB 0x0a
	DB 0
	TIMES 0x200 - ($-$$) - 2 DB 0
	DB 0x55, 0xaa		; magic word that is a ilp
	TIMES 0x168000 - ($-$$) DB 0