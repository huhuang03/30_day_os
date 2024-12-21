;;; fucntion: load other content of the floppy after bios load first sector for us

;; the bios load this ipl to 0x7c00
;; and a secotr is 0x200 size, so the target is 0x7e00

;;; C(cylinder)柱面 H磁头 S(sector)
;;; s has 18
;;; cylinder has 18
;;; and it's in this the order if we use a file to monitor this floppy
;; floppy is C0-H0-S0 ~ C0-H0-S18 ~ C0-H1-S0 ~ C0-H1-S18 ~ C1-H0-S1
;; 80 cylinder 扇区index从1开始

%define TARGET 0X9f00

ORG 0x7c00

JMP load
nop
DB "HELLOIPL"   ; 启动去的名称可以是任意的字符串（8字节）
DW 512          ; 每个扇区的大小，fixed
DB 1            ; 簇的大小，fixed
DW 1            ; FAT的起始位置（一般从第一个扇区开始）
DB 2            ; FAT的个数，fixed
DW 224          ; 根目录的大小（一般设置为224项）
DW 2880         
DB 0xf0         
DW 9
DW 18
DW 2
DD 0
DD 2880
DB 0, 0, 0x29
DD 0xffffffff
DB "HELLO-OS   "    ; len. 11
DB "FAT12   "       ; len.  8
RESB 18

load:
	mov al, 17
	mov bx, TARGET
	shr bx, 4
	mov es, bx
	mov ch, 0
	mov cl, 2
	mov dh, 0
	jmp load_loop

;; 每次读取al, 第一次读取17个，之后每次都读取18个sector
load_loop:				
;; es, bx is the target
;; al count of sector, max i 63
;; ch 柱面号的低8位
;; cl 底6位为扇区号，高2位存储柱面号的高2位
;; dh 磁头号
;; dl 驱动器号，0x0为软盘，0x80为硬盘
	call show_info

	;; how to loop dh?
	mov al, 18					; num of flooy to read
	mov dl, 0					; A驱动器
	mov bx, 0 					; read floop to [es:bx]
	mov ah, 2					; read
	int 0x13
	jc error					; carry if something error

next:
	push bx
	mov bx, es
	add bx, 0x240
	mov es, bx
	pop bx

	mov cl, 1
	;; 磁头循环
	add dh, 1
	cmp dh, 2
	jb load_loop				; dh < 2, load again

	mov dh, 0
	add ch, 1
	cmp ch, 80				; check 柱面
	jb load_loop				 
	;; 好像永远走不到这里吗
	jmp error
	jmp fin

error:
	mov si, err_msg
	jmp put_loop

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

show_info:
 ;; show ch and ah
	push ax

	mov al, ch
	add al, '0'
	mov ah, 0x0e
	int 0x10

	mov al, dh
	add al, '0'
	mov ah, 0x0e
	int 0x10

	mov al, cl
	add al, '0'
	mov ah, 0x0e
	int 0x10

	mov al, ' '
	int 0x10
	pop ax
	ret
;; end show ch and ah

put_loop:
	mov al, [si]				; al = the char to show
	add si, 1
	cmp al, 0
	JE _hlt
	mov ah, 0xe					; ah = 0xe show char
	INT 0x10
	jmp put_loop

TIMES 512-2-($-$$) DB 0
DB 0x55, 0xaa		; magic word that is a ilp