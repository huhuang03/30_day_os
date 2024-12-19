;;; fucntion: load other content of the floppy after bios load first sector for us

;; the bios load this ipl to 0x7c00??
;; and a secotr is 0x200 size, so the target is 0x7e00

;;; C(cylinder)柱面 H磁头 S(sector)
;;; s has 18
;;; cylinder has 18
;;; and it's in this the order if we use a file to monitor this floppy
;; floppy is C0-H0-S0 ~ C0-H0-S18 ~ C0-H1-S0 ~ C0-H1-S18 ~ C1-H0-S1
;; 80 cylinder 扇区index从1开始

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

error:
	mov si, err_msg
	jmp put_loop

put_loop:
	mov al, [si]				; al = the char to show
	add si, 1
	cmp al, 0
	JE _hlt
	mov ah, 0xe					; ah = 0xe show char
	mov bx, 15
	INT 0x10
	jmp put_loop


load:
	mov al, 17
	mov bx, TARGET
	mov es, bx
	jmp load_loop
	mov ch, 0
	mov cl, 2
	mov dh, 0

;; 每次读取al, 第一次读取17个，之后每次都读取18个sector
load_loop:				
;; es, bx is the target
;; al count of sector, max i 63
;; ch 柱面号的低8位
;; cl 底6位为扇区号，高2位存储柱面号的高2位
;; dh磁头号
;; dl驱动器号，0x0为软盘，0x80为硬盘

	mov ah, 2					; read
	;; how to loop dh?
	mov dl, 0					; A驱动器
	mov bx, 0
	;; read floop to [es:bx]
	int 0x13
	jc error

next:
	mov bx, es
	add bx, 0x2400
	mov es, bx
	;; 磁头循环
	mov cl, 1
	mov al, 18
	add dh, 1
	cmp dh, 2
	jb load_loop				; dh < 2, load again
	mov dh, 0
	add ch, 1
	cmp ch, 0x80				; check 柱面
	jb load_loop				 
	jmp fin

_hlt:
	hlt
	jmp _hlt

;; if not jump to os, whty hilt??
fin:
	JMP TARGET
	; HLT
	; JMP fin

err_msg:
	DB 0x0a,"load sector wrong", 0x0a
	DB 0

msg:
	DB 0xa,0xa
	DB "Hello, world"
	DB 0xa
	DB 0
	TIMES 512-2-($-$$) DB 0
	DB 0x55, 0xaa		; magic word that is a ilp