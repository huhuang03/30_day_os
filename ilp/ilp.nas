;;; fucntion: load other content of the floppy after bios load first sector for us

;; the bios load this ipl to 0x7c00??
;; and a secotr is 0x200 size, so the target is 0x7e00

;;; C(cylinder)柱面 H磁头 S(sector)
;;; s has 18
;;; cylinder has 18
;;; and it's in this the order if we use a file to monitor this floppy

%define TARGET 0X7C00

ORG 0x7c00

JMP load			; eb00(if start is at 2) jmp xx, 2 byte size
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

load:
	mov ax, TARGET				; target
	mov es, ax					;; 
	mov ch, 0					; target
	mov dh, 0					; 磁头
	mov cl, 2					; 扇区
	mov ch, 0	

	mov al, 1					; num of sector
	mov bx, 0

	mov dl, 0x0					; A驱动器
	int 0x13

error:
	mov si, err_msg
	jmp _hlt

put_loop:
	mov al, [si]				; al = the char to show
	add si, 1
	cmp al, 0
	JE _hlt
	mov ah, 0xe					; ah = 0xe show char
	mov bx, 15
	INT 0x10
	jmp put_loop


load_loop:
	pass

_hlt:
	hlt
	jmp hlt

;; if not jump to os, whty hilt??
fin:
	JMP TARGET
	; HLT
	; JMP fin

err_msg:
	DB "\nload sector wrong\n"
	DB 0

msg:
	DB "\n\n"
	DB "Hello, world"
	DB "\n"
	DB 0
	FILL_EMPTY equ 0x7dff-2-$
	RESB FILL_EMPTY
	DB 0x55, 0xaa		; magic word that is a ilp
	
