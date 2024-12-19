;;; fucntion: load other content of the floppy after bios load first sector for us

;; the bios load this ipl to 0x7c00??
;; and a secotr is 0x200 size, so the target is 0x7e00

;;; C(cylinder)柱面 H磁头 S(sector)
;;; s has 18
;;; cylinder has 18
;;; and it's in this the order if we use a file to monitor this floppy

ORG 0x7c00

JMP start			; eb00(if start is at 2) jmp xx, 2 byte size
nop				; 1 byte size
db "HELLOLPL"			; must 8 byte
dw 521				; a sector size
db 1				; cluster size, must be 1
dw 1
db 2
dw 224
db 0xf0
dw 0
dw 18
dw 2
dd 0
dd 2880
db 0, 0, 0x29
dd 0xffffff
db "Hello-OS   "	; size must be 11 byte
db "FAT12   "		; must be 8 byte
RESB 18			 

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
	DB "\nload sector wrong\n"
	DB 0

msg:
	DB "\n\n"
	DB "Hello, world"
	DB "\n"
	DB 0
	FILL_EMPTY equ 0x200-2-$
	RESB FILL_EMPTY
	; RESB 0x7e00
	DB 0x55, 0xaa		; magic word that is a ilp
	_RESB equ 0x168000-$
	RESB _RESB